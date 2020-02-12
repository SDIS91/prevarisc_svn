<?php
/**
 * Intervention ponctuelle dans Prevarisc
 *
 * La fenetre de telechargement des pieces jointes affiche par defaut
 * un intitule et un descriptif de la piece jointe
 *
 * PHP version 5.6.20
 *
 * @category Hack
 * @package  Hack
 * @author   George Kandalaft <gkandalaft@sdis91.fr>
 * @license  http://opensource.org/licenses/gpl-license.php GNU Public License
 * @version  SVN: 191
 * @link     http://subversion/trac/browser/prev_temporaire
 */

// Retrouver l'id de l'utilisateur par la session et l'ajouter a l'annee en cours
$user = date('y');
$user_id = strlen(strval($_SESSION['Zend_Auth']['storage']['ID_UTILISATEUR']));
//$increment = ($user_id > 2 ? '00' : '000');
$user .= ($user_id < 2 ? "0".$_SESSION['Zend_Auth']['storage']['ID_UTILISATEUR'] : $_SESSION['Zend_Auth']['storage']['ID_UTILISATEUR']);
$position = strlen($user);

// Retrouver la derniere entree de l'utilisateur et l'incrementer pour renseigner l'intitule
$mysqli = new mysqli("localhost", "prevarisc", "prevarisc", "prevarisc");
$select_title = $mysqli->query(
    "SELECT 
        MAX(NOM_PIECEJOINTE) 
    FROM 
        piecejointe 
    WHERE 
        SUBSTRING(NOM_PIECEJOINTE, 1, " . $position . ") = '" . $user."'"
    );
$result_title = $select_title -> fetch_assoc();
if (is_null($result_title['MAX(NOM_PIECEJOINTE)'])) {
    $first = '0001';
    $user .= strval($first);
} else {
    $user = $result_title['MAX(NOM_PIECEJOINTE)'] + 1;
}
// Retrouver le libelle et le type du dossier correspondant
$id_dossier = $_POST['id'];
$select_type = $mysqli->query(
    "SELECT 
        dossier.OBJET_DOSSIER, dossiertype.LIBELLE_DOSSIERTYPE 
    FROM 
        dossiertype 
    INNER JOIN 
        dossier 
    ON 
        dossiertype.ID_DOSSIERTYPE = dossier.TYPE_DOSSIER 
    WHERE 
        dossier.ID_DOSSIER = '".$id_dossier."'");
$result_type = $select_type -> fetch_assoc();
$desc = $result_type['OBJET_DOSSIER']." ".$result_type['LIBELLE_DOSSIERTYPE'];

// Retrouver nature du dossier correspondant
$select_nat = $mysqli->query(
    "SELECT 
        LIBELLE_DOSSIERNATURE 
    FROM 
        dossiernatureliste 
    INNER JOIN 
        dossiernature 
    ON 
        dossiernatureliste.ID_DOSSIERNATURE = dossiernature.ID_NATURE 
    WHERE 
        dossiernature.ID_DOSSIER = '".$id_dossier."'");
$result_nat = $select_nat->fetch_assoc();
$desc .= " ".$result_nat['LIBELLE_DOSSIERNATURE'];
