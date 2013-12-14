<?php

$mckey = "LD28_DATA";

$salt = "FUCKYOUHEADCRUSHER24";

$game_name = "GAME NAME";

// OH GOD STOP

$memcache = new Memcache; //point 2. 
$memcache->addServer("localhost");

// RESET
//$memcache->delete($mckey);


$db = $memcache->get($mckey);

if($db == false){// INIT THE DB
  $db = new stdClass();
  $db->users = array();
  $db->itemtypes = array();
}

function dbsave(){
  global $memcache;
  global $db;
  global $mckey;
  $memcache->set($mckey,$db,MEMCACHE_COMPRESSED,0);
}
