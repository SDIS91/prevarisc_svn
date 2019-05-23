-- OR / GP RCCI / SDIS 91 / Fonctionnelle le 30 avril 2019 --


-- tableau récapitulatif des avis défavorables reprenant les items du tableau Excel existant
-- N° ERP **
-- Commune **
-- Genre (condition ERP, Boutique, IGH) **
-- Nom de l'établissement **
-- Adresse (condition si voie inconnue prendre complement d'adresse) **
-- Arrondissement, **
-- Classement (type, catégorie, Classe) **
-- Motif (analyse du risque du dernier avis def) 
-- présence de locaux à sommeil **
-- Observations autres 
-- Historique des visites depuis 1er avis def de la série **
-- Date première SCD en avis défavorable)**
SELECT 	
		DER_FICHE_ETB.ID_ETB,
		DER_FICHE_ETB.LAST_ID_ETAB_INFO,
        -- NUMERO ERP --
        ETB.NUMEROID_ETABLISSEMENT,
        -- GENRE --
        genre.LIBELLE_GENRE,
        -- PERIODICITE --
		ETB_INFO.PERIODICITE_ETABLISSEMENTINFORMATIONS as PERIODICITE,
        -- NOM ETABLISSEMENT --
        ETB_INFO.LIBELLE_ETABLISSEMENTINFORMATIONS as NOM_ETB,
        -- HEBERGEMENT --
        if(ETB_INFO.LOCALSOMMEIL_ETABLISSEMENTINFORMATIONS=1,"OUI","NON") as LAS,
        -- CLASSEMENT --
		coalesce (libelle_classe,concat (libelle_type, " ", libelle_categorie)) as CLASSEMENT,
        -- ADRESSE --
        CASE -- boutique --
			WHEN genre.ID_GENRE=3 then ADRESSE_PERE.Adresse
			Else ADRESSE_FILS.adresse
		END AS ADRESSE,
        -- COMMUNE --
        CASE -- boutique --
			WHEN genre.ID_GENRE=3 then ADRESSE_PERE.COMMUNE_PERE
			Else ADRESSE_FILS.COMMUNE_FILS
		END AS COMMUNE,
         -- COMMUNE --
        CASE -- boutique --
			WHEN genre.ID_GENRE=3 then ADRESSE_PERE.ARROND_PERE
			Else ADRESSE_FILS.ARROND_FILS
		END AS ARRONDISSEMENT,
        -- CAUSES AVIS DEF --
        DERNIER_DOSSIER_DEF.ANOMALIE_DOSSIER,
        -- AUTRES OBSERVATION --
        DERNIER_DOSSIER_DEF.OBSERVATION_DOSSIER as AUTRES_OBSERVATIONS,
        -- DATE PREMIERS AVIS DEF DE LA SERIE --
        Date_Origine_Avis_Def
		-- HISTORIQUE --
		NATURE,
		HISTORIQUE.ID_DOSS,
		HISTORIQUE.TYPEDOSSIER,
		HISTORIQUE.DATE_REF,
		HISTORIQUE.AVIS_DEF
        
FROM 
 (select 
	ID_ETABLISSEMENT as ID_ETB,
    max(ID_ETABLISSEMENTINFORMATIONS) as LAST_ID_ETAB_INFO
    from etablissementinformations 
    group by ID_ETABLISSEMENT order by id_etablissement) as DER_FICHE_ETB
    
JOIN etablissementinformations AS ETB_INFO on ETB_INFO.ID_ETABLISSEMENTINFORMATIONS= DER_FICHE_ETB.LAST_ID_ETAB_INFO 
JOIN etablissement AS ETB on ETB.ID_ETABLISSEMENT=DER_FICHE_ETB.ID_ETB
JOIN dossier AS DERNIER_DOSSIER_DEF on ETB.ID_DOSSIER_DONNANT_AVIS=DERNIER_DOSSIER_DEF.ID_DOSSIER 
JOIN genre on ETB_INFO.ID_GENRE=genre.id_genre
left JOIN etablissementlie on etablissementlie.ID_FILS_ETABLISSEMENT=DER_FICHE_ETB.ID_ETB

