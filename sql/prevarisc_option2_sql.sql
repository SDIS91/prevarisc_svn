
-- ajout de statut (modification annulée) => demande de Karine le 20/05/2021
--INSERT INTO `statut` (`ID_STATUT`, `LIBELLE_STATUT`) VALUES (NULL, 'En exploitation');
-- INSERT INTO `statut` (`ID_STATUT`, `LIBELLE_STATUT`) VALUES (NULL, "Cessation d'activité");

-- ajout de genre
INSERT INTO `genre` (`ID_GENRE`, `LIBELLE_GENRE`) VALUES (NULL, 'Linéaire - Fluvial');
INSERT INTO `genre` (`ID_GENRE`, `LIBELLE_GENRE`) VALUES (NULL, 'Linéaire - Transport guidé');
INSERT INTO `genre` (`ID_GENRE`, `LIBELLE_GENRE`) VALUES (NULL, 'Linéaire - Routier');
INSERT INTO `genre` (`ID_GENRE`, `LIBELLE_GENRE`) VALUES (NULL, 'Plans');
INSERT INTO `genre` (`ID_GENRE`, `LIBELLE_GENRE`) VALUES (NULL, 'Linéaire - Fluides')

-- le cas de gestion des dossiers :  

--ajout de dossiertype

INSERT INTO `dossiertype` (`ID_DOSSIERTYPE`, `LIBELLE_DOSSIERTYPE`) VALUES ('9', 'Avis Prévision');

-- pour alimenter la liste des dossier 

--- ajout de dossier nature

INSERT INTO `dossiernatureliste` (`ID_DOSSIERNATURE`, `LIBELLE_DOSSIERNATURE`, `ID_DOSSIERTYPE`, `ORDRE`) VALUES (NULL, "Dossier de Demande d'Autorisation Environnementale", '1', 1);

INSERT INTO `dossiernatureliste` (`ID_DOSSIERNATURE`, `LIBELLE_DOSSIERNATURE`, `ID_DOSSIERTYPE`, `ORDRE`) VALUES (NULL, "Demande d'enregistrement", '1', 1);

INSERT INTO `dossiernatureliste` (`ID_DOSSIERNATURE`, `LIBELLE_DOSSIERNATURE`, `ID_DOSSIERTYPE`, `ORDRE`) VALUES (NULL, "Plan d'intervention", '1', 1);

INSERT INTO `dossiernatureliste` (`ID_DOSSIERNATURE`, `LIBELLE_DOSSIERNATURE`, `ID_DOSSIERTYPE`, `ORDRE`) VALUES (NULL, "Plan d'urbanisme", '1', 1);

INSERT INTO `dossiernatureliste` (`ID_DOSSIERNATURE`, `LIBELLE_DOSSIERNATURE`, `ID_DOSSIERTYPE`, `ORDRE`) VALUES (NULL, "Porter à connaissance", '1', 1);

INSERT INTO `dossiernatureliste` (`ID_DOSSIERNATURE`, `LIBELLE_DOSSIERNATURE`, `ID_DOSSIERTYPE`, `ORDRE`) VALUES (NULL, 'Autre', '1', 1);




-- pour le type "Avis Prévision" : même chose que le type "Etude" :

