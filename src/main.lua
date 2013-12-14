git,git_count = "missing git.lua",0
pcall(require, "git")

Gamestate = require('gamestate')

require('json')

settings = {}
settings.file = "settings.json"
settings.appver = 1

if love.filesystem.exists(settings.file) then
  local rawjson = love.filesystem.read(settings.file)
  settings.data = json.decode(rawjson)
  if (settings.data.appver ~= settings.appver) then
    settings.data = nil
    print("App version does not match: clearing "..settings.file)
  end
end

if not settings.data then
  settings.data = {}
  settings.data.appver = settings.appver
end

states = {}

http = require('socket.http')

require("lf")
loveframes.config["ACTIVESKIN"] = "Dark"

require("lib.bslf.bit").lut()
hashlib = require("lib.hash")
com = require('com')
require('config')

game_name = "unnamed mmo bullshit"

function love.load()

  com.load()

  love.graphics.setCaption(game_name.." - v"..git_count.." ["..git.."]")

  states['key'] = require('gamestate_key')
  states['game'] = require('gamestate_game')
  Gamestate.switch(states['key'])

  Gamestate.registerEvents()

end

function love.update(dt)

   com.update(dt)

  loveframes.update(dt)
end
                 
function love.draw()
  loveframes.draw()
end
 
function love.mousepressed(x, y, button)
  loveframes.mousepressed(x, y, button)
end
 
function love.mousereleased(x, y, button)
  loveframes.mousereleased(x, y, button)
end
 
function love.keypressed(key, unicode)
  loveframes.keypressed(key, unicode)
  if key == "f4" and love.keyboard.isDown("lalt","ralt") then
    love.event.quit()
  end
end
 
function love.keyreleased(key)
  loveframes.keyreleased(key)
end

function openURL(url)
  if love._os == 'OS X' then
    os.execute('open "' .. url .. '" &')
  elseif love._os == 'Windows' then
    os.execute('start ' .. url )
  elseif love._os == 'Linux' then
    os.execute('xdg-open "' .. url .. '" &')
  end
end

function print_r (t, indent) -- alt version, abuse to http://richard.warburton.it
  local indent=indent or ''
  for key,value in pairs(t) do
    io.write(indent,'[',tostring(key),']') 
    if type(value)=="table" then io.write(':\n') print_r(value,indent..'\t')
    else io.write(' = ',tostring(value),'\n') end
  end
end

function love.quit()
  local raw = json.encode(settings.data)
  love.filesystem.write(settings.file, raw)
end
