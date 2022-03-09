<?php

    class Model_DbTable_PieceJointe extends Zend_Db_Table_Abstract
    {
        protected $_name="piecejointe"; // Nom de la base
        protected $_primary = "ID_PIECEJOINTE"; // Clé primaire

        public function affichagePieceJointe($table, $champ, $identifiant)
        {
            $select = $this->select()
                ->setIntegrityCheck(false)
                ->from("piecejointe")
                ->join($table, "piecejointe.ID_PIECEJOINTE = $table.ID_PIECEJOINTE")
                ->where($champ." = ".$identifiant)
                ->order("piecejointe.ID_PIECEJOINTE DESC");

            return ( $this->fetchAll( $select ) != null ) ? $this->fetchAll( $select )->toArray() : null;
        }

        public function maxPieceJointe()
        {
            //echo "les champs : ".$table.$champ.$identifiant."<br/>";
            $select = "SELECT MAX(ID_PIECEJOINTE)
            FROM piecejointe
            ;";
            //echo $select;
            return $this->getAdapter()->fetchRow($select);
        }
        
        // Added by George: pour l'intitule de la piece jointe // modifié par Taoufik le 27/08/2020 (correction de la requete et refactorisation des codes)
        // Increment de l'intitule de la pj ==> newPJ
        public function newUserPieceJointe()
        {
			$idSessionUser = Zend_Auth::getInstance()->getIdentity()['ID_UTILISATEUR'];
			$idUtilisateur = ((strlen($idSessionUser) < 2) ? "0" . $idSessionUser : $idSessionUser); // (G) retrouver l'id de l'utilisateur
			$dateDuJour = new Zend_Date();
			$year_user = $dateDuJour -> get(Zend_Date::YEAR_SHORT).$idUtilisateur;
			$year_user_length = strlen($year_user);
            //$select = "SELECT MAX(CAST(NOM_PIECEJOINTE as UNSIGNED)) as nomPJ FROM `piecejointe` WHERE `EXTENSION_PIECEJOINTE` = '.odt' AND NOM_PIECEJOINTE like '$year_user%';";
			$select = "SELECT MAX(CAST(substring_index(`NOM_PIECEJOINTE`,'-',-1) as UNSIGNED)) as nomPJ FROM piecejointe WHERE `EXTENSION_PIECEJOINTE` = '.odt' AND NOM_PIECEJOINTE like '$year_user-%'";
			//on recupère le nom de la dernière PJ de l'utilisateur actuel
			$maxPJ = $this -> getAdapter() -> fetchRow($select);
			//construction du nom de la PJ
			$nomPJ = $year_user;
			if (is_null($maxPJ['nomPJ'])) {
				$first = '-0001';
				$nomPJ .= strval($first);
			} else {
				//$increment = substr($maxPJ['nomPJ'], $year_user_length); 
				//print_r($increment); die;
				$increment = $maxPJ['nomPJ'];
				$increment++;
				if (strlen($increment) < 4) {
					$zeros = 4 - strlen($increment);
					for ($l = 1; $l <= $zeros; $l++) {
						$increment = "0".$increment;
					}
				}
				$nomPJ .= '-'.$increment;
			}
			
            return $nomPJ;
        }
        /*
        * descriptionPiece : le description de la PJ
        *@param
        *@return  String $descPj
        */
        public function descriptionPiece($id_dossier) {
        // Retrouver le libelle et le type du dossier correspondant
            $desc = "";
            
            $select = "SELECT 
                        dossier.OBJET_DOSSIER, dossiertype.LIBELLE_DOSSIERTYPE 
                    FROM 
                        dossiertype 
                    INNER JOIN 
                        dossier 
                    ON 
                        dossiertype.ID_DOSSIERTYPE = dossier.TYPE_DOSSIER 
                    WHERE 
                        dossier.ID_DOSSIER = '".$id_dossier."'";
                
            $result_type = $this->getAdapter()->fetchRow($select);

            if($result_type){
                $desc = $result_type['OBJET_DOSSIER']." ".$result_type['LIBELLE_DOSSIERTYPE'];
            }
            // Retrouver nature du dossier correspondant
            $select2 = "SELECT 
                    LIBELLE_DOSSIERNATURE 
                FROM 
                    dossiernatureliste 
                INNER JOIN 
                    dossiernature 
                ON 
                    dossiernatureliste.ID_DOSSIERNATURE = dossiernature.ID_NATURE 
                WHERE 
                    dossiernature.ID_DOSSIER = '".$id_dossier."'";
            
            $result_nat = $this->getAdapter()->fetchRow($select2);
            
            if($result_nat){
                $desc .= " ".$result_nat['LIBELLE_DOSSIERNATURE'];
            }
            
            return $desc;
        }
		
		public function infosDossierPiece($id_dossier) {
			$select = "SELECT * from dossier where dossier.ID_DOSSIER = '".$id_dossier."'";
			$result_infos = $this->getAdapter()->fetchRow($select);
			
			return $result_infos;
		}
    }
