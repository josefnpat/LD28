com = {}

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
    return {error={"could not decode json."}}
  end
end

return com 