INSERT INTO `dossiernatureliste` (`ID_DOSSIERNATURE`, `LIBELLE_DOSSIERNATURE`, `ID_DOSSIERTYPE`, `ORDRE`) VALUES (null, 'Permis de construire (PC)', 9, 2);
INSERT INTO `dossiernatureliste` (`ID_DOSSIERNATURE`, `LIBELLE_DOSSIERNATURE`, `ID_DOSSIERTYPE`, `ORDRE`) VALUES (null, 'Autorisation de travaux (AT)', 9, 1);
INSERT INTO `dossiernatureliste` (`ID_DOSSIERNATURE`, `LIBELLE_DOSSIERNATURE`, `ID_DOSSIERTYPE`, `ORDRE`) VALUES (null, 'Demande de Dérogation', 9, 5);
INSERT INTO `dossiernatureliste` (`ID_DOSSIERNATURE`, `LIBELLE_DOSSIERNATURE`, `ID_DOSSIERTYPE`, `ORDRE`) VALUES (null, 'Cahier des charges fonctionnel du SSI', 9, 13);
INSERT INTO `dossiernatureliste` (`ID_DOSSIERNATURE`, `LIBELLE_DOSSIERNATURE`, `ID_DOSSIERTYPE`, `ORDRE`) VALUES (null, 'Cahier des charges', 9, 15);
INSERT INTO `dossiernatureliste` (`ID_DOSSIERNATURE`, `LIBELLE_DOSSIERNATURE`, `ID_DOSSIERTYPE`, `ORDRE`) VALUES (null, 'PC / PCM / AT communs', 9, 4);
INSERT INTO `dossiernatureliste` (`ID_DOSSIERNATURE`, `LIBELLE_DOSSIERNATURE`, `ID_DOSSIERTYPE`, `ORDRE`) VALUES (null, 'Levée de prescriptions', 9, 12);
INSERT INTO `dossiernatureliste` (`ID_DOSSIERNATURE`, `LIBELLE_DOSSIERNATURE`, `ID_DOSSIERTYPE`, `ORDRE`) VALUES (null, 'Documents divers', 9, 23);
INSERT INTO `dossiernatureliste` (`ID_DOSSIERNATURE`, `LIBELLE_DOSSIERNATURE`, `ID_DOSSIERTYPE`, `ORDRE`) VALUES (null, 'Changement de DUS (Directeur unique de sécurité)', 9, 10);
INSERT INTO `dossiernatureliste` (`ID_DOSSIERNATURE`, `LIBELLE_DOSSIERNATURE`, `ID_DOSSIERTYPE`, `ORDRE`) VALUES (null, "Demande d'implantation CTS < 6mois", 9, 21);
INSERT INTO `dossiernatureliste` (`ID_DOSSIERNATURE`, `LIBELLE_DOSSIERNATURE`, `ID_DOSSIERTYPE`, `ORDRE`) VALUES (null, "Demande d'implantation CTS > 6mois", 9, 22);
INSERT INTO `dossiernatureliste` (`ID_DOSSIERNATURE`, `LIBELLE_DOSSIERNATURE`, `ID_DOSSIERTYPE`, `ORDRE`) VALUES (null, "Permis d'aménager (PA)", 9, 7);
INSERT INTO `dossiernatureliste` (`ID_DOSSIERNATURE`, `LIBELLE_DOSSIERNATURE`, `ID_DOSSIERTYPE`, `ORDRE`) VALUES (null, "Utilisation exceptionnelle de locaux", 9, 9);
INSERT INTO `dossiernatureliste` (`ID_DOSSIERNATURE`, `LIBELLE_DOSSIERNATURE`, `ID_DOSSIERTYPE`, `ORDRE`) VALUES (null, "Diagnostique sécurité", 9, 16);
INSERT INTO `dossiernatureliste` (`ID_DOSSIERNATURE`, `LIBELLE_DOSSIERNATURE`, `ID_DOSSIERTYPE`, `ORDRE`) VALUES (null, 'Echéancier de travaux', 9, 11);
INSERT INTO `dossiernatureliste` (`ID_DOSSIERNATURE`, `LIBELLE_DOSSIERNATURE`, `ID_DOSSIERTYPE`, `ORDRE`) VALUES (null, "Certificats d'urbanisme (CU)", 9, 8);
INSERT INTO `dossiernatureliste` (`ID_DOSSIERNATURE`, `LIBELLE_DOSSIERNATURE`, `ID_DOSSIERTYPE`, `ORDRE`) VALUES (null, "Demande d'organisation de manifestation temporaire", 9, 17);
INSERT INTO `dossiernatureliste` (`ID_DOSSIERNATURE`, `LIBELLE_DOSSIERNATURE`, `ID_DOSSIERTYPE`, `ORDRE`) VALUES (null, "Modification Classement / Effectif", 9, 18);
INSERT INTO `dossiernatureliste` (`ID_DOSSIERNATURE`, `LIBELLE_DOSSIERNATURE`, `ID_DOSSIERTYPE`, `ORDRE`) VALUES (null, 'Permis de construire modificatif (PCM)', 9, 3);
INSERT INTO `dossiernatureliste` (`ID_DOSSIERNATURE`, `LIBELLE_DOSSIERNATURE`, `ID_DOSSIERTYPE`, `ORDRE`) VALUES (null, 'Demande préalable (DP)', 9, 6);
INSERT INTO `dossiernatureliste` (`ID_DOSSIERNATURE`, `LIBELLE_DOSSIERNATURE`, `ID_DOSSIERTYPE`, `ORDRE`) VALUES (null, 'Certificat de conformité', 9, 14);
INSERT INTO `dossiernatureliste` (`ID_DOSSIERNATURE`, `LIBELLE_DOSSIERNATURE`, `ID_DOSSIERTYPE`, `ORDRE`) VALUES (null, 'Homologation CTS', 9, 19);
INSERT INTO `dossiernatureliste` (`ID_DOSSIERNATURE`, `LIBELLE_DOSSIERNATURE`, `ID_DOSSIERTYPE`, `ORDRE`) VALUES (null, 'Retrait de conformité CTS', 9, 20); 
INSERT INTO `dossiernatureliste` (`ID_DOSSIERNATURE`, `LIBELLE_DOSSIERNATURE`, `ID_DOSSIERTYPE`, `ORDRE`) VALUES (NULL, "Dossier de Demande d'Autorisation Environnementale", 9, 1);
INSERT INTO `dossiernatureliste` (`ID_DOSSIERNATURE`, `LIBELLE_DOSSIERNATURE`, `ID_DOSSIERTYPE`, `ORDRE`) VALUES (NULL, "Demande d'enregistrement", 9, 1);
INSERT INTO `dossiernatureliste` (`ID_DOSSIERNATURE`, `LIBELLE_DOSSIERNATURE`, `ID_DOSSIERTYPE`, `ORDRE`) VALUES (NULL, "Plan d'intervention", 9, 1);
INSERT INTO `dossiernatureliste` (`ID_DOSSIERNATURE`, `LIBELLE_DOSSIERNATURE`, `ID_DOSSIERTYPE`, `ORDRE`) VALUES (NULL, "Plan d'urbanisme", 9, 1);
INSERT INTO `dossiernatureliste` (`ID_DOSSIERNATURE`, `LIBELLE_DOSSIERNATURE`, `ID_DOSSIERTYPE`, `ORDRE`) VALUES (NULL, "Porter à connaissance", 9, 1);
INSERT INTO `dossiernatureliste` (`ID_DOSSIERNATURE`, `LIBELLE_DOSSIERNATURE`, `ID_DOSSIERTYPE`, `ORDRE`) VALUES (NULL, 'Autre', 9, 1);

