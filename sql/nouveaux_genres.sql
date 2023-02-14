SET NAMES 'utf8';

# Nouveaux genres
INSERT INTO `genre` (`ID_GENRE`, `LIBELLE_GENRE`) VALUES (12, 'Divers');
UPDATE genre SET LIBELLE_GENRE = "Travail (Code)" WHERE ID_GENRE = 6;
UPDATE genre SET LIBELLE_GENRE = "Camping" WHERE ID_GENRE = 7;

# Nouvelles ressources
INSERT INTO `resources`(`id_resource`,`name`, `text`) VALUES
(104,'etablissement_div_0_0','Divers (Ignorer les groupements - Ignorer la commune)');

# Nouveaux privileges
INSERT INTO `privileges` VALUES 
(134,'view_ets','Lecture',104),
(135,'edit_ets','Modifier',104);

# modifier le genre divers
UPDATE etablissementinformations SET ID_GENRE = 12 WHERE ID_GENRE = 7;

# Renommer code du travail
UPDATE etablissement a JOIN etablissementinformations b ON b.ID_ETABLISSEMENT = a.ID_ETABLISSEMENT SET a.`NUMEROID_ETABLISSEMENT` = CONCAT('T', MID(a.NUMEROID_ETABLISSEMENT, 2)) WHERE b.`ID_GENRE` = 6;