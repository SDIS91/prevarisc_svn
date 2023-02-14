<?php

/*
*@created by : Taoufik MESSAOUD, 15/02/2021
*Script qui permet renommer les pièces jointes d'un dossier, à partir d'une base de données
*/

ini_set("display_errors", 1);
ini_set('max_execution_time', 3600); // 1h 

$path_abs = '/home/www/html/prevarisc/public';
$path_log = $path_abs.'/log';
$path = '/home/www/html/prevarisc/public/tmp_PJ';
$destination = '/home/www/html/prevarisc/public/propre_pj';

//*****************
// les logs
//*****************
$start = date("d-m-Y H:i:s");
$logfile = $path_log.'/rename_log.log';
$logmode = 'a';
$lfp = fopen($logfile, $logmode);
fwrite($lfp, "\nStarted at $start\n");
$time_deb = time(true);

//*************
//BASE
//**************
$user ="root";
$host ="localhost";
$password ="lmdpqt6";
$database ="geside_recup";
$connect = new mysqli($host, $user, $password, $database);

$tab_extension = array('pdf','PDF','doc','DOC','xls','XLS','csv','CSV','pps','PPS','ppt','PPT','jpg','JPG','odt','ODT','zip','ZIP','png','PNG','rtf','RTF','docx','DOCX');

$files = scandir($path);

foreach($files as $file){

	$fichier = explode(".", $file);
	
	for($j=0; $j< 24; $j++){
		
		if($fichier[1] == $tab_extension[$j]){
			$nompj = $file;
			
			//requete qui permet de recuperer les PJ dans la table de fichiersdisque
			$sql = $connect -> query("SELECT * FROM fichiersdisque WHERE NOM_FICHIER = '$nompj'");
			$data = $sql -> fetch_row();
			
			// print_r($data) => Array ( [0] => 1 [1] => 1.pdf [2] => .pdf [3] => 2011-12-08 [4] => 51672 [5] => 32344 [6] => ) 

			if(isset($data) && count($data)>0 && $data[4] > 0){
				//je renomme les fichiers
				$newname = $data[4].'.'.strtolower($tab_extension[$j]);
				rename($path.'/'.$file, $destination.'/'.$newname);
				fwrite($lfp, "success rename : $nompj ====> $newname \n\n");
				echo '- '.$file.'  ==>  renomme en =======> '.$newname;
				echo '<br>';
			}else{
				fwrite($lfp, "KO rename : $nompj\n ");
			}
		}
	}
}

$time_fin = time(true);
$exec_time = $time_fin - $time_deb;
$time = "Temps d'excution : $exec_time s\n";
fwrite($lfp, $time);
fclose($lfp);

?>