<?php

ini_set("display_errors", 1);
ini_set('max_execution_time', 3600); // 1h

$path_abs = '/home/www/html/prevarisc/public/';
$path_log = $path_abs.'/log/';
$path = '/home/www/html/prevarisc/public/tmp_PJ';
$destination = '/home/www/html/prevarisc/public/propre_pj/';

$user ="root";
$host ="localhost";
$password ="lmdpqt6";
$database ="geside_recup";
$connect = new mysqli($host, $user, $password, $database);

$doc = array();
$fichiers = array();
$tab_extension = array('pdf','PDF','doc','DOC','xls','XLS','csv','CSV','pps','PPS','ppt','PPT','jpg','JPG','odt','ODT','zip','ZIP','png','PNG','rtf','RTF','docx','DOCX');

$files = scandir($path);

foreach($files as $file){

	$fichier = explode(".", $file);
	
	for($j=0; $j< 24; $j++){
		
		if($fichier[1] == $tab_extension[$j]){
			$nompj = $file;
			$sql = $connect -> query("SELECT * FROM fichiersdisque WHERE NOM_FICHIER = '$nompj'");
			$data = $sql -> fetch_row();
			
			//Array ( [0] => 1 [1] => 1.pdf [2] => .pdf [3] => 2011-12-08 [4] => 51672 [5] => 32344 [6] => ) 

			if(isset($data) && count($data)>0 && $data[4] > 0){
				//je renomme les fichiers
				$newname = $data[4].'.'.strtolower($tab_extension[$j]);
				rename($path.'/'.$file, $destination.'/'.$newname);
				echo '- '.$file.'  ==>  renomme en =======> '.$newname;
				echo '<br>';
			}
		}
	}
}

?>