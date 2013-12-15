gamestate_game = {}

function gamestate_game.init()

  -- Move Frame

  gamestate_game.frame_move = loveframes.Create("frame")
  gamestate_game.frame_move:SetSize(64*4+32,2.5*32)
  gamestate_game.frame_move:ShowCloseButton(false)
  gamestate_game.frame_move:SetName("Warp Destination")

  gamestate_game.move_x = loveframes.Create("numberbox",gamestate_game.frame_move)
  gamestate_game.move_x:SetPos(16+(64)*(1-1),32)
  gamestate_game.move_x:SetSize(62,32)
  gamestate_game.move_x:SetValue(userdata.x)

  gamestate_game.move_y = loveframes.Create("numberbox",gamestate_game.frame_move)
  gamestate_game.move_y:SetPos(16+(64)*(2-1),32)
  gamestate_game.move_y:SetSize(62,32)
  gamestate_game.move_y:SetValue(userdata.y)

  gamestate_game.move_z = loveframes.Create("numberbox",gamestate_game.frame_move)
  gamestate_game.move_z:SetPos(16+(64)*(3-1),32)
  gamestate_game.move_z:SetSize(62,32)
  gamestate_game.move_z:SetValue(userdata.z)

  gamestate_game.move = loveframes.Create("button",gamestate_game.frame_move)
  gamestate_game.move:SetSize(64,32)
  gamestate_game.move:SetPos(16+(62+2)*(4-1),32)
  gamestate_game.move:SetText("Warp")
  gamestate_game.move.OnClick = function(object)
    com.enqueue_request(
      {func="move",
       args = {
         x = gamestate_game.move_x:GetValue(),
         y = gamestate_game.move_y:GetValue(),
         z = gamestate_game.move_z:GetValue()
        }
      },
      requests.move
    )
  end

  -- Messagebox


  gamestate_game.msgbox = {}
  gamestate_game.msgbox.x = 16
  gamestate_game.msgbox.y = 32
  gamestate_game.msgbox.w = love.graphics.getWidth()/2
  gamestate_game.msgbox.h = 160

  gamestate_game.frame_msgbox = loveframes.Create("frame")
  gamestate_game.frame_msgbox:SetName("Messages")
  gamestate_game.frame_msgbox:SetSize(gamestate_game.msgbox.w,gamestate_game.msgbox.h)
  gamestate_game.frame_msgbox:ShowCloseButton(false)
  gamestate_game.frame_msgbox:SetPos(0,love.graphics.getHeight()-gamestate_game.msgbox.h)

  gamestate_game.msgbox_list = loveframes.Create("list",gamestate_game.frame_msgbox)
  gamestate_game.msgbox_list:SetPos(gamestate_game.msgbox.x,gamestate_game.msgbox.y)
  gamestate_game.msgbox_list:SetSize(
    gamestate_game.msgbox.w-gamestate_game.msgbox.x*2,
    gamestate_game.msgbox.h-gamestate_game.msgbox.y-16-32
  )

  gamestate_game.msgbox_text = loveframes.Create("text", gamestate_game.msgbox_list)
  gamestate_game.msgbox_text:SetPos(16,32)
  gamestate_game.msgbox_text:SetSize(
    gamestate_game.msgbox.w-gamestate_game.msgbox.x*2,
    gamestate_game.msgbox.h-gamestate_game.msgbox.y-16
  )
  gamestate_game.msgbox_add("Welcome space travler. A friendly reminder: You only get one life.")

  gamestate_game.msgbox_chatin = loveframes.Create("textinput",gamestate_game.frame_msgbox)
  gamestate_game.msgbox_chatin:SetLimit(128)
  gamestate_game.msgbox_chatin:SetPos(
    gamestate_game.msgbox.x,
    gamestate_game.msgbox.h - gamestate_game.msgbox.y - 8)

  gamestate_game.msgbox_chatin:SetSize(
    gamestate_game.msgbox.w-gamestate_game.msgbox.x*2 -64,
    32
  )

  gamestate_game.msgbox_chatsend = loveframes.Create("button",gamestate_game.frame_msgbox)
  gamestate_game.msgbox_chatsend:SetPos(
    gamestate_game.msgbox.w - gamestate_game.msgbox.x - 64,
    gamestate_game.msgbox.h - gamestate_game.msgbox.y - 8)

  gamestate_game.msgbox_chatsend:SetSize(64, 32)
  gamestate_game.msgbox_chatsend:SetText("Send")
  gamestate_game.msgbox_chatsend.OnClick = function(object)
    com.enqueue_request({
      func="sendchat",
      args = {
        msg = gamestate_game.msgbox_chatin:GetValue()
        }
      },
      requests.sendchat)
    gamestate_game.msgbox_add(
      settings.data.username..": "..gamestate_game.msgbox_chatin:GetValue())
    gamestate_game.msgbox_chatin:Clear()
  end

  gamestate_game.msgbox_chatin.OnEnter = gamestate_game.msgbox_chatsend.OnClick

  -- Player list

  gamestate_game.playerlist = {}
  gamestate_game.playerlist.x = 16
  gamestate_game.playerlist.y = 32
  gamestate_game.playerlist.w = 160
  gamestate_game.playerlist.h = love.graphics.getHeight() / 2

  gamestate_game.frame_playerlist = loveframes.Create("frame")
  gamestate_game.frame_playerlist:SetName("Playerlist")
  gamestate_game.frame_playerlist:SetSize(gamestate_game.playerlist.w,gamestate_game.playerlist.h)
  gamestate_game.frame_playerlist:ShowCloseButton(false)
  gamestate_game.frame_playerlist:SetPos(
    love.graphics.getWidth()-gamestate_game.playerlist.w,
    love.graphics.getHeight()-gamestate_game.playerlist.h)

  gamestate_game.playerlist_list = loveframes.Create("list", gamestate_game.frame_playerlist)
  gamestate_game.playerlist_list:SetPos(gamestate_game.playerlist.x,gamestate_game.playerlist.y)
  gamestate_game.playerlist_list:SetSize(
    gamestate_game.playerlist.w-gamestate_game.playerlist.x*2,
    gamestate_game.playerlist.h-gamestate_game.playerlist.y-16
  )

  -- Item info

  gamestate_game.iteminfo = {}
  gamestate_game.iteminfo.x = 16
  gamestate_game.iteminfo.y = 16
  gamestate_game.iteminfo.w = 256+32
  gamestate_game.iteminfo.h = 64 + 40
  gamestate_game.frame_iteminfo = loveframes.Create("frame")
  gamestate_game.frame_iteminfo:SetName("Item Info")
  gamestate_game.frame_iteminfo:SetSize(gamestate_game.iteminfo.w,gamestate_game.iteminfo.h)
  gamestate_game.frame_iteminfo:SetPos(100,100)
  gamestate_game.frame_iteminfo:ShowCloseButton(false) 

  gamestate_game.iteminfo_image = loveframes.Create("image", gamestate_game.frame_iteminfo)
  gamestate_game.iteminfo_image:SetPos(8,32)

  gamestate_game.iteminfo_text = loveframes.Create("text", gamestate_game.frame_iteminfo)
  gamestate_game.iteminfo_text:SetPos(16+64,32)
  gamestate_game.iteminfo_text:SetSize(
    gamestate_game.iteminfo.w-64-16-96,
    gamestate_game.iteminfo.h - 32)
  
  gamestate_game.iteminfo_use = loveframes.Create("button",gamestate_game.frame_iteminfo)
  gamestate_game.iteminfo_use:SetText("Use")
  gamestate_game.iteminfo_use:SetSize(64,20)
  gamestate_game.iteminfo_use:SetPos(gamestate_game.iteminfo.w-64-8,32+0)
  gamestate_game.iteminfo_use.OnClick = function(object)
    com.enqueue_request({
        func="use",
        args={
          slot=gamestate_game.item_select,
        }
      },
      requests.use)
  end

  gamestate_game.iteminfo_buy = loveframes.Create("button",gamestate_game.frame_iteminfo)
  gamestate_game.iteminfo_buy:SetText("Buy")
  gamestate_game.iteminfo_buy:SetSize(64,20)
  gamestate_game.iteminfo_buy:SetPos(gamestate_game.iteminfo.w-64-8,32+20)
  gamestate_game.iteminfo_buy.OnClick = function(object)
    com.enqueue_request({
        func="buy",
        args={
          slot=gamestate_game.item_select,
          item=object.item_id
        }
      },
      requests.buy)
    gamestate_game.iteminfo_buy:SetEnabled(false)
    gamestate_game.iteminfo_sell:SetEnabled(true)
  end

  gamestate_game.iteminfo_sell = loveframes.Create("button",gamestate_game.frame_iteminfo)
  gamestate_game.iteminfo_sell:SetText("Sell (50%)")
  gamestate_game.iteminfo_sell:SetSize(64,20)
  gamestate_game.iteminfo_sell:SetPos(gamestate_game.iteminfo.w-64-8,32+40)
  gamestate_game.iteminfo_sell.OnClick = function(object)
    com.enqueue_request({
        func="sell",
        args={
          slot=gamestate_game.item_select,
        }
      },
      requests.sell)
    gamestate_game.iteminfo_sell:SetEnabled(false)
    gamestate_game.iteminfo_buy:SetEnabled(true)
  end

  gamestate_game.showitem(userdata.items[1],false,false)

  -- Market list

  gamestate_game.itemlist = {}
  gamestate_game.itemlist.x = 16
  gamestate_game.itemlist.y = 32
  gamestate_game.itemlist.w = 160
  gamestate_game.itemlist.h = love.graphics.getHeight() / 2

  gamestate_game.frame_itemlist = loveframes.Create("frame")
  gamestate_game.frame_itemlist:SetName("Market")
  gamestate_game.frame_itemlist:SetSize(gamestate_game.itemlist.w,gamestate_game.itemlist.h)
  gamestate_game.frame_itemlist:ShowCloseButton(false)
  gamestate_game.frame_itemlist:SetPos(
    love.graphics.getWidth()-gamestate_game.itemlist.w-160,
    love.graphics.getHeight()-gamestate_game.itemlist.h)

  gamestate_game.itemlist_list = loveframes.Create("list", gamestate_game.frame_itemlist)
  gamestate_game.itemlist_list:SetPos(gamestate_game.itemlist.x,gamestate_game.itemlist.y)
  gamestate_game.itemlist_list:SetSize(
    gamestate_game.itemlist.w-gamestate_game.itemlist.x*2,
    gamestate_game.itemlist.h-gamestate_game.itemlist.y-16
  )

  for i,v in pairs(items) do
    local button = loveframes.Create("button")
    button:SetSize(100,20)
    button:SetText(v.name)
    button.item_id = tonumber(i)
    button.OnClick = function(object)
      gamestate_game.showitem(object.item_id,not userdata.items[gamestate_game.item_select])
    end
    gamestate_game.itemlist_list:AddItem(button)
  end

  
