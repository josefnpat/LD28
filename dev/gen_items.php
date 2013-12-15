<?php

$raw = file_get_contents("base_items.json");

$j = json_decode($raw);

$mod = array();
$mod['player_hp'] = 0.4;
$mod['enemy_hp'] = 0.2;
$mod['base_hp'] = 0.1;

$mod['player_ap'] = 0.25;
$mod['enemy_ap'] = 0.5;
$mod['base_ap'] = 0.75;

$mod['player_evade'] = 0.05;
$mod['enemy_evade'] = 0.02;
$mod['base_evade'] = 0.04;

$mod['player_lock'] = 1.5;
$mod['enemy_lock'] = 1.5;
$mod['base_lock'] = 1.5;

$n = array();

foreach($j as $item_real){

  for($i = 1; $i <=6; $i++){

    $item = clone $item_real;
    foreach($item as $fk => $fv){
      if(isset($mod[$fk])){
        $item->$fk = floor($item->$fk * (1+$mod[$fk]*$i));
      }
    }
    $item->name .= " T$i";
    $item->t = $i;
    $item->value *= $i;
    $n[] = $item;
  }
  
}
echo json_encode($n);