left JOIN (select ID_ETABLISSEMENT, ARROND.COMMUNE as COMMUNE_FILS,ARROND.ARRONDISSEMENT AS ARROND_FILS,
		CASE
			When adresserue.LIBELLE_RUE = "VOIE @ VOIE INCONNUE" then trim(concat("VI - " ,etablissementadresse.NUMERO_ADRESSE," " , etablissementadresse.complement_adresse))
			Else trim(concat(etablissementadresse.NUMERO_ADRESSE," " , adresserue.LIBELLE_RUE))
		END as Adresse 
		from etablissementadresse
		join adresserue on adresserue.id_rue=etablissementadresse.ID_RUE
		join (SELECT 
				libelle_groupement as ARRONDISSEMENT,adressecommune.LIBELLE_COMMUNE as COMMUNE, adressecommune.NUMINSEE_COMMUNE as INSEE
				FROM groupement 
			JOIN groupementcommune on groupementcommune.id_groupement=groupement.id_groupement
			JOIN adressecommune on adressecommune.NUMINSEE_COMMUNE=groupementcommune.NUMINSEE_COMMUNE
			where id_groupementtype=2) as ARROND on ARROND.INSEE=adresserue.NUMINSEE_COMMUNE) AS ADRESSE_FILS 
        on ADRESSE_FILS.id_etablissement=DER_FICHE_ETB.ID_ETB

left JOIN (select ID_ETABLISSEMENT, ARROND.COMMUNE as COMMUNE_PERE,ARROND.ARRONDISSEMENT AS ARROND_PERE,
		CASE
			When adresserue.LIBELLE_RUE = "VOIE @ VOIE INCONNUE" then trim(concat("VI - " ,etablissementadresse.NUMERO_ADRESSE," " , etablissementadresse.complement_adresse))
			Else trim(concat(etablissementadresse.NUMERO_ADRESSE," " , adresserue.LIBELLE_RUE))
		END as Adresse 
		from etablissementadresse
		join adresserue on adresserue.id_rue=etablissementadresse.ID_RUE
		join (SELECT 
				libelle_groupement as ARRONDISSEMENT,adressecommune.LIBELLE_COMMUNE as COMMUNE, adressecommune.NUMINSEE_COMMUNE as INSEE
				FROM groupement 
			JOIN groupementcommune on groupementcommune.id_groupement=groupement.id_groupement
			JOIN adressecommune on adressecommune.NUMINSEE_COMMUNE=groupementcommune.NUMINSEE_COMMUNE
			where id_groupementtype=2) as ARROND on ARROND.INSEE=adresserue.NUMINSEE_COMMUNE) AS ADRESSE_PERE
        on ADRESSE_PERE.id_etablissement=etablissementlie.ID_ETABLISSEMENT

-- HISTORIQUE --

left JOIN((SELECT 
	'SUIVI PREFECTORAL' as NATURE,
    etablissementdossier.ID_DOSSIER as ID_DOSS,
    etablissementdossier.ID_ETABLISSEMENT as HIST_ID_ETB,
	dossiernatureliste.LIBELLE_DOSSIERNATURE as TYPEDOSSIER,
    CASE
		when dossiernatureliste.ID_DOSSIERNATURE=79 then  ifnull(date_format(dossier.DATEREP_DOSSIER,"%d / %m / %Y"),"indéterminée")
        ELse  ifnull(date_format(dossier.datesign_dossier,"%d / %m / %Y"),"indéterminée")
	END as DATE_REF,
    dossier.OBJET_DOSSIER as AVIS_DEF


FROM prevarisc.dossiernature
join dossiernatureliste on dossiernature.ID_NATURE=dossiernatureliste.ID_DOSSIERNATURE
join dossier on dossier.ID_DOSSIER=dossiernature.ID_DOSSIER

join  etablissementdossier on etablissementdossier.ID_DOSSIER=dossier.ID_DOSSIER
 
where dossier.type_dossier=8) 

 
 union 
 
(SELECT 
	'VISITE' as NATURE,
	etablissementdossier.ID_DOSSIER as ID_DOSS,
    etablissementdossier.ID_ETABLISSEMENT as HIST_ID_ETB,
		dossiernatureliste.LIBELLE_DOSSIERNATURE as TYPEDOSSIER,
    ifnull(date_format(dossier.DATEVISITE_DOSSIER,"%d / %m / %Y"),"indéterminée") as DATEREF,
	LIBELLE_AVIS as AVIS_DEF

FROM prevarisc.dossiernature
join dossiernatureliste on dossiernature.ID_NATURE=dossiernatureliste.ID_DOSSIERNATURE
join dossier on dossier.ID_DOSSIER=dossiernature.ID_DOSSIER
join avis on avis.id_avis=dossier.AVIS_DOSSIER_COMMISSION
join  etablissementdossier on etablissementdossier.ID_DOSSIER=dossier.ID_DOSSIER
 
 where dossier.type_dossier=2
 
)  order by HIST_ID_ETB asc, id_doss asc

 ) AS HISTORIQUE on HISTORIQUE.HIST_ID_ETB=DER_FICHE_ETB.ID_ETB
