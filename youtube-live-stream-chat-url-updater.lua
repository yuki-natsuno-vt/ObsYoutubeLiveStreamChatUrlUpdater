obs = obslua

g_channel_url = ""
g_source_name = "" -- Alphabet Only. 半角英数のみ対応

function get_video_id()
  local handle = io.popen("curl -s "..g_channel_url)
  local stdout = handle:read("*a")
  result = string.match(stdout, "\"videoRenderer\":{\"videoId\":\"[^\"]+\"")
  if result == nil then
    result = string.match(stdout, "\"gridVideoRenderer\":{\"videoId\":\"[^\"]+\"")
  end
  if result ~= nil then
    result = string.match(result, ":\"[^\"]+\"")
    result = string.gsub(result, ":", "")
    result = string.gsub(result, "\"", "")
  end
  return result
end

function confirm_curl()
  local handle = io.popen("curl --version ")
  local result = handle:read("*a")
  if result == "" then
    print("Error: curl command is not found.")
    return false
  end
  return true
end

function update_live_url()
  if g_channel_url == "" then
    print("Error: Channel URL is not set.")
    return
  end
  
  if g_source_name == "" then
    print("Error: Source name is not set.")
    return
  end
  
  video_id = get_video_id()
  if video_id == nil then
    if confirm_curl() then
      print("Error: videoId was not found.")
    end
    return
  end
  
  source = obs.obs_get_source_by_name(g_source_name)
  
  if source == nil then
    print("Error: Target source is not found. "..g_source_name)
    return
  end
  
  settings = obs.obs_source_get_settings(source)
  obs.obs_data_set_string(settings, "url", "https://www.youtube.com/live_chat?v="..video_id)
  obs.obs_source_update(source, settings)
  obs.obs_source_release(source)
end

function button(props, p)
  update_live_url()
  return false
end


function script_update(settings)
  g_channel_url = obs.obs_data_get_string(settings, "channel_url")
  g_source_name = obs.obs_data_get_string(settings, "source_name")
end

function script_properties()
  local props = obs.obs_properties_create()
  obs.obs_properties_add_text(props, "channel_url", "Channel URL", obs.OBS_TEXT_DEFAULT)
  obs.obs_properties_add_text(props, "source_name", "Source name", obs.OBS_TEXT_DEFAULT)
  obs.obs_properties_add_button(props, "button", "Update LiveChat URL", button)
  return props
end

function load()
  if g_channel_url ~= "" and g_source_name ~= "" then
    update_live_url()
  end
  obs.remove_current_callback()
end

function script_load(settings)
  obs.timer_add(load, 5000)
end

