drop FUNCTION IF EXISTS `NUM_ERPV2`;

DELIMITER $$
CREATE DEFINER = CURRENT_USER 
    FUNCTION `NUM_ERPV2`(`id_etb` BIGINT(20)) 
    RETURNS char(9) CHARSET utf8
    READS SQL DATA


/*
SDIS 91 - OR - 24/08/2016

procédure stockée permettant de formaliser etablissement.numeroid suivant la codification ERP V2
GIII00000
G : Genre de l établissement
III : Code insee de la commune
00000 : Compteur itératif par code insee

Paramétre entrant id_etb = clef d identification de l établissement id_etablissement
Paramétre sortant chaine formaté de 9 caractéres

nota : la codification inital ERP V2 contenait en fin lexpression -000 destinée à gérer 
la filiation des établissements entre eux. Cette codification est abandonné dans prevarisc du fait du mode de gestion prévu
*/



BEGIN

DECLARE etb_genre char(1);
DECLARE max_genre bigint(20);
DECLARE etb_insee char(3);
DECLARE etb_iter char(5);

DECLARE numerp_conform tinyint(1);
DECLARE etb_old_genre char(1);
DECLARE etb_old_insee char(3);
DECLARE old_numeroid varchar(50);

CALL CONFORM_NUM_ERPV2(id_etb, old_numeroid, numerp_conform, etb_old_genre, etb_old_insee);

SET max_genre = (SELECT 
                    MAX(etablissementinformations.ID_ETABLISSEMENTINFORMATIONS) 
                FROM 
                    etablissementinformations
                WHERE
                    etablissementinformations.ID_ETABLISSEMENT = id_etb);

SET etb_genre = (SELECT 
                    DISTINCT (MID(LIBELLE_GENRE, 1, 1)) 
                FROM 
                    genre, etablissementinformations 
                WHERE 
                    genre.ID_GENRE = etablissementinformations.ID_GENRE
                AND 
                    etablissementinformations.ID_ETABLISSEMENTINFORMATIONS = max_genre);

IF etb_genre IS NULL THEN
    return NULL;
END IF;

SET etb_insee = (SELECT 
                    MIN(MID(NUMINSEE_COMMUNE, 3, 3))
                FROM 
                    etablissementadresse,etablissement
                WHERE 
                    etablissement.ID_ETABLISSEMENT = id_etb
                AND 
                    etablissementadresse.ID_ETABLISSEMENT = id_etb);

IF etb_insee IS NULL THEN
    return NULL;
END IF;

SET etb_iter = (SELECT 
                    MIN(compteur) AS valeur 
                FROM
                    (SELECT 
                        insee, CAST(MID(iteration, 4, 5) AS int) AS iter, @compteur := @compteur + 1 AS compteur 
                    FROM 
                        (SELECT 
                            MID(NUMEROID_ETABLISSEMENT, 2, 3) AS insee, CAST(MID(NUMEROID_ETABLISSEMENT, 2, 9) AS int) AS iteration 
                        FROM 
                            etablissement
                        GROUP BY 
                            iteration) AS tempo, (SELECT 
                                                    @compteur := 0) AS t 
                                                WHERE 
                                                    insee = etb_insee 
                                                ORDER BY 
                                                    ITERATION) AS final 
                WHERE 
                    iter <> compteur);

IF etb_iter IS NULL THEN
    SET etb_iter = (SELECT 
                        MAX(MID(NUMEROID_ETABLISSEMENT, 5, 5)) + 1 AS iteration 
                    FROM 
                        etablissement 
                    WHERE 
                        MID(NUMEROID_ETABLISSEMENT, 2, 3) = etb_insee
                    ORDER BY 
                        iteration);
END IF;
 
WHILE length(etb_iter) < 5 DO
     SET etb_iter = CONCAT('0', etb_iter);
END WHILE;

IF numerp_conform = 1 AND etb_genre = etb_old_genre AND etb_insee = etb_old_insee THEN
    return old_numeroid; 
ELSEIF numerp_conform = 1 AND etb_genre <> etb_old_genre AND etb_insee = etb_old_insee THEN
    return CONCAT(etb_genre, MID(old_numeroid, 2));
ELSE
    return CONCAT(etb_genre, etb_insee, etb_iter);
END IF;

END$$
DELIMITER ;