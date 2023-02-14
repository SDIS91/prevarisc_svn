SELECT case
            when SUBSTRING([LIB_DOSSIER_INITIAL], 1, 2) in ('PC','AT')
                then [LIB_DOSSIER_INITIAL]
            when [ID_DOSSIERNATURE] = 1
                then 'PC' + [LIB_DOSSIER_INITIAL]
            when [ID_DOSSIERNATURE] = 2
                then 'AT' + [LIB_DOSSIER_INITIAL]
            end as NUM_DOCURBA
      ,[ID_DOSSIE] as ID_DOSSIER
  FROM [WinprevVersPrevarisc ].[dbo].[CREA_DOSSIERS_EXPORT_PREVARISC]
  where [ID_DOSSIERNATURE] in (1,2) 
  and SUBSTRING([LIB_DOSSIER_INITIAL], 2, 1) <> '/' 
  and [LIB_DOSSIER_INITIAL] not like '%visite%' 
  and (SUBSTRING([LIB_DOSSIER_INITIAL], 1, 2) in ('PC','AT')
  or (ascii(SUBSTRING([LIB_DOSSIER_INITIAL], 1, 1)) between 48 and 57
  and ascii(SUBSTRING([LIB_DOSSIER_INITIAL], 2, 1)) between 48 and 57))