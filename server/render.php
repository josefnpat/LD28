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
      return make_error("Function not availible: ".$fname);
    }
  }
}

$userbase = array();
$userbase['ap'] = 100;
$userbase['ap_max'] = 100;
$userbase['ap_rate'] = 1;

$userbase['hp'] = 100;
$userbase['hp_max'] = 100;
$userbase['hp_rate'] = 0;

$userbase['evade'] = 10;
$userbase['evade_max'] = 10;
$userbase['evade_rate'] = 0.1;

$userbase['lock'] = 0;
$userbase['lock_max'] = 120;
$userbase['lock_rate'] = -1;

//$userbase['cloak'] = 0;
//$userbase['cloak_max'] = 0;
//$userbase['cloak_rate'] = 100;

function get_user_info($user,$val,$max=false){
  global $userbase;
  global $items;

  if($max){

    $base = $userbase[$val."_max"];
    foreach($user->items as $itemid){

      if(isset($items[$itemid-1])){

        foreach($items[$itemid-1] as $modikey => $modival){
          if($modikey == "base_$val"){
            $base += $modival;
          }
        }

      }


    }
    return $base;

  } else {

    if(isset($user->$val)){
      return $user->$val;
    } else {
      return $userbase[$val];
    }

  }

}

function default_user($user){

  $user->gameage = isset($user->gameage) ? $user->gameage : time();
  $user->kills = isset($user->kills) ? $user->kills : 0;
  $user->deaths = isset($user->deaths) ? $user->deaths : 0;

  $user->x = isset($user->x) ? $user->x : rand(-5,5);
  $user->y = isset($user->y) ? $user->y : rand(-5,5);
  $user->z = isset($user->z) ? $user->z : rand(-5,5);
  $user->warp_eta = isset($user->warp_eta) ? $user->warp_eta : 0;
  $user->warp_range = isset($user->warp_range) ? $user->warp_range : 10;
  $user->speed = isset($user->speed) ? $user->speed : 1;
  $user->scan_range = isset($user->scan_range) ? $user->scan_range : 10;
  $user->items = isset($user->items) ? $user->items : array(1 => 1);

  $user->ap = get_user_info($user,"ap");
  $user->ap_max = get_user_info($user,"ap",true);
  $user->ap_update = isset($user->ap_update) ? $user->ap_update : time();

  $user->hp = get_user_info($user,"hp");
  $user->hp_max = get_user_info($user,"hp",true);
  $user->hp_update = isset($user->hp_update) ? $user->hp_update : time();

  $user->evade = get_user_info($user,"evade");
  $user->evade_max = get_user_info($user,"evade",true);
  $user->evade_update = isset($user->evade_update) ? $user->evade_update : time();

  $user->lock = get_user_info($user,"lock");
  $user->lock_max = get_user_info($user,"lock",true);
  $user->lock_update = isset($user->lock_update) ? $user->lock_update : time();

//  $user->cloak = get_user_info($user,"cloak");
//  $user->cloak_max = get_user_info($user,"cloak",true);
//  $user->cloak_update = isset($user->cloak_update) ? $user->cloak_update : time();

  $user->credits = isset($user->credits) ? $user->credits : 100;
  $user->msgs = isset($user->msgs) ? $user->msgs : array();

  return $user;
}

function dist($a,$b){
  return sqrt(
    pow($a->x - $b->x,2) +
    pow($a->y - $b->y,2) +
    pow($a->z - $b->z,2)
  );
}

function make_error($s){
  $ret = new stdClass();
  $ret->error = array($s);
  return $ret;
}

