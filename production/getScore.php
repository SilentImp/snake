<?php

header('Cache-Control: no-cache, must-revalidate');
header('Expires: Mon, 26 Jul 1997 05:00:00 GMT');
header('Content-type: application/json');

if(file_exists('score.json')){
  $score = file_get_contents('score.json');
}else{
  $score = json_encode(array());
}

die($score);

?>