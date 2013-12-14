require('love.filesystem')
require('config')
require('love.timer')

thisThread = love.thread.getThread()

while true do
  thisThread:set("ready",true)
  local payload = thisThread:demand('payload')
  thisThread:set("ready",false)
  local response = http.request(server_base_url.."server.php?i="..payload)
  thisThread:set("response",response or "fail")
end
