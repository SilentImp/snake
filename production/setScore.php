<?php

if(!isset($_POST['score'])||!isset($_POST['name'])){
  die('а нэээту');
}

header('Cache-Control: no-cache, must-revalidate');
header('Expires: Mon, 26 Jul 1997 05:00:00 GMT');
header('Content-type: application/json');

if(file_exists('score.json')){
  $score = json_decode(file_get_contents('score.json'), true);
}else{
  $score = array();
}

array_push($score, array((int)$_POST['score'], preg_replace('/[^a-z ]*/i',"",$_POST['name'])));

for($i=0; $i<count($score); $i++){
  for($k=0; $k<count($score); $k++){
    if($score[$i][0]>$score[$k][0]){
      $tmp = $score[$k];
      $score[$k] = $score[$i];
      $score[$i] = $tmp;
    }
  }
}

$score = json_encode(array_slice($score,0,10));

file_put_contents('score.json', $score);

die($score);

?>