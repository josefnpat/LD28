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

  local terror = com.thread:get("error")
  if terror then
    print(terror)
  end

  local response = com.thread:get("response")
  if response then

    local success,ret = pcall(function() return json.decode(response) end)
    if success then
      if ret.server_time then
        stime = ret.server_time
      end

      if ret.results then
        for i,v in pairs(ret.results) do
          com.current_requests[i].callback(v)
        end
      end

      com.current_requests = {}

      if ret.error then
        gamestate_key.text_info:SetText(ret.error[1])
        gamestate_key.text_info_dt = 0
      end

    else

      print(response)
      gamestate_key.text_info:SetText("Could not decode json.")
      gamestate_key.text_info_dt = 0

    end
  else
    if com.thread:get("ready") then
      com.thread_ready = true
    end

    if com.thread_ready and #com.queue > 0 then

      object = {}
      object.username = settings.data.username

      com.current_requests = com.queue

      local rendered_requests = {}
      for i,v in pairs(com.queue) do
        rendered_requests[i] = v.request
      end
      object.requests = rendered_requests

      local j = json.encode(object)
      local sha1obj = hashlib.sha1()
      sha1obj:process(j..settings.data.secure_key)
      local hash = sha1obj:finish()
      local payload = hash..j

      com.thread:set("payload",payload)
      com.thread_ready = false

      com.queue = {}

    end
  end
end

function com.blocking_request(object)
  print("STOP USING THIS.")
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
