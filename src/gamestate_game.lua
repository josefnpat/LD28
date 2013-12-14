gamestate_game = {}

function gamestate_game.draw(self)
  love.graphics.printf(
    "WELCOME TO THE PRE-PRE-PRE-DARE-PROTOTYPE-ALPHA\n"..
    "USER "..settings.data.username.."\n"..
    "Your current position is ("..userdata.x..","..userdata.y..","..userdata.z..")\n"..
    "Your warp eta is: "..userdata.warp_eta.." (0 means not in warp.)\n"..
    "",100,100,600,"center")
end

return gamestate_game