end

gamestate_game.msgbox_data = {}
function gamestate_game.msgbox_add(s)
  table.insert(gamestate_game.msgbox_data,s)
  if #gamestate_game.msgbox_data > 100 then
    table.remove(gamestate_game.msgbox_data,1)
  end
  local rs = ""
  for i,v in pairs(gamestate_game.msgbox_data) do
    rs = v.." \n "..rs
  end
  gamestate_game.msgbox_text:SetText(rs)
end

gamestate_game.hitserver = 1
gamestate_game.hitserver_dt = gamestate_game.hitserver

gamestate_game.chat_timer = 1.5
gamestate_game.chat_timer_dt = gamestate_game.chat_timer

chat_last_id = 0

function gamestate_game.update(self,dt)
  gamestate_game.hitserver_dt = gamestate_game.hitserver_dt + dt
  gamestate_game.chat_timer_dt = gamestate_game.chat_timer_dt + dt
  if gamestate_game.hitserver_dt > gamestate_game.hitserver then
    gamestate_game.hitserver_dt = 0
    com.enqueue_request({func="getuser"},requests.getuser)
    com.enqueue_request({func="getusers"},requests.getusers)
    com.enqueue_request({func="msgs"},requests.msgs)
    if gamestate_game.chat_timer_dt > gamestate_game.chat_timer then
      gamestate_game.chat_timer_dt = 0
      com.enqueue_request({
          func="getchat",
          args={
            last_id=chat_last_id
          }
        },
        requests.getchat)
    end 

  end
  if userdata then
    if userdata.warp_eta > 0 then
      if not gamestate_game.inwarp then
        gamestate_game.inwarp = true
        -- CONFIRMED IN WARP TRIGGERS
        gamestate_game.move:SetEnabled(false)
      end
    else
      if gamestate_game.inwarp then
        gamestate_game.inwarp = false
        -- CONFIRMED OUT OF WARP TRIGGERS
        gamestate_game.msgbox_add("Arriving at destination.")
        gamestate_game.move:SetEnabled(true)
      end
    end
  end

