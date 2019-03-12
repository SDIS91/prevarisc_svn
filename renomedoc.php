<?php

ini_set('max_execution_time', 3600); // 1h

// declaration des repertoires
$path_abs = '/home/interface';
$path_log = $path_abs.'/log/';
$path = '/home/www/prevarisc/public/data/uploads/pieces-jointes/';

$start = date("d-m-Y H:i:s");

$logfile = $path_log.'rename_log';

$logmode = 'a';
if ($lfp = fopen($logfile, $logmode)) {
    fwrite($lfp, "\nStarted at $start\n");

    define('HOST', 'localhost');
    define('DBNAME', 'prevarisc'); 
    define('USERNAME', 'root');
    define('PASSWORD', 'lmdpqt6');

    // begin added by george
    // Connexion
    $mysqli = new mysqli(HOST,USERNAME,PASSWORD,DBNAME);
    if ($mysqli -> connect_errno) {
        $err = "Failed to connect to MySQL: ( $mysqli->connect_errno ) 
            $mysqli->connect_error<br>";
        echo "<br>$err<br>";
        exit;
    }

    function requete($sql) {
        $req = $sql -> fetch_assoc();
        return $req;
    }

    $time_deb = time(true);
    /**
     * Renomme chaque fichier dans le dossier ETUDES
     */
    $files = scandir($path);
    $flag = 0;
    foreach($files as $file){
        if($file[0] != '.' ){
            /**
             *  Retourne le nouveau nom du fichier doc ID_PIECEJOINTE+EXTENSION_PIECEJOINTE
             */
            $oldname = $file;
            $nompj = basename ($oldname,'.DOC');
            fwrite($lfp, "\n\nnompj : $nompj\n\n");
            $dot = strpos($nompj, '.');
            if ($dot === true) {
                $prenom = explode('.', $nompj);
                $nompj = $prenom[0];
            }
            $sql = $mysqli -> query("SELECT ID_PIECEJOINTE FROM piecejointe WHERE NOM_PIECEJOINTE='$nompj'");
            if (!$sql) {
                $err = "Could not run query on spip_evenements: ("
                        . $mysqli -> errno . ") "
                        . $mysqli -> error . "<br>";
                echo "<br>$err<br>";
                exit;
            }
            if ($sql -> num_rows > 0) {
                $req = $sql -> fetch_assoc();
                $newname = $req['ID_PIECEJOINTE'].'.doc';
                $flag = 1;
            } else {
                $non = "\n\n$nompj pas dans la base\n\n";
                fwrite($lfp, $non);
            }
            
            if (!empty($newname and $flag == 1)){
                $line = "$oldname;$newname\n";
                fwrite($lfp, $line);
                rename($path.$oldname, $path.$newname);
            }
        }
        $flag = 0;
    }
    $time_fin = time(true);
    $exec_time = $time_fin - $time_deb;
    $time = "Temps d'excution : $exec_time s\n";
    fwrite($lfp, $time);
}
fclose($lfp);
