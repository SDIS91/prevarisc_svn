/* Bloc "Etudes en attente de traitement par type de commission" en remplacement du bloc "Dossiers suivis non verrouillés" dans le Dashboard.*/
UPDATE `privileges` SET `name` = 'view_commissions_etudes', `text` = 'Voir les études en attente de traitement' WHERE `privileges`.`id_privilege` = 108;
