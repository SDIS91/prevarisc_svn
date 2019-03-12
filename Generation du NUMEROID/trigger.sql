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
DROP TRIGGER IF EXISTS `update`;
DELIMITER //
CREATE TRIGGER `update` AFTER INSERT ON `etablissementadresse`
 FOR EACH ROW BEGIN
 
SET @idmax = (SELECT max(etablissementinformations.ID_ETABLISSEMENT) FROM etablissementinformations);
 
SET @genre = (SELECT (mid(LIBELLE_GENRE,1,1)) FROM genre,etablissementinformations 
            WHERE genre.ID_GENRE=etablissementinformations.ID_GENRE
            AND etablissementinformations.ID_ETABLISSEMENT=(SELECT max(etablissement.ID_ETABLISSEMENT) FROM etablissement));
            
SET @insee = (SELECT (mid(NUMINSEE_COMMUNE,3,3)) FROM etablissementadresse,etablissement
            WHERE etablissement.ID_ETABLISSEMENT=etablissementadresse.ID_ETABLISSEMENT
            AND etablissementadresse.ID_ETABLISSEMENT=@idmax);


SET @reqLast = (SELECT min(rank) as valeur from (
SELECT @rn:=@rn+1 AS rank,ITERATION FROM(SELECT cast(mid(NUMEROID_ETABLISSEMENT,5,5) as int) as ITERATION FROM etablissement where mid(NUMEROID_ETABLISSEMENT,2,3)=@insee GROUP BY ITERATION ORDER BY ITERATION) t1, (SELECT @rn:=0) t2
) as tempo WHERE rank<>ITERATION);
   

SET @l=length(@reqLast);   
SET @iteration = @reqLast;
WHILE  @l< 5 DO
    SET @iteration = (SELECT CONCAT( '0', @iteration));
    SET @l= @l + 1;
END WHILE;

SET @erp = (SELECT CONCAT(@genre, @insee, @iteration));

UPDATE etablissement SET NUMEROID_ETABLISSEMENT=@erp WHERE ID_ETABLISSEMENT=@idmax;
              
END
//
DELIMITER ;