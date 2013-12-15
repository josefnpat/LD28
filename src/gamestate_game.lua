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

function gamestate_game.update(self,dt)
  gamestate_game.hitserver_dt = gamestate_game.hitserver_dt + dt
  gamestate_game.chat_timer_dt = gamestate_game.chat_timer_dt + dt
  if gamestate_game.hitserver_dt > gamestate_game.hitserver then
    gamestate_game.hitserver_dt = 0
    com.enqueue_request({func="getuser"},requests.getuser)
    com.enqueue_request({func="getusers"},requests.getusers)
    if gamestate_game.chat_timer_dt > gamestate_game.chat_timer then
      gamestate_game.chat_timer_dt = 0
      com.enqueue_request({
          func="getchat",
          args={
            time=stime
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

function gamestate_game.draw(self)
  love.graphics.printf(
    "WELCOME TO THE PRE-PRE-PRE-DARE-PROTOTYPE-ALPHA\n"..
    "USER "..settings.data.username.."\n"..
    "Your current position is ("..userdata.x..","..userdata.y..","..userdata.z..")\n"..
    "Your ap: "..userdata.ap.."/"..userdata.ap_max.."\n"..
    "Your speed is: "..userdata.speed.." m/s\n"..
    ( (userdata.warp_eta>0) and ("ETA "..round(userdata.warp_eta-ctime).." seconds") or ("Not in warp." ) ).."\n"..
    "",100,100,600,"center")
end

return gamestate_game
