obs = obslua

g_channel_url = "https://www.youtube.com/@yuki_natsuno_vt"
g_source_name = "YoutubeChat" -- Alphabet Only. îºäpâpêîÇÃÇ›ëŒâû

function get_video_renderer_video_id()
  local handle = io.popen("curl -s "..g_channel_url)
  local result = handle:read("*a")
  result = string.match(result, "\"videoRenderer\":{\"videoId\":\"[^\"]+\"")
  if result ~= nil then
    result = string.match(result, ":\"[^\"]+\"")
    result = string.gsub(result, ":", "")
    result = string.gsub(result, "\"", "")
  end
  return result
end

function get_grid_video_renderer_video_id()
  local handle = io.popen("curl -s "..g_channel_url)
  local result = handle:read("*a")
  result = string.match(result, "\"gridVideoRenderer\":{\"videoId\":\"[^\"]+\"")
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
  video_id = nil
  video_id = get_video_renderer_video_id()
  if video_id == nil then
    video_id = get_grid_video_renderer_video_id()
  end
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
  update_live_url()
  obs.remove_current_callback()
end

function script_load(settings)
  obs.timer_add(load, 5000)
end

