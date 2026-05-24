obs = obslua

g_channel_url = ""
g_source_name1 = "" -- Alphabet Only. 半角英数のみ対応
g_source_name2 = ""
g_source_name3 = ""
g_source_name4 = ""
g_source_name5 = ""
g_source_name6 = ""
g_source_name7 = ""
g_source_name8 = ""
g_source_name9 = ""

function get_video_id()
  local handle = io.popen("curl -s "..g_channel_url)
  local stdout = handle:read("*a")

  local yt_initial_data = string.match(stdout, "ytInitialData.*$")
  -- Split text. ","&"{" .
  local lines = {}
  for s in string.gmatch(stdout, "[^,{]+") do
    lines[#lines+1] = s
  end

  -- text seach mode.
  local SEARCH_THUMBNAIL_BADGE_VIEW_MODEL = 0
  local SEARCH_DURATION_TEXT              = 1
  local SEARCH_METADATA_PARTS             = 2
  local SEARCH_DATE                       = 3
  local SEARCH_VIDEO_ID                   = 4

  -- Search data.
  local mode = SEARCH_THUMBNAIL_BADGE_VIEW_MODEL
  local video_id = nil
  local upcoming_date = "9999/99/99 99:99"

  for i, v in ipairs(lines) do
    if mode == SEARCH_THUMBNAIL_BADGE_VIEW_MODEL then
      local str = string.match(v, "\"thumbnailBadgeViewModel\":")
      if str then
        mode = SEARCH_DURATION_TEXT
      end

    elseif mode == SEARCH_DURATION_TEXT then
      local str = string.match(v, "\"text\":\"[^:0-9]+\"") -- 長さなし == 配信予定 or ライブ.
      if str then
        mode = SEARCH_METADATA_PARTS
      else
        str = string.match(v, "\"delimiter\"") -- 要素の終端判定.
        if str then
          mode = SEARCH_THUMBNAIL_BADGE_VIEW_MODEL
        end
      end

    elseif mode == SEARCH_METADATA_PARTS then
      local str = string.match(v, "\"metadataParts\"")
      if str then
        mode = SEARCH_DATE
      end

    elseif mode == SEARCH_DATE then
      local date = nil
      local time = nil
      str = string.match(v, "\"delimiter\"") -- 要素の終端判定.
      if str then -- No Date == Now Live
        date = "0000/00/00"
        time = "00:00"
      else
        date, time = string.match(v, "\"content\":\"(%d%d%d%d/%d%d/%d%d) (%d+:%d%d)")
      end

      if date then
        if string.len(time) == 4 then
          time = "0" .. time
        end
        str = date .. " " .. time
        if upcoming_date > str then
          upcoming_date = str
          mode = SEARCH_VIDEO_ID
        else
          mode = SEARCH_THUMBNAIL_BADGE_VIEW_MODEL
        end
      end

    elseif mode == SEARCH_VIDEO_ID then
      local str = string.match(v, "\"contentId\":\"[^\"]+\"")
      if str then
        -- Get video id
        str = string.match(str, ":\"[^\"]+\"")
        str = string.gsub(str, ":", "")
        str = string.gsub(str, "\"", "")
        video_id = str
        mode = SEARCH_THUMBNAIL_BADGE_VIEW_MODEL
      end

    end
  end

  return video_id
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

  video_id = get_video_id()
  if video_id == nil then
    if confirm_curl() then
      print("Error: videoId was not found.")
    end
    return
  end
  print(g_channel_url)
  print(video_id)

  source_name_list = {
    g_source_name1,
    g_source_name2,
    g_source_name3,
    g_source_name4,
    g_source_name5,
    g_source_name6,
    g_source_name7,
    g_source_name8,
    g_source_name9
  }

  for i = 1, #source_name_list do
    source_name = source_name_list[i]
    if source_name ~= "" then
      source = obs.obs_get_source_by_name(source_name)
      if source ~= nil then
        settings = obs.obs_source_get_settings(source)
        obs.obs_data_set_string(settings, "url", "https://www.youtube.com/live_chat?v="..video_id)
        obs.obs_source_update(source, settings)
        obs.obs_source_release(source)
      end
    end
  end

end

function button(props, p)
  update_live_url()
  return false
end


function script_update(settings)
  g_channel_url = obs.obs_data_get_string(settings, "channel_url")
  g_source_name1 = obs.obs_data_get_string(settings, "source_name1")
  g_source_name2 = obs.obs_data_get_string(settings, "source_name2")
  g_source_name3 = obs.obs_data_get_string(settings, "source_name3")
  g_source_name4 = obs.obs_data_get_string(settings, "source_name4")
  g_source_name5 = obs.obs_data_get_string(settings, "source_name5")
  g_source_name6 = obs.obs_data_get_string(settings, "source_name6")
  g_source_name7 = obs.obs_data_get_string(settings, "source_name7")
  g_source_name8 = obs.obs_data_get_string(settings, "source_name8")
  g_source_name9 = obs.obs_data_get_string(settings, "source_name9")
end

function script_properties()
  local props = obs.obs_properties_create()
  obs.obs_properties_add_text(props, "channel_url", "Channel [Live] Tab URL", obs.OBS_TEXT_DEFAULT)
  obs.obs_properties_add_text(props, "source_name1", "Source name1", obs.OBS_TEXT_DEFAULT)
  obs.obs_properties_add_text(props, "source_name2", "Source name2", obs.OBS_TEXT_DEFAULT)
  obs.obs_properties_add_text(props, "source_name3", "Source name3", obs.OBS_TEXT_DEFAULT)
  obs.obs_properties_add_text(props, "source_name4", "Source name4", obs.OBS_TEXT_DEFAULT)
  obs.obs_properties_add_text(props, "source_name5", "Source name5", obs.OBS_TEXT_DEFAULT)
  obs.obs_properties_add_text(props, "source_name6", "Source name6", obs.OBS_TEXT_DEFAULT)
  obs.obs_properties_add_text(props, "source_name7", "Source name7", obs.OBS_TEXT_DEFAULT)
  obs.obs_properties_add_text(props, "source_name8", "Source name8", obs.OBS_TEXT_DEFAULT)
  obs.obs_properties_add_text(props, "source_name9", "Source name9", obs.OBS_TEXT_DEFAULT)
  obs.obs_properties_add_button(props, "button", "Update LiveChat URL", button)
  return props
end

function load()
  if g_channel_url ~= "" then
    update_live_url()
  end
  obs.remove_current_callback()
end

function script_load(settings)
  obs.timer_add(load, 5000)
end

