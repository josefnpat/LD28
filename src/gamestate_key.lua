gamestate_key = {}

gamestate_key.text_info_dt = 0

function gamestate_key.init(self)

  gamestate_key.x = 16
  gamestate_key.y = 48
  gamestate_key.w = 320

  gamestate_key.frame = loveframes.Create("frame")
  gamestate_key.frame:SetSize(320, 8*32)
  gamestate_key.frame:SetName("Login")
  gamestate_key.frame:ShowCloseButton(false)
  gamestate_key.frame:CenterX()
  gamestate_key.frame:SetY(120)
  gamestate_key.frame:SetDraggable(false)

  gamestate_key.text_username = loveframes.Create("text",gamestate_key.frame)
  gamestate_key.text_username:SetText("Username:")
  gamestate_key.text_username:SetPos(gamestate_key.x,gamestate_key.y)

  gamestate_key.username = loveframes.Create("textinput",gamestate_key.frame)
  gamestate_key.username:SetPos(gamestate_key.x,gamestate_key.y+32*0.5)
  gamestate_key.username:SetWidth((gamestate_key.w-32)/2)
  gamestate_key.username:SetLimit(8)
  if settings.data.username then
    gamestate_key.username:SetValue(settings.data.username)
  end

  gamestate_key.username_help = loveframes.Create("button",gamestate_key.frame)
  gamestate_key.username_help:SetPos(gamestate_key.w-64-16,gamestate_key.y+32*0.5)
  gamestate_key.username_help:SetText("New User")
  gamestate_key.username_help:SetWidth(64)
  gamestate_key.username_help.OnClick = function(object)
    print("Opening "..server_base_url)
    openURL("https"..string.sub(server_base_url,5))
  end

  gamestate_key.text_secure = loveframes.Create("text",gamestate_key.frame)
  gamestate_key.text_secure:SetText("Secure Login Key:")
  gamestate_key.text_secure:SetPos(gamestate_key.x,gamestate_key.y+32*2)

  gamestate_key.keyinputs = {}
  for i = 1,4 do
    gamestate_key.keyinputs[i] = loveframes.Create("textinput",gamestate_key.frame)
    gamestate_key.keyinputs[i]:SetPos(
      (i-1)*(48)+gamestate_key.x,
      gamestate_key.y+32*2.5)
    gamestate_key.keyinputs[i]:SetWidth(46)
    gamestate_key.keyinputs[i]:SetLimit(4)
    if settings.data.secure_key then
      local part = (i-1)*4+1
      gamestate_key.keyinputs[i]:SetValue(string.sub(settings.data.secure_key, part,part+3))
    end
  end

  if settings.data.secure_key then
    gamestate_key.keyinputs_hide = loveframes.Create("button",gamestate_key.frame)
    gamestate_key.keyinputs_hide:SetPos(
      gamestate_key.x,
      gamestate_key.y+32*2.5)
    gamestate_key.keyinputs_hide:SetWidth((48+2)*4)
    gamestate_key.keyinputs_hide:SetText("Show stored secure login key")
    gamestate_key.keyinputs_hide.OnClick = function(object)
      object:SetVisible(false)
    end
  end

  gamestate_key.text_info = loveframes.Create("text",gamestate_key.frame)
  gamestate_key.text_info:SetText("")
  gamestate_key.text_info:SetPos(gamestate_key.x,gamestate_key.y+32*4)

  gamestate_key.eval = loveframes.Create("button",gamestate_key.frame)
  gamestate_key.eval:SetPos(gamestate_key.x,gamestate_key.y+32*5)
  gamestate_key.eval:SetWidth(gamestate_key.w-32)
  gamestate_key.eval:SetText("Login")
  gamestate_key.eval.OnClick = function(object)

    gamestate_key.text_info:SetText("Logging in ..")

    settings.data.secure_key = string.upper(
      gamestate_key.keyinputs[1]:GetValue()..
      gamestate_key.keyinputs[2]:GetValue()..
      gamestate_key.keyinputs[3]:GetValue()..
      gamestate_key.keyinputs[4]:GetValue()
    )
    settings.data.username = gamestate_key.username:GetValue()

    com.enqueue_request(
      {func="getuser"},
      requests.getuser
    )
   
  end

end

gamestate_key.logo = love.graphics.newImage("logo.png")

function gamestate_key.draw(self)
  love.graphics.printf("Welcome space travler. A friendly reminder: You only get one life.\nVisit http://missingsentinelsoftware.com for more games.\n~josefnpat",0,64,800,"center")
  love.graphics.draw(gamestate_key.logo,(800-320)/2,400)
end

function gamestate_key.enter(self)
  gamestate_key.frame:SetVisible(true)
end

function gamestate_key.leave(self)
  gamestate_key.frame:SetVisible(false)
end

function gamestate_key.update(self,dt)
  gamestate_key.text_info_dt = gamestate_key.text_info_dt + dt
  if gamestate_key.text_info_dt > 4 then
    gamestate_key.text_info:SetText("")
  end
end

return gamestate_key