end

function gamestate_game.showitem(id,buy,sell)

  gamestate_game.iteminfo_buy:SetEnabled(buy)
  gamestate_game.iteminfo_buy.item_id = id
  gamestate_game.iteminfo_sell:SetEnabled(sell)
  gamestate_game.iteminfo_sell.item_id = id

  if items[id] then
    gamestate_game.iteminfo_use:SetEnabled(items[id].use)
    gamestate_game.iteminfo_image:SetImage(items[id].img)
    local s = items[id].name.." \n "
    for i,v in pairs(items[id]) do
      if i ~= "name" and i ~= "img" and i ~= "use" then
        s=s..i.." "..v.." \n "
      end
    end
    gamestate_game.iteminfo_text:SetText(s)
  else
    gamestate_game.iteminfo_use:SetEnabled(false)
    gamestate_game.iteminfo_image:SetImage(items_empty)
    gamestate_game.iteminfo_text:SetText("Select a slot with 1-8, or an item from the market window.")
  end
end

gamestate_game.item_select = 1

function gamestate_game.draw(self)

  love.graphics.printf(
    "WELCOME TO THE PRE-PRE-PRE-DARE-PROTOTYPE-ALPHA\n"..
    "USER "..settings.data.username.."\n"..
    "Your current position is ("..userdata.x..","..userdata.y..","..userdata.z..")\n"..
    "Your ap: "..userdata.ap.."/"..userdata.ap_max.."\n"..
    "Your hp: "..userdata.hp.."/"..userdata.hp_max.."\n"..
    "Your evade: "..userdata.evade.."/"..userdata.evade_max.."\n"..
    "Your lock: "..userdata.lock.."/"..userdata.lock_max.."\n"..
--    "Your cloak: "..userdata.cloak.."/"..userdata.cloak_max.."\n"..
    "Your speed is: "..userdata.speed.." m/s\n"..
    "Your have "..userdata.credits.." credits\n"..
    ( (userdata.warp_eta>0) and ("ETA "..round(userdata.warp_eta-ctime).." seconds") or ("Not in warp." ) ).."\n"..
    "",100,100,600,"center")
  if userdata then
    for i = 1,8 do
      love.graphics.draw(items_empty,i*64,0)
      if userdata.items[i..""] then
        love.graphics.draw(items[userdata.items[i..""]].img,i*64,0)
      end
      if i == gamestate_game.item_select then
        love.graphics.draw(items_select,i*64,0)
      end
    end
    if userdata.items[gamestate_game.item_select] then
      love.graphics.print( items[userdata.items[gamestate_game.item_select]].name , 64, 64)
    end
  end
end

function gamestate_game.keypressed(self,key)
  local kan = tonumber(key)
  if kan and kan >= 1 and kan <=8 then
    gamestate_game.item_select = kan
    gamestate_game.showitem(userdata.items[kan..""],false,userdata.items[kan..""])
  end
end

return gamestate_game
