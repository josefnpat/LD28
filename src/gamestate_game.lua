gamestate_game = {}

function gamestate_game.init()

  -- Move Frame

  gamestate_game.frame_move = loveframes.Create("frame")
  gamestate_game.frame_move:SetSize(320,2.5*32)
  gamestate_game.frame_move:ShowCloseButton(false)
  gamestate_game.frame_move:SetName("Move")

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
  gamestate_game.move:SetText("Travel")
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
  gamestate_game.msgbox.w = 640
  gamestate_game.msgbox.h = 160

  gamestate_game.frame_msgbox = loveframes.Create("frame")
  gamestate_game.frame_msgbox:SetName("Messages")
  gamestate_game.frame_msgbox:SetSize(gamestate_game.msgbox.w,gamestate_game.msgbox.h)
  gamestate_game.frame_msgbox:ShowCloseButton(false)
  gamestate_game.frame_msgbox:SetPos(0,love.graphics.getHeight()-gamestate_game.msgbox.h)

  gamestate_game.msgbox_list = loveframes.Create("list", gamestate_game.frame_msgbox)
  gamestate_game.msgbox_list:SetPos(gamestate_game.msgbox.x,gamestate_game.msgbox.y)
  gamestate_game.msgbox_list:SetSize(
    gamestate_game.msgbox.w-gamestate_game.msgbox.x*2,
    gamestate_game.msgbox.h-gamestate_game.msgbox.y-16
  )

  gamestate_game.msgbox_text  = loveframes.Create("text", gamestate_game.msgbox_list)
  gamestate_game.msgbox_text:SetPos(16,32)
  gamestate_game.msgbox_text:SetSize(
    gamestate_game.msgbox.w-gamestate_game.msgbox.x*2,
    gamestate_game.msgbox.h-gamestate_game.msgbox.y-16
  )
  gamestate_game.msgbox_add("Welcome space travler.")

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

function gamestate_game.update(self,dt)
  gamestate_game.hitserver_dt = gamestate_game.hitserver_dt + dt
  if gamestate_game.hitserver_dt > gamestate_game.hitserver then
    gamestate_game.hitserver_dt = 0
    com.enqueue_request({func="getuser"},requests.getuser)
    com.enqueue_request({func="getusers"},requests.getusers)
  end
  if userdata then
    if userdata.warp_eta > 0 then
      if not gamestate_game.inwarp then
        gamestate_game.inwarp = true
        -- CONFIRMED IN WARP TRIGGERS
      end
    else
      if gamestate_game.inwarp then
        gamestate_game.inwarp = false
        -- CONFIRMED OUT OF WARP TRIGGERS
        gamestate_game.msgbox_add("Arriving at destination.")
      end
    end
  end
end

function gamestate_game.draw(self)
  love.graphics.printf(
    "WELCOME TO THE PRE-PRE-PRE-DARE-PROTOTYPE-ALPHA\n"..
    "USER "..settings.data.username.."\n"..
    "Your current position is ("..userdata.x..","..userdata.y..","..userdata.z..")\n"..
    "Your speed is: "..userdata.speed.." m/s\n"..
    "Your warp eta is: "..userdata.warp_eta.." (0 means not in warp.)\n"..
    "",100,100,600,"center")
  if usersdata then
    for i,v in pairs(usersdata) do
      love.graphics.printf(v.name .. " ("..v.x..","..v.y..","..v.z..")",650,100+12*(i-1),100,"center")
    end
  end
end

return gamestate_game
