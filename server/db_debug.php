<?php

require('config.php');

foreach($db->users as $user){
  unset($user->password);
  unset($user->key);
}

print_r($db);


