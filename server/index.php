<h3><?php

require('config.php');

if(isset($_POST['exe'])){

  if($_POST['exe'] == "register"){
    if(preg_match("@^([a-zA-Z0-9_-]){3,8}$@",$_POST['username'])){
      if($_POST['password'] != "" and $_POST['password'] == $_POST['password2']){
        $user = new stdClass();
        $user->name = $_POST['username'];
        $user->password = sha1($_POST['password'].$salt);
        $user->join = time();
        $db->users[count($db->users)] = $user;
        dbsave();
      } else {
        echo "Missing password or password mismatch.";
      }
    } else {
      echo "Invalid username. (alphanumeric 3-8)";
    }
  } elseif($_POST['exe'] == "getsecureloginkey"){
    foreach($db->users as $user){
      if($user->name == $_POST['username'] and $user->password == sha1($_POST['password'].$salt)){
        $user->key = strtoupper(substr(md5(rand().$salt),1,16));
        dbsave();
        echo "Your secure login key is: ";
        echo substr($user->key,0,4)." ";
        echo substr($user->key,4,4)." ";
        echo substr($user->key,8,4)." ";
        echo substr($user->key,12,4)." ";
        break;
      }
    }
  }

} 

?></h3><html>
  <head>
    <title><?php echo $game_name; ?></title>
  </head>
  <body>
    <h1><?php echo $game_name; ?></h1>

    <p>There are currently <?php echo count($db->users); ?> users.</p>

    <p>Check <a href="score.php">scores</a>

    <p>How to play:</p>

    <h2>Register</h2>
    <form action="index.php" method="post">
      <input type="hidden" name="exe" value="register" />
      <p>Username: <input type="text" name="username" /></p>
      <p>Password: <input type="password" name="password" /></p>
      <p>Password: <input type="password" name="password2" /></p>
      <p><input type="submit" value="Register" /></p>
    </form>

    <h2>Get Secure Login Key</h2>
    <p>This will show your Secure Login Key. Do not share this unless you want people to have access to your account. By using a Secure Login Key, you ensure that your password remains safe.</p>
    <form action="index.php" method="post">
      <input type="hidden" name="exe" value="getsecureloginkey" />
      <p>Username: <input type="text" name="username" /></p>
      <p>Password: <input type="password" name="password" /></p>
      <p><input type="submit" value="Get Secure Login Key" /></p>
    </form>

    <h2>Download Client</h2>
    <ul>
      <li>Windows &mdash; <a href="http://missingsentinelsoftware.com/system/files/BPMMO_win-x86%5Be3402c9%5D.zip">Download 32bit</a> <a href="http://missingsentinelsoftware.com/system/files/BPMMO_win-x64%5Be3402c9%5D.zip">Download 64bit</a></li>
      <li>OS X &mdash; <a href="http://missingsentinelsoftware.com/system/files/BPMMO_macosx%5Be3402c9%5D.zip">Download</a></li>
      <li>L&Ouml;VE 0.8.0 &mdash; <a href="http://missingsentinelsoftware.com/system/files/BPMMO_e3402c9.love">Download</a></li>
      <li>Source (GitHub) &mdash; <a href="https://github.com/josefnpat/LD28">GitHub</a></li>
    </ul>

    <legs></legs>
  </body>
</html>
