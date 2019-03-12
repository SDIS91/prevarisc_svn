-- POUR BASE DE DONNEE prevarisc TABLE etablissementadresse

-- OBJECTIF  :  Mettre a jour le numeroid_etablissement suivant la norme usitée dans WINPREV 'GIII0000-FFF'.
--      Toutefois, la codification de filiation -FFF est abandonnée en raison du mode de gestion du lien de parenté 
--      dans PREVARISC
-- 
--PRINCIPE :        
--      Le numeroid_etablissement est constitué sur 8 caractéres
--          G : code_genre de l'établissement (1)
--          III : Code_insee de la commune (3)
--          0000 : Itération par commune (4)

-- TRIGGER   :  La mise en place du trigger va permettre le déclenchement d'une mise à jour 
--              apres l'insertion d'un etablissement possédant une adresse (à minima la commune)

--
-- Déclencheurs `etablissementadresse`
--
DROP TRIGGER IF EXISTS `updateerpv2`;
DELIMITER //
CREATE TRIGGER `updateerpv2` AFTER INSERT ON `etablissementadresse`
FOR EACH ROW BEGIN

DECLARE id_etb bigint(20);
DECLARE etb_genre char(1);
DECLARE max_genre bigint(20);
DECLARE etb_insee char(3);
DECLARE etb_iter char(5);

DECLARE numerp_conform tinyint(1);
DECLARE etb_old_genre char(1);
DECLARE etb_old_insee char(3);
DECLARE old_numeroid varchar(50);

SET @id_etb = NEW.ID_ETABLISSEMENT;

SET @old_numeroid = (SELECT 
                        NUMEROID_ETABLISSEMENT 
                    FROM 
                        etablissement 
                    WHERE 
                        id_etablissement = @id_etb);

                
IF (LENGTH(TRIM(@old_numeroid)) = 9 OR LENGTH(TRIM(@old_numeroid)) = 13) THEN 
	SET @etb_old_genre = (SELECT 
                            LEFT(LIBELLE_GENRE, 1) 
                        FROM 
                            genre 
                        WHERE 
                            LEFT(LIBELLE_GENRE, 1) = LEFT(@old_numeroid, 1));
	IF @etb_old_genre IS NOT NULL THEN
		SET @etb_old_insee = (SELECT 
                                RIGHT(NUMINSEE_COMMUNE, 3) 
                            FROM 
                                adressecommune 
                            WHERE 
                                RIGHT(NUMINSEE_COMMUNE, 3) = MID(@old_numeroid, 2, 3));
		IF @etb_old_insee IS NOT NULL THEN
			SET @numerp_conform = 1;
		ELSE
            SET @numerp_conform = 0;
		END IF;
	ELSE
		SET @numerp_conform = 0;
	END IF;
ELSE
	SET @numerp_conform = 0;
END IF;

SET @max_genre = (SELECT 
                    max(etablissementinformations.ID_ETABLISSEMENTINFORMATIONS) 
                FROM 
                    etablissementinformations
                WHERE
                    etablissementinformations.ID_ETABLISSEMENT = @id_etb);

SET @etb_genre = (SELECT 
                    DISTINCT (MID(LIBELLE_GENRE, 1, 1)) 
                FROM 
                    genre, etablissementinformations 
                WHERE 
                    genre.ID_GENRE = etablissementinformations.ID_GENRE
                AND 
                    etablissementinformations.ID_ETABLISSEMENTINFORMATIONS = @max_genre);

SET @etb_insee = (SELECT 
                    MIN(MID(NUMINSEE_COMMUNE, 3, 3)) 
                FROM 
                    etablissementadresse, etablissement
                WHERE 
                    etablissement.ID_ETABLISSEMENT = @id_etb
                AND 
                    etablissementadresse.ID_ETABLISSEMENT = @id_etb);

SET @etb_iter = score(@etb_insee);

IF @numerp_conform = 1 AND @etb_genre = @etb_old_genre AND @etb_insee = @etb_old_insee THEN
	UPDATE 
        etablissement 
    SET 
        NUMEROID_ETABLISSEMENT = @old_numeroid 
    WHERE 
        ID_ETABLISSEMENT = @id_etb;
ELSEIF @numerp_conform = 1 AND @etb_genre <> @etb_old_genre AND @etb_insee = @etb_old_insee THEN
	UPDATE 
        etablissement 
    SET 
        NUMEROID_ETABLISSEMENT = CONCAT(@etb_genre, SUBSTRING(@old_numeroid, 2)) 
    WHERE 
        ID_ETABLISSEMENT = @id_etb;
ELSE
	UPDATE 
        etablissement 
    SET 
        NUMEROID_ETABLISSEMENT = CONCAT(@etb_genre, @etb_insee, @etb_iter) 
    WHERE 
    ID_ETABLISSEMENT = @id_etb;
END IF;

END
//
DELIMITER ;