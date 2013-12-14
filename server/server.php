<?php

require('config.php');

require('render.php');

$return = new stdClass();
$return->error = array();

if(isset($_GET['i'])){
  $sha_in = substr($_GET['i'],0,40);
  $raw_in = substr($_GET['i'],40);

  if( ($in = json_decode($raw_in)) !== NULL ){
    $found_user = false;
    foreach($db->users as $user){
      if($user->name == $in->username){
        $raw_total = stripslashes($raw_in.$user->key);
        if( isset($user->key) and sha1($raw_total) == $sha_in ){
          $return->results = render_requests($user,$in);
        } else {
          $return->error[] = "Invalid secure login key.";
        }
        $found_user = true;
        break;
      }
    }
    if(!$found_user){
      $return->error[] = "Username does not exist.";
    }
    
  } else {
    $return->error[] = 'Invalid input.';
  }
} else {
  $return->error[] = 'No input.';
}

if(count($return->error) == 0){
  unset($return->error);
}

$jout = json_encode($return);

// Why did this take so damn long to get a flag?
$jsonReplaces = array(
  array('\\\\', '\\/', '\\n', '\\t', '\\r', '\\b', '\\f', '\"'),
  array("\\", "/", "\n", "\t", "\r", "\b", "\f", '"')
);
echo str_replace($jsonReplaces[0], $jsonReplaces[1], $jout);