-- ajout de service instructeur (à voir avec Karine) : page 29 ==> 
-- la table en question est "`groupement`" : avec ID_GROUPEMENTTYPE = 10 (service instructeur) : il me faut le ID_UTILISATEURINFORMATIONS : 
-- j'ai trouvé (table : utilisteurinformations) pour Evry : ID_UTILISATEURINFORMATIONS = 54 (PETEL YANN), pour essonne (52 : TRON Georges)
-- ?????????????????????? 
-- pour tester avec le profil de Karine (ID_UTILISATEURINFORMATIONS = 10)
-- modification de "DRIEE" par "DRIEAT" demandé par Karine le 21/05/2021
INSERT INTO `groupement` (`ID_GROUPEMENT`, `LIBELLE_GROUPEMENT`, `ID_UTILISATEURINFORMATIONS`, `ID_GROUPEMENTTYPE`) VALUES (NULL, 'DRIEAT', '10', '10');
INSERT INTO `groupement` (`ID_GROUPEMENT`, `LIBELLE_GROUPEMENT`, `ID_UTILISATEURINFORMATIONS`, `ID_GROUPEMENTTYPE`) VALUES (NULL, 'BDPC', '10', '10');
INSERT INTO `groupement` (`ID_GROUPEMENT`, `LIBELLE_GROUPEMENT`, `ID_UTILISATEURINFORMATIONS`, `ID_GROUPEMENTTYPE`) VALUES (NULL, 'Commune', '10', '10')

-- demandé par Karine le 28/10/2020
INSERT INTO `groupement` (`ID_GROUPEMENT`, `LIBELLE_GROUPEMENT`, `ID_UTILISATEURINFORMATIONS`, `ID_GROUPEMENTTYPE`) VALUES (NULL, 'DIRECCTE', '10', '10')


