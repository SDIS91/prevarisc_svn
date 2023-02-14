-- POUR BASE DE DONNEE prevarisc TABLE etablissement
-- OBJECTIF  :  envoyer un message au documentaliste quand le numeroid de l'etablissement change
--
-- Déclencheur `etablissement`
--
DROP TRIGGER IF EXISTS `alertedoc`;
DELIMITER //
CREATE TRIGGER `alertedoc` AFTER UPDATE ON `etablissement`
FOR EACH ROW BEGIN

IF NEW.NUMEROID_ETABLISSEMENT <> OLD.NUMEROID_ETABLISSEMENT THEN
    SET @message = CONCAT('Modification du numéro ERP ', OLD.NUMEROID_ETABLISSEMENT, ' en ', NEW.NUMEROID_ETABLISSEMENT, ' le ', DATE_FORMAT(NOW(), "%d/%m/%Y"));
    INSERT INTO news (TYPE_NEWS, TEXTE_NEWS, ID_UTILISATEUR) VALUES ('Informations', @message, '1'); 
END IF;

END
//
DELIMITER ;


-- POUR BASE DE DONNEE prevarisc TABLE news
-- OBJECTIF  :  specifier le groupe qui recoit l'alerte
--
-- Déclencheur `news`
--
DROP TRIGGER IF EXISTS `alertedoc2`;
DELIMITER //
CREATE TRIGGER `alertedoc2` AFTER INSERT ON `news`

FOR EACH ROW BEGIN

INSERT INTO newsgroupe (ID_NEWS, ID_GROUPE) VALUES (NEW.ID_NEWS, '12');

END
//
DELIMITER ;