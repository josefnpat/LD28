# Bitmo Pirates MMO

### Welcome space travler. A friendly reminder: You only get one life.

Introducing the 48 hour MMO. You said it was a bad idea, and from the start and in retrospect, it probably was. Regardless, it's an MMO, it's free, and it's technically in 3D, as requested.

Coincidentally, this game is the first publicly released MMO make with the LÖVE framework.

### How to play

1. Visit the [HTTPS server webpage](https://50.116.63.25/public/LD28/).

  **You will get an [untrusted security warning](http://i.imgur.com/mTugoRM.png). Please add this domain to your security exceptions to continue.**
2. Register your user and get your **Secure Login Key**.
3. Download the client if you haven't already and start it up;

  * Windows 32/64 - Simply unpack the zip, and run the *.exe
  * OS X - Simply unpack the zip, and run the *.app
  * Debian (Ubuntu) - Download the .deb and install it using your package manager of choice.
  * LÖVE/Other Linux - Run the .love with LÖVE 0.8.0

4. **Input your username and key.** This information will be stored if you want to play again.
5. _Blast everyone to bits!_

### Tips:

* **To earn more credits, kill people!**
* The **game is persistant**. If you log out, you will still be in the game.
* **To attack**, select the slot you want to attack with by pressing the numbers 1 to 8, and click on the person you want to attack in the "Playerlist" window. Information about the attack is shown in the "Messages" window.
* **To buy an item**, select an empty slot by pressing the numbers 1 to 8, find the item in the "Market" window and select it, and press the buy button in the "Item Info" window.
* **To warp**, change the numbers in the "Warp Destination" window, and click the warp button. To warp to a player, click on a player that is not in the same (X,Y,Z) coordinates as yourself, and then click warp.
* **There are 66 items** (with 11 base item types), each of them do different things.

  Items can either be **used out of combat** (The "Use" button in the "Item Info" will be enabled) or you **can attack an enemy** with it (Select the item slot with the item, then click on an enemies name.)

  **All items have a tier**. The higher the tier, the better, but the more expensive.

  Items can effect your ship actively, passively, and enemy ships actively. They are **denoted by the prefix**:

  * player_* (Effects current player actively, like repairing your armor)
  * base_* (Effects current player passively, like increasing your maximum armor amount)
  * enemy_* (Effects target player actively, like shooting them.)
  
  Items effect specific statistics of your ship, **denoted by the postfix**:

  * *_hp (Your ship's health. If this is 0, you respawn with nothing!)
  * *_ap (Your ship's action points. This is used for warping and using items! It regenerates.)
  * *_evade (This is your % chance you will evade an enemies attack. It regenerates.)
  * *_lock (This is the number of seconds your ship cannot warp. It degenerates once every second.)
  
  For example, "Missile Launcher T1":

    * enemy_hp: -12 (This will decrease the enemies HP by 12)
    * player_ap: -13, (This will decrease your AP by 13)
    * value: 20 (This will cost 20 credits to buy)

### Technical Information:

The client was made for the LÖVE 0.8.0 framework, and uses [LoveFrames](https://github.com/NikolaiResokav/LoveFrames) with the [Gray Theme](https://github.com/unekPL/loveframes-gray-theme). It signs the http communications with a [digital signature](http://en.wikipedia.org/wiki/Digital_signature) and sends it to the PHP server. The PHP server then recieves it and confirms the signature, and operates on a raw data that is ZLIB compressed into memory via memcached.

This game was made in 48 hours for [LD28](http://www.ludumdare.com/compo/ludum-dare-28/?action=preview&uid=11249).