-- ajout de la nature "compte-rendu" au type "Groupe de visite" 
INSERT INTO `dossiernatureliste` (`ID_DOSSIERNATURE`, `LIBELLE_DOSSIERNATURE`, `ID_DOSSIERTYPE`, `ORDRE`) VALUES (NULL, 'Compte-rendu', '3', '7');

-- ajout de la nature "Information" au type "Courrier /couriel" 
INSERT INTO `dossiernatureliste` (`ID_DOSSIERNATURE`, `LIBELLE_DOSSIERNATURE`, `ID_DOSSIERTYPE`, `ORDRE`) VALUES (NULL, 'Information', '5', '13');

-- ajout de la nature "Préfectoral", "Municipal", "Autre"
INSERT INTO `dossiernatureliste` (`ID_DOSSIERNATURE`, `LIBELLE_DOSSIERNATURE`, `ID_DOSSIERTYPE`, `ORDRE`) VALUES (NULL, 'Préfectoral', '7', '6');
INSERT INTO `dossiernatureliste` (`ID_DOSSIERNATURE`, `LIBELLE_DOSSIERNATURE`, `ID_DOSSIERTYPE`, `ORDRE`) VALUES (NULL, 'Municipal', '7', '7');
INSERT INTO `dossiernatureliste` (`ID_DOSSIERNATURE`, `LIBELLE_DOSSIERNATURE`, `ID_DOSSIERTYPE`, `ORDRE`) VALUES (NULL, 'Autre', '7', '8');

-- ajout de la nature "Etablissements Prévision" au type "Intervention" 

INSERT INTO `dossiernatureliste` (`ID_DOSSIERNATURE`, `LIBELLE_DOSSIERNATURE`, `ID_DOSSIERTYPE`, `ORDRE`) VALUES (NULL, 'Etablissements Prévision', '6', '3');


-- une nouvelle demande : remplacement de AS par SH

-- demande de karine le 14/01/2021 ajout de type de plan
INSERT INTO `typeplan` (`ID_TYPEPLAN`, `LIBELLE_TYPEPLAN`) VALUES (NULL, 'ORSEC'); 
INSERT INTO `typeplan` (`ID_TYPEPLAN`, `LIBELLE_TYPEPLAN`) VALUES (NULL, 'PPRT'); 
INSERT INTO `typeplan` (`ID_TYPEPLAN`, `LIBELLE_TYPEPLAN`) VALUES (NULL, 'PSI'); 
INSERT INTO `typeplan` (`ID_TYPEPLAN`, `LIBELLE_TYPEPLAN`) VALUES (NULL, 'PPP'); 
INSERT INTO `typeplan` (`ID_TYPEPLAN`, `LIBELLE_TYPEPLAN`) VALUES (NULL, 'PSS'); 
INSERT INTO `typeplan` (`ID_TYPEPLAN`, `LIBELLE_TYPEPLAN`) VALUES (NULL, 'PCS'); 
INSERT INTO `typeplan` (`ID_TYPEPLAN`, `LIBELLE_TYPEPLAN`) VALUES (NULL, 'PPE'); 
INSERT INTO `typeplan` (`ID_TYPEPLAN`, `LIBELLE_TYPEPLAN`) VALUES (NULL, 'PPRI'); 
INSERT INTO `typeplan` (`ID_TYPEPLAN`, `LIBELLE_TYPEPLAN`) VALUES (NULL, 'PPRN'); 
INSERT INTO `typeplan` (`ID_TYPEPLAN`, `LIBELLE_TYPEPLAN`) VALUES (NULL, 'PLU'); 
INSERT INTO `typeplan` (`ID_TYPEPLAN`, `LIBELLE_TYPEPLAN`) VALUES (NULL, 'PUI'); 
INSERT INTO `typeplan` (`ID_TYPEPLAN`, `LIBELLE_TYPEPLAN`) VALUES (NULL, 'PIS'); 

--- suite à la reunion du 01/04/2021 : mettre la date du 01/04/2021 à la place des dates null  (2734 PJ ont été modifiée)
UPDATE `piecejointe` SET `DATE_PIECEJOINTE` = '2021-04-01' WHERE `DATE_PIECEJOINTE` is null 

--- correction demandée par pascal le 29/04/2021

UPDATE `fonction` SET `LIBELLE_FONCTION` = 'Contrôleur technique (organisme agréé)' WHERE `fonction`.`ID_FONCTION` = 6; 