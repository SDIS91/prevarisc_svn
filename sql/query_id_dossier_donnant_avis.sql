-- POUR BASE DE DONNEE prevarisc TABLE etablissement

-- OBJECTIF  :  Alimenter le champ ID_DOSSIER_DONNANT_AVIS dans la table etablissemen
-- 
--PRINCIPE :        

UPDATE 
    etablissement
SET 
    ID_DOSSIER_DONNANT_AVIS = 
(SELECT 
    b.ID_DOSSIER 
FROM 
    (SELECT 
        dossier.ID_DOSSIER, max(dossier.DATEVISITE_DOSSIER), etablissementdossier.ID_ETABLISSEMENT 
    FROM 
        `dossier` 
    INNER JOIN 
        `etablissementdossier` 
    ON 
        dossier.ID_DOSSIER = etablissementdossier.ID_DOSSIER 
    WHERE 
        dossier.DATEVISITE_DOSSIER is not null 
    AND 
        dossier.TYPE_DOSSIER=2 
    AND 
        dossier.AVIS_DOSSIER_COMMISSION in (1,2) 
    GROUP BY 
        etablissementdossier.ID_ETABLISSEMENT) 
AS 
    b 
WHERE 
    b.ID_ETABLISSEMENT = etablissement.ID_ETABLISSEMENT);
