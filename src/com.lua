com = {}

com.queue = {}

function com.load()
  com.thread = love.thread.newThread("com_thread","com_thread.lua")
  com.thread:start()
end

function com.enqueue_request(request,callback)
  table.insert( com.queue, {request=request,callback=callback} )
end

function com.update()
  local response = com.thread:get("response")
  if response then

    local success,ret = pcall(function() return json.decode(response) end)
    if success then

     for i,v in pairs(ret.results) do
       if com.current_request[i] then
         com.current_request[i](v)
       end
     end 

    else
      print(response)
      return {error={"could not decode json."}}
    end
  else
    if com.thread:get("ready") then

      object = {}
      object.username = settings.data.username
      object.requests = com_queue

      com.current_request = com_queue

      local j = json.encode(object)
      local sha1obj = hashlib.sha1()
      sha1obj:process(j..settings.data.secure_key)
      local hash = sha1obj:finish()
      local payload = hash..j
      com.thread:set("payload",payload)

    end
  end
end

function com.blocking_request(object)
  object.username = settings.data.username
  local j = json.encode(object)
  local sha1obj = hashlib.sha1()
  sha1obj:process(j..settings.data.secure_key)
  local hash = sha1obj:finish()
  local payload = hash..j
  local response = http.request(server_base_url.."server.php?i="..payload)
  local success,ret = pcall(function() return json.decode(response) end)
  if success then
    return ret
  else
    print(response)
    return {error={"could not decode json."}}
  end
end

return com 