-- FIN HISTORIQUE --


left join type  on ETB_INFO.id_type=type.ID_TYPE
left join categorie  on ETB_INFO.id_categorie=categorie.id_categorie 
left join classe  on ETB_INFO.ID_CLASSE=classe.ID_CLASSE
left join etablissementadresse as ETB_ADR on DER_FICHE_ETB.ID_ETB=ETB_ADR.ID_ETABLISSEMENT


left JOIN adresserue as RUE on ETB_ADR.id_rue=RUE.ID_RUE

left JOIN (SELECT 
etablissementdossier.ID_ETABLISSEMENT as ID_FIRST_DEF,
 DATEVISITE_DOSSIER as Date_Origine_Avis_Def,
min(etablissementdossier.id_dossier)

from 
	(	select max(premier_avis_def) as ID_FIRST_AVT_DEF,
		FAD_ID_ETB 
		from (	SELECT 
					dossier.id_dossier as premier_avis_def,
					etablissementdossier.ID_ETABLISSEMENT as FAD_ID_ETB
				FROM prevarisc.dossier 
				join etablissementdossier on dossier.ID_DOSSIER=etablissementdossier.ID_DOSSIER
				join dossiertype on dossier.TYPE_DOSSIER=dossiertype.ID_DOSSIERTYPE
				join etablissement on etablissement.ID_ETABLISSEMENT=etablissementdossier.ID_ETABLISSEMENT
				WHERE
					dossiertype.ID_DOSSIERTYPE=2 -- visite de commission--
					and ifnull(dossier.AVIS_DOSSIER_COMMISSION,0)<>2 -- pas avis défavorable
					and dossier.id_dossier<etablissement.ID_DOSSIER_DONNANT_AVIS
				order by etablissementdossier.ID_ETABLISSEMENT asc, dossier.id_dossier desc) as GRP group by FAD_ID_ETB ) AS LAST_BEFORE_DEF
                

join etablissementdossier on LAST_BEFORE_DEF.FAD_ID_ETB=etablissementdossier.ID_ETABLISSEMENT
join dossier on dossier.ID_DOSSIER=etablissementdossier.id_dossier
join dossiertype on dossier.TYPE_DOSSIER=dossiertype.ID_DOSSIERTYPE

where 

dossiertype.ID_DOSSIERTYPE=2 -- visite de commission--
and dossier.id_dossier>LAST_BEFORE_DEF.ID_FIRST_AVT_DEF 

group by etablissementdossier.ID_ETABLISSEMENT) AS FIRST_DEF on FIRST_DEF.ID_FIRST_DEF=DER_FICHE_ETB.ID_ETB

WHERE

ETB_INFO.id_GENRE in (2,3,5) --  ERP, Boutique, IGH --
and  DERNIER_DOSSIER_DEF.AVIS_DOSSIER_COMMISSION=2 -- Défavorable--
and ETB_INFO.id_statut=2 -- Ouvert--