<?php

/*
*@created by : Taoufik MESSAOUD, 17/02/2021
*Script qui permet comparer les pièces jointes dans une base de données avec les fichiers physique d'un dossier (PJ)
*/

ini_set("display_errors", 1);
ini_set('max_execution_time', 3600); // 1h 

$path_abs = '/home/www/html/prevarisc/public';
$path_log = $path_abs.'/log';
$path = '/home/www/html/prevarisc/public/data/uploads/pieces-jointes';
//$destination = '/home/www/html/prevarisc/public/propre_pj';

//*************
//BASE
//**************
$user ="root";
$host ="localhost";
$password ="lmdpqt6";
$database ="prevarisc";
$connect = new mysqli($host, $user, $password, $database);
 /*if ($mysqli->connect_errno) {
        $err = "Failed to connect to MySQL: ( $mysqli->connect_errno ) 
            $mysqli->connect_error\n";
        fwrite($lfp, $err);
        exit;
    }*/

//*****************
// les logs
//*****************
$start = date("d-m-Y H:i:s");
$logfile = $path_log.'/piecejointe_inexistant_dans_le_dossierPJ.log';
$logmode = 'a+';
$lfp = fopen($logfile, $logmode);

//$files = scandir($path);

$result = $connect -> query("SELECT pj.`ID_PIECEJOINTE`, pj.`EXTENSION_PIECEJOINTE`, pj.`NOM_PIECEJOINTE`, pj.`DESCRIPTION_PIECEJOINTE`, dp.ID_DOSSIER FROM `piecejointe` pj JOIN dossierpj dp on (pj.`ID_PIECEJOINTE` = dp.ID_PIECEJOINTE) WHERE `EXTENSION_PIECEJOINTE` IS NOT NULL ");

fwrite($lfp, "******Les PJ dans la base mais qui n'ont pas de fichier physique !******  \n\n");
fwrite($lfp, "\nStarted at $start\n");

if ($result->num_rows > 0) {

	while($row = $result->fetch_assoc()) {
		$nom_pj = $path.'/'.$row['ID_PIECEJOINTE'].$row['EXTENSION_PIECEJOINTE'];
		if (file_exists($nom_pj) !== true) {
			fwrite($lfp, "- ID_PIECEJOINTE : ".$row['ID_PIECEJOINTE']. "     ID_DOSSIER  ".$row['ID_DOSSIER']."   Nom ===> ".$row['NOM_PIECEJOINTE']." Déscription ======> ".$row['DESCRIPTION_PIECEJOINTE']."\n");
			print_r("***Not Existe : ".$row['ID_PIECEJOINTE'].$row['EXTENSION_PIECEJOINTE']." <br>");
		}
		/*
		if(in_array($row['ID_PIECEJOINTE'].$row['EXTENSION_PIECEJOINTE'],$files)){
			fwrite($lfp, "- ID_PIECEJOINTE : $row['ID_PIECEJOINTE'] ==> NOM_FICHIER : $row['NOM_FICHIER'] \n");
			print_r('***Existe : '.$row['ID_PIECEJOINTE'].' : '.$row['NOM_FICHIER']);
		}else{
			fwrite($lfp, "- ID_PIECEJOINTE : $row['ID_PIECEJOINTE'] ==> NOM_FICHIER : $row['NOM_FICHIER'] \n");
			print_r($row['ID_PIECEJOINTE']);
			print_r(',');
		}
		*/
	}
} else {
	print_r('pas resultats');
}

fclose($lfp);


?>