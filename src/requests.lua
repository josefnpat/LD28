requests = {}

function requests.getuser(response)
  userdata = response.ret

  if userdata and userdata.x and userdata.y and userdata.z and 
    gamestate_game.move_x and
    gamestate_game.move_y and
    gamestate_game.move_z then

    gamestate_game.move_x:SetMin(userdata.x-userdata.warp_range)
    gamestate_game.move_x:SetMax(userdata.x+userdata.warp_range)

    gamestate_game.move_y:SetMin(userdata.y-userdata.warp_range)
    gamestate_game.move_y:SetMax(userdata.y+userdata.warp_range)

    gamestate_game.move_z:SetMin(userdata.z-userdata.warp_range)
    gamestate_game.move_z:SetMax(userdata.z+userdata.warp_range)

  end

  Gamestate.switch(states['game'])
end

function requests.getusers(response)

  local unique_playersr = {}
  if response.ret then
    for i,v in pairs(response.ret) do
      unique_playersr[v.name.."_"..v.x.."_"..v.y.."_"..v.z] = true
    end
  end

  local unique_playersu = {}
  if usersdata then
    for i,v in pairs(usersdata) do
      unique_playersu[v.name.."_"..v.x.."_"..v.y.."_"..v.z] = true
    end
  end

  local update_list = false

  for i,v in pairs(unique_playersu) do
    if not unique_playersr[i] then
      update_list = true
      break
    end
  end

  if not update_list then
    for i,v in pairs(unique_playersr) do
      if not unique_playersu[i] then
        update_list = true
        break
      end
    end
  end

  if update_list then

    usersdata = response.ret

    gamestate_game.playerlist_list:Clear()
    if usersdata then
      for _,v in pairs(usersdata) do
        local button = loveframes.Create("button")
        button:SetSize(100, 20)
        button:SetText(v.name.." ("..v.x..","..v.y..","..v.z..")")
        if v.x ~= userdata.x or 
          v.y ~= userdata.y or 
          v.z ~= userdata.z then

          button.targetx = v.x
          button.targety = v.y
          button.targetz = v.z

          button.OnClick = function(object)
            gamestate_game.move_x:SetValue(object.targetx)
            gamestate_game.move_y:SetValue(object.targety)
            gamestate_game.move_z:SetValue(object.targetz)
            gamestate_game.msgbox_add("Updated warp destination to target.")
          end

        else

          button.target = v.name 
          button.OnClick = function(object)
            com.enqueue_request(
              {
              func="attack",
                args = {
                  target = object.target,
                  item = gamestate_game.item_select
                }
              },
              requests.attack
            )
          end

        end

        gamestate_game.playerlist_list:AddItem(button)
      end
    end
   
  end
 
end

function requests.move(response)
  if response.error then
    for _,v in pairs(response.error) do
      gamestate_game.msgbox_add("Error: "..v)
    end
  else
    gamestate_game.msgbox_add("Warping.")
  end
end

function requests.sendchat(response)
  if response.error then
    for _,v in pairs(response.error) do
      gamestate_game.msgbox_add("Error: "..v)
    end
  end
end

function requests.getchat(response)

  if response.error then
    for _,v in pairs(response.error) do
      gamestate_game.msgbox_add("Error: "..v)
    end
  end
  if response.ret then
    for i,v in pairs(response.ret) do
      if v.id > chat_last_id then
        chat_last_id = v.id
      end
      gamestate_game.msgbox_add(v.name..": "..v.data)
    end
  end
end

function requests.buy(response)
  if response.error then
    for _,v in pairs(response.error) do
      gamestate_game.msgbox_add("Error: "..v)
    end
  end
end

function requests.sell(response)
  if response.error then
    for _,v in pairs(response.error) do
      gamestate_game.msgbox_add("Error: "..v)
    end
  end
end

function requests.use(response)
  if response.error then
    for _,v in pairs(response.error) do
      gamestate_game.msgbox_add("Error: "..v)
    end
  end
end

function requests.attack(response)
  if response.error then
    for _,v in pairs(response.error) do
      gamestate_game.msgbox_add("Error: "..v)
    end
  end
  if response.ret then
    for i,v in pairs(response.ret) do
      gamestate_game.msgbox_add(v)
    end
  end
end

function requests.msgs(response)
  if response.error then
    for _,v in pairs(response.error) do
      gamestate_game.msgbox_add("Error: "..v)
    end
  end
  if response.ret then
    for i,v in pairs(response.ret) do
      gamestate_game.msgbox_add(v)
    end
  end
end

return requests
