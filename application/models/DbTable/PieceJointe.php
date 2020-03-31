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
        
        // Added by George: pour l'intitule de la piece jointe
        // Increment de l'intitule de la pj
        public function maxUserPieceJointe($year_user, $userid)
        {
            //echo "les champs : ".$table.$champ.$identifiant."<br/>";
            $select = "SELECT MAX(NOM_PIECEJOINTE)
                    FROM piecejointe
                    WHERE SUBSTRING(NOM_PIECEJOINTE, 1, $userid ) = '$year_user';";
            //echo $select;
            return $this -> getAdapter() -> fetchRow($select);
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
    }