function update_user($user){

  $dbsave = false;
  $duser = default_user($user);

  if(isset($user->dead)){
    $keep = array("name","password","key","join","kills","deaths");
    foreach($user as $key => $value){
      if(!in_array($key,$keep)){
        unset($user->$key);
      }
    }
    $user = default_user($user);
    $dbsave = true;
  }

  if($duser->warp_eta <= time()){
    $user->warp_eta = 0;
    $dbsave = true;
  }

  global $userbase;

  foreach(array("ap","hp","evade","lock") as $type){

    $type_update = $type."_update";
    $type_max = $type."_max";

    $new_type = time() - $user->$type_update;

    if($new_type > 0){

      $user->$type += $new_type*$userbase[$type.'_rate'];

      if($user->$type < 0){
        $user->$type = 0;
      }

      if($user->$type > $user->$type_max){
        $user->$type = $user->$type_max;
      }

      $user->$type_update = time();
      $dbsave = true;
    }

  }

  if($dbsave){
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
  $ruser->scan_range = $duser->scan_range;
  $ruser->speed = $duser->speed;

  $ruser->ap = $duser->ap;
  $ruser->ap_max = $duser->ap_max;

  $ruser->hp = $duser->hp;
  $ruser->hp_max = $duser->hp_max;

  $ruser->evade = $duser->evade;
  $ruser->evade_max = $duser->evade_max;

  $ruser->lock = $duser->lock;
  $ruser->lock_max = $duser->lock_max;

//  $ruser->cloak = $duser->cloak;
//  $ruser->cloak_max = $duser->cloak_max;

  $ruser->credits = $duser->credits;

  $ruser->items = $duser->items;

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
      dist($ddbuser,$duser) <= $duser->scan_range
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
    return make_error("You are currently in warp.");
  }
  if($duser->lock > 0){
    return make_error("You are currently locked down.");
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
      return make_error("You are already at this location.");
    }

    $dist = dist($args,$duser);
    if($dist <= $duser->warp_range){

      $dist_cost = ceil($dist/$duser->speed);
      $ap_cost = $dist_cost*10;
      if($ap_cost > $user->ap){
        return make_error("Not enough AP. (Need ".$ap_cost.")");
      }
      $user->ap -= $ap_cost;

      $user->warp_eta = time() + $dist_cost;
      $user->x = $args->x;
      $user->y = $args->y;
      $user->z = $args->z;
      dbsave();
      return new stdClass();
    } else {
      return make_error("You cannot travel more than ".$duser->warp_range." units.");
    }

  } else {
    return make_error("Invalid arguments.");
  }

}

function api_attack($user,$args){
  global $db;
  $duser = default_user($user);
  $valid = true;
  if(!isset($args->target)or !is_string($args->target)){ $valid = false; }
  if(!isset($args->item)or !is_int($args->item)){ $valid = false; }
  if(!$valid){
    return make_error("Invalid arguments.");
  }
  $valid_target = false;
  foreach($db->users as $dbuser){
    $ddbuser = default_user($dbuser);
    if($ddbuser->name == $args->target){
      if($duser->x == $ddbuser->x and
        $duser->y == $ddbuser->y and
        $duser->z == $ddbuser->z){
        $valid_target = $ddbuser;
        break;
      } else {
        return make_error("Target no longer at locaton.");
      }
    }
  }

  if($valid_target){
    global $items;
    if(!isset($user->items[$args->item])){
      return make_error("Nothing to use.");
    }
    $user_items = $user->items;
    $slot = $args->item;
    $item_id = $user_items[$slot];
    $item = $items[$item_id-1];
    
    if($item->use){
      return make_error("Can't attack with this item.");
    }

    if(isset($item->player_ap) and $item->player_ap < 0 and $user->ap < -$item->player_ap){
      return make_error("Not enough AP.");
    }

    if($valid_target->evade >= rand(1,100)){
      return make_error("Your attack was evaded.");
    }

    $info_attack = array();
    foreach($item as $modikey => $modival){
      $raw = explode("_",$modikey);
      if(count($raw) == 2){

        if($raw[0]=="player"){
          $user->$raw[1] += $modival;
          $user->$raw[1] = get_user_info($user,$raw[1]);
        }

        if($raw[0]=="enemy"){
          $valid_target->$raw[1] += $modival;
          $valid_target->$raw[1] = get_user_info($valid_target,$raw[1]);
          $max = $raw[1]."_max";
          $info_attack[] = "You modify ".$valid_target->name."'s ".$raw[1]." by ".$modival.".".
            " (".floor(($valid_target->$raw[1]/$valid_target->$max)*100)."%)";

          $valid_target->msgs[] = $user->name." modifies your ".$raw[1]." by ".$modival.".".
            " (".floor(($valid_target->$raw[1]/$valid_target->$max)*100)."%)";

          if($valid_target->hp <= 0 ){
            $valid_target->dead = true;
            $user->credits += rand(10,20);
            $user->kills += 1;
            $valid_target->deaths += 1;
            $user->msgs[] = "You kill ".$valid_target->name.".";
            $valid_target->msgs[] = $user->name." kills you.";
            update_user($valid_target);
          }
        }

      }
    }
    dbsave();

    $ret = new stdClass();
    $ret->ret = $info_attack;
    return $ret;

  } else {
    return make_error("Invalid target.");
  }
}

