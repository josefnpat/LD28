requests = {}

function requests.getuser(response)
  userdata = response.ret
  Gamestate.switch(states['game'])
end

function requests.getusers(response)
  usersdata = response.ret
  Gamestate.switch(states['game'])
end

function requests.move(response)
  if response.error then
    for _,v in pairs(response.error) do
      gamestate_game.msgbox_add("Error: "..v)
    end
  else
    gamestate_game.msgbox_add("Warping to ("..userdata.x..","..userdata.y..","..userdata.z..")")
  end
end

return requests
