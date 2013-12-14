gamestate_game = {}

function gamestate_game.init()

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
    local obj = {
      requests = {
        {func = "move",
          args = {
           x = gamestate_game.move_x:GetValue(),
           y = gamestate_game.move_y:GetValue(),
           z = gamestate_game.move_z:GetValue()
          }
        }
      }
    }
    local response = com.blocking_request(obj)
    print_r(response)
  end

end

gamestate_game.hitserver = 1
gamestate_game.hitserver_dt = gamestate_game.hitserver

function gamestate_game.update(self,dt)
  gamestate_game.hitserver_dt = gamestate_game.hitserver_dt + dt
  if gamestate_game.hitserver_dt > gamestate_game.hitserver then
    gamestate_game.hitserver_dt = 0
    obj = {
      requests = {
        {func = "getuser"},
        {func = "getusers"}
      }
    }
    local response = com.blocking_request(obj)
    if response.error then
      for i,v in pairs(response.error) do
        print("Error: "..v)
      end
    else
      userdata = response.results[1].ret
      usersdata = response.results[2].ret
    end
  end
end

function gamestate_game.draw(self)
  love.graphics.printf(
    "WELCOME TO THE PRE-PRE-PRE-DARE-PROTOTYPE-ALPHA\n"..
    "USER "..settings.data.username.."\n"..
    "Your current position is ("..userdata.x..","..userdata.y..","..userdata.z..")\n"..
    "Your warp eta is: "..userdata.warp_eta.." (0 means not in warp.)\n"..
    "",100,100,600,"center")

  for i,v in pairs(usersdata) do
    love.graphics.printf(v.name .. " ("..v.x..","..v.y..","..v.z..")",650,100+12*(i-1),100,"center")
  end
end

return gamestate_game