function api_sendchat($user,$args){

  global $db;
  if(!isset($args->msg) or !is_string($args->msg)){
    return make_error("Invalid arguments.");
  }
  if($args->msg == ""){
    return make_error("No message to send.");
  }

  if(!isset($db->chat_cid)){
    $db->chat_cid = 0;
  }

  $msgobj = new stdClass();
  $msgobj->name = $user->name;
  $msgobj->id = $db->chat_cid;
  $msgobj->data = substr($args->msg,0,128);

  $db->chat_cid++;

  if(!isset($db->chat)){
    $db->chat = array();
  }
  $db->chat[] = $msgobj;
  if(count($db->chat) > 10){
    array_shift($db->chat);
  }

  dbsave();
  return new stdClass();
  
}

function api_getchat($user,$args){
  global $db;
  if(!isset($args->last_id) or !is_int($args->last_id)){
    return make_error("Invalid arguments.");
  }
  $ret = new stdClass();
  $ret->ret = array();
  if(isset($db->chat)){
    foreach($db->chat as $msg){
      if($user->name != $msg->name and $msg->id > $args->last_id){
        $ret->ret[] = $msg;
      }
    }
  }
  array_reverse($ret->ret);
  return $ret;
}

function api_buy($user,$args){
  global $items;
  $duser = default_user($user);
  $valid = true;
  if(!isset($args->slot)or !is_int($args->slot)){ $valid = false; }
  if(!isset($args->item)or !is_int($args->item)){ $valid = false; }
  if(!$valid){
    return make_error("Invalid arguments.");
  }
  if($args->slot < 1 or $args->slot > 8){
    return make_error("Invalid slot.");
  }

  $item_id = $args->item;

  $item = $items[$item_id-1];

  if($duser->credits < $item->value){
    return make_error("You don't have enough credits.");
  }

  if(isset($user->items[$args->slot])){
    return make_error("This slot is already filled.");
  }
  
  $user->items[$args->slot] = $args->item;
  $user->credits -= $item->value;

  dbsave();
  return new stdClass();
}

function api_sell($user,$args){
  global $items;
  $duser = default_user($user);
  $valid = true;
  if(!isset($args->slot)or !is_int($args->slot)){ $valid = false; }
  if(!$valid){
    return make_error("Invalid arguments.");
  }
  if(!isset($user->items[$args->slot])){
    return make_error("Nothing to sell.");
  }
  $item_id = $user->items[$args->slot];
  
  $item = $items[$item_id-1];

  $user->credits += floor($item->value/2);
  unset($user->items[$args->slot]);
  dbsave();

}

function api_use($user,$args){
  global $items;
  $duser = default_user($user);
  $valid = true;
  if(!isset($args->slot)or !is_int($args->slot)){ $valid = false; }
  if(!$valid){
    return make_error("Invalid arguments.");
  }
  if(!isset($user->items[$args->slot])){
    return make_error("Nothing to use.");
  }
  $user_items = $user->items;
  $slot = $args->slot;
  $item_id = $user_items[$slot];
  $item = $items[$item_id-1];
  
  if(!$item->use){
    return make_error("Can't use this item.");
  }

  if($item->player_ap < 0 and $user->ap < -$item->player_ap){
    return make_error("Not enough AP.");
  }

  if(isset($item->player_lock) and $item->player_lock + $duser->lock > $duser->lock_max){
    return make_error("Can't lock down any more.");
  }


  foreach($item as $modikey => $modival){
    $raw = explode("_",$modikey);
    if(count($raw) == 2){
      if($raw[0]=="player"){
        $user->$raw[1] += $modival;
        $user->$raw[1] = get_user_info($user,$raw[1]);
      }
    }
  }
  dbsave();

  return new stdClass();

}

function api_msgs($user,$args){
  $duser = default_user($user);
  $ret = new stdClass();
  $ret->ret = $duser->msgs;
  $user->msgs = array();
  dbsave();
  return $ret;
}
