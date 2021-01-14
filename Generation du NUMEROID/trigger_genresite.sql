-- POUR BASE DE DONNEE prevarisc TABLE etablissementlie

-- OBJECTIF  :  Le site prend le numeroid de l'etablissement lie
-- 
--PRINCIPE :

--
-- Déclencheurs `etablissementlie`
--
DROP TRIGGER IF EXISTS `genresite`;
DELIMITER //
CREATE TRIGGER `genresite` AFTER INSERT ON `etablissementlie`
FOR EACH ROW BEGIN

SET @genre_s = (SELECT ID_GENRE FROM etablissementinformations WHERE ID_ETABLISSEMENTINFORMATIONS = (SELECT MAX(info.ID_ETABLISSEMENTINFORMATIONS) FROM etablissementinformations AS info WHERE info.ID_ETABLISSEMENT = NEW.ID_ETABLISSEMENT));

SET @genre_b = (SELECT ID_GENRE FROM etablissementinformations WHERE ID_ETABLISSEMENTINFORMATIONS = (SELECT max(info.ID_ETABLISSEMENTINFORMATIONS) FROM etablissementinformations AS info WHERE info.ID_ETABLISSEMENT = NEW.ID_FILS_ETABLISSEMENT));

IF (@genre_s = 1) THEN
    SET @existe = (SELECT etablissement.NUMEROID_ETABLISSEMENT FROM etablissement WHERE etablissement.ID_ETABLISSEMENT = NEW.ID_ETABLISSEMENT);
    SET @existe = SUBSTR(@existe, 1, 1);
    IF (@existe != 'S') THEN
        SET @pos = (SELECT position('-' in etablissement.NUMEROID_ETABLISSEMENT) FROM etablissement WHERE etablissement.ID_ETABLISSEMENT = NEW.ID_FILS_ETABLISSEMENT);
        IF (@pos > 0) THEN
            SET @new_numeroid_fils = (SELECT SUBSTR(etablissement.NUMEROID_ETABLISSEMENT, 1, 9) FROM etablissement WHERE etablissement.ID_ETABLISSEMENT = NEW.ID_FILS_ETABLISSEMENT);
        ELSE
            SET @new_numeroid_fils = (SELECT etablissement.NUMEROID_ETABLISSEMENT FROM etablissement WHERE etablissement.ID_ETABLISSEMENT = NEW.ID_FILS_ETABLISSEMENT);
        END IF;
        SET @new_numeroid_fils = SUBSTR(@new_numeroid_fils, 2);
        SET @new_numeroid = CONCAT('S', @new_numeroid_fils);
        UPDATE etablissement SET NUMEROID_ETABLISSEMENT = @new_numeroid WHERE ID_ETABLISSEMENT = NEW.ID_ETABLISSEMENT;
    END IF;
ELSEIF (@genre_b = 3) THEN
	SET @length_numeroid = (SELECT LENGTH(etablissement.NUMEROID_ETABLISSEMENT) FROM etablissement WHERE etablissement.ID_ETABLISSEMENT = NEW.ID_FILS_ETABLISSEMENT);
    SET @existe = (SELECT etablissement.NUMEROID_ETABLISSEMENT FROM etablissement WHERE etablissement.ID_ETABLISSEMENT = NEW.ID_FILS_ETABLISSEMENT);
    SET @existe = SUBSTR(@existe, 1, 1);
    IF (@existe != 'B') THEN
		IF (@length_numeroid = 13) THEN
			SET @ancien_num = (SELECT etablissement.NUMEROID_ETABLISSEMENT FROM etablissement WHERE etablissement.ID_ETABLISSEMENT = NEW.ID_FILS_ETABLISSEMENT);
			SET @new_numeroid_fils = CONCAT('B',SUBSTR(@ancien_num, 2));
			UPDATE etablissement SET NUMEROID_ETABLISSEMENT = @new_numeroid_fils WHERE ID_ETABLISSEMENT = NEW.ID_FILS_ETABLISSEMENT;
		ELSE
			SET @new_numeroid = (SELECT etablissement.NUMEROID_ETABLISSEMENT FROM etablissement WHERE etablissement.ID_ETABLISSEMENT = NEW.ID_ETABLISSEMENT);
			SET @new_numeroid = SUBSTR(@new_numeroid, 2);
			SET @etb_insee = SUBSTR(@new_numeroid, 1, 3);
			IF (@existe REGEXP '^[0-9]$') THEN
				SET @etb_iter = score(@etb_insee);
				SET @new_numeroid_fils = CONCAT('B', @etb_insee, @etb_iter);
			ELSE
				SET @new_numeroid_fils = CONCAT('B', @new_numeroid);
			END IF;
			UPDATE etablissement SET NUMEROID_ETABLISSEMENT = @new_numeroid_fils WHERE ID_ETABLISSEMENT = NEW.ID_FILS_ETABLISSEMENT;
		END IF;
    END IF;
END IF;

END
//
DELIMITER ;