<?php

function render_requests($user,$input){
  update_user($user);
  if(is_array($input->requests)){
    $ret = array();
    foreach($input->requests as $key => $request){
      $ret[$key] = render_request($user,$request);
    }
    return $ret;
  } else {
    return array();
  }
}

function render_request($user,$request){
  if(is_string($request->func)){
    $fname = "api_".$request->func;
    if(function_exists($fname)){
      return $fname($user,isset($request->args) ? $request->args : array() );
    } else {
      $ret = new stdClass();
      $ret->error = array("Function not availible.");
      return $ret;
    }
  }
}

function default_user($user){
  $user->x = isset($user->x) ? $user->x : 0;
  $user->y = isset($user->y) ? $user->y : 0;
  $user->z = isset($user->z) ? $user->z : 0;
  $user->warp_eta = isset($user->warp_eta) ? $user->warp_eta : 0;
  $user->warp_range = isset($user->warp_range) ? $user->warp_range : 100;
  $user->speed = isset($user->speed) ? $user->speed : 1;
  $user->range = isset($user->range) ? $user->range : 10;
  return $user;
}

function dist($a,$b){
  return sqrt(
    pow($a->x - $b->x,2) +
    pow($a->y - $b->y,2) +
    pow($a->z - $b->z,2)
  );
}

function update_user($user){
  $duser = default_user($user);
  if($duser->warp_eta <= time()){
    $user->warp_eta = 0;
    dbsave();
  }
}

function api_getuser($user,$args){
  $duser = default_user($user);
  $ruser = new stdClass();
  $ruser->x = $duser->x;
  $ruser->y = $duser->y;
  $ruser->z = $duser->z;
  $ruser->warp_eta = $duser->warp_eta;
  $ruser->warp_range = $duser->warp_range;
  $ruser->speed = $duser->speed;
  $ret = new stdClass();
  $ret->ret = $ruser;
  return $ret;
}

function api_getusers($user,$args){
  global $db;
  $duser = default_user($user);
  if($duser->warp_eta > 0){
    return array();
  }
  $list = array();
  foreach($db->users as $dbuser){

    $ddbuser = default_user($dbuser);
    if(
      $ddbuser->name != $duser->name and
      $ddbuser->warp_eta == 0 and
      dist($ddbuser,$duser) < $duser->range
    ){
      $ruser = new stdClass();
      $ruser->name = $ddbuser->name;
      $ruser->x =$ddbuser->x;
      $ruser->y =$ddbuser->y;
      $ruser->z =$ddbuser->z;
      $list[] = $ruser; 
    }
    
  }
  $ret = new stdClass();
  $ret->ret = $list;
  return $ret;
}

function api_move($user,$args){
  $duser = default_user($user);
  if($duser->warp_eta > 0){
    $ret = new stdClass();
    $ret->error = array("You are currently in warp.");
    return $ret;
  }
  $valid = true;
  if(!isset($args->x) or !is_int($args->x)){$valid = false; }
  if(!isset($args->y) or !is_int($args->y)){$valid = false; }
  if(!isset($args->z) or !is_int($args->z)){$valid = false; }

  if($valid){

    if(
      $duser->x == $args->x and 
      $duser->y == $args->y and 
      $duser->z == $args->z){
      $ret = new stdClass();
      $ret->error = array("You are already at this location.");
      return $ret;
    }

    $dist = dist($args,$duser);
    if($dist <= $duser->warp_range){
      $user->warp_eta = time() + ceil($dist/$duser->speed);
      $user->x = $args->x;
      $user->y = $args->y;
      $user->z = $args->z;
      dbsave();
      return new stdClass();
    } else {
      $ret = new stdClass();
      $ret->error = array("You cannot travel more than ".$duser->warp_range." units.");
      return $ret;
    }

  } else {
    $ret = new stdClass();
    $ret->error = array("Invalid arguments");
    return $ret;
  }

}
