<?php

require('config.php');

function gameage_sort($a,$b){
  if(!isset($a->gameage)){ return true; }
  if(!isset($b->gameage)){ return false; }
  return $a->gameage > $b->gameage;
}

function kill_death_sort($a,$b){
  if(!isset($a->gameage)){ return true; }
  if(!isset($b->gameage)){ return false; }
  return $a->kills-$a->deaths < $b->kills-$b->deaths;
}

?>
<h1>Scores</h1>

<a href="index.php">Return</a>

<h2>Top Ten Kill/Death Ratio Players</h2>
<ol>
<?php
$count = 0;
uasort($db->users,'kill_death_sort');
foreach($db->users as $user){
  $count++;
  if(isset($user->gameage)){
    echo "<li>".$user->name."(".$user->kills."/".$user->deaths.")</li>";
  }
  if($count >= 10){
    break;
  }
}
?>
</ol>

<h2>In Game Players</h2>
<ol>
<?php

uasort($db->users,'gameage_sort');
$count = 0;
foreach($db->users as $user){
  $count++;
  if(isset($user->gameage)){
    echo "<li>";
    echo $user->name." (".(time()-$user->gameage)."s)";
    if($count <= 10){
      echo " (".$user->x.",".$user->y.",".$user->z.")";
    }
    echo "</li>";
  }
}
?>
</ol>


