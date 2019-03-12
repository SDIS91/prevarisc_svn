drop FUNCTION IF EXISTS `score`;

DELIMITER $$
CREATE DEFINER = CURRENT_USER 
    FUNCTION `score`(`etb_insee` char(3)) 
    RETURNS char(5) CHARSET utf8
    READS SQL DATA
BEGIN
DECLARE etb_iter char(5);
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

WHILE LENGTH(etb_iter) < 5 DO
     SET etb_iter = CONCAT('0', etb_iter);
END WHILE;

RETURN etb_iter;

END