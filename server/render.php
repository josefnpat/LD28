<?php

function render_requests($user,$input){
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
      return $fname($user,$request->args);
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
  return $user;
}

function api_getuser($user,$args){
  $duser = default_user($user);
  $ruser = new stdClass();
  $ruser->x = $duser->x;
  $ruser->y = $duser->y;
  $ruser->z = $duser->z;
  $ruser->warp_eta = $duser->warp_eta;
  $ret = new stdClass();
  $ret->ret = $ruser;
  return $ret;
}

function api_getusers($user,$args){
  foreach($db->users as $user){
    $duser = default_user($user);
    
// TODO UGH, I'm done. I can't do it anymore.
  }
}

function api_move($user,$args){
  $valid = true;
  if(!is_int($args['x'])){$valid = false; }
  if(!is_int($args['y'])){$valid = false; }
  if(!is_int($args['z'])){$valid = false; }

  if($valid){
    // TODO: This is wrong. What's it supposed to relate to Fiuck that.
    $dist = sqrt(
      pow($args['x'],2) +
      pow($args['y'],2) +
      pow($args['z'],2)
    );
    if($dist <= 10){
      $user->warp_eta = time() + ceiling($dist);
      $user->x = $args['x'];
      $user->y = $args['y'];
      $user->z = $args['z'];
      dbsave();
    } else {
      $ret = new stdClass();
      $ret->error = array("You cannot travel more than 10 units.");
      return $ret;
    }

  } else {
    $ret = new stdClass();
    $ret->error = array("Invalid arguments");
    return $ret;
  }

}
