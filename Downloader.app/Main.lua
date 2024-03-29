local system = require("System")
local filesystem = require("Filesystem")
local GUI = require("GUI")
local component = require("Component")
local computer = require("computer")
local event = require("Event")
local json = require("JSON")

local internet = nil
if component.isAvailable("internet") then
  internet = component.internet
else
  GUI.alert("No internet card")
  return
end

local workspace, window = system.addWindow(GUI.filledWindow(1, 1, 39, 23, 0x662480))

local progress = window:addChild(GUI.progressIndicator(window.width - 5, 2, 0x1E1E1E, 0x1E1E1E, 0xA5A5A5))
local url = window:addChild(GUI.input(5, 5, 30, 3, 0x1E1E1E, 0xA5A5A5, 0xA5A5A5, 0x1E1E1E, 0xFFFFFF, "https://", "URL", false))
--local path = window:addChild(GUI.filesystemChooser(5, 13, 30, 3, 0x1E1E1E, 0xA5A5A5, 0x1E1E1E, 0xA5A5A5, localization.choosePath, localization.choose, localization.cancel, localization.choosePath, "/"))
local file = window:addChild(GUI.input(5, 9, 30, 3, 0x1E1E1E, 0xA5A5A5, 0xA5A5A5, 0x1E1E1E, 0xFFFFFF, "/Projects/", "Local", false))
--path:setMode(GUI.IO_MODE_DIRECTORY)
local downloadButton = window:addChild(GUI.button(5, 17, 30, 3, 0x1E1E1E, 0xA5A5A5, 0xA5A5A5, 0x1E1E1E, "Download"))

window:addChild(GUI.text(1, window.height, 0xA5A5A5, "GitHub Dowloader 0.1.6"))

local function request(url, body, headers, timeout)
  local newUrl = url:gsub("%s", "%%20")
  local handle, error = internet.request(newUrl, body, headers)
  
  if not handle then
    return nil, (localization.requestFailed):format(error or localization.unknownError)
  end

  local start = computer.uptime()
  
  while true do
    local status, error = handle.finishConnect()
    
    if status then
      break
    end
    
    if status == nil then
      return nil, (localization.requestFailed):format(error or localization.unknownError)
    end
    
    if computer.uptime() >= start + timeout then
      handle.close()

      return nil, localization.timeout
    end
    
    event.sleep(0.05)
  end

  return handle
end

local function ReadUrl(url)
  local handle, error = request(url, nil, nil, 10)
  local data = ""
  progress.active = true

  if not error then
    while true do
      local chunk, error = handle.read()
      if chunk then
        data = data .. chunk
        progress:roll()
        workspace:draw()
      else
        break
      end
    end
  else
    GUI.alert(error)
    progress.active = false
    return
  end
  progress.active = false
  handle.close()

  return data
end

local function downloader(url, file)
  local data = ReadUrl(url)
  if data then
    filesystem.write(file, ReadUrl(url))
    computer.pushSignal("system", "updateFileList")
  end
end

downloadButton.onTouch = function()
    downloader(url.text, file.text) 
    workspace:draw()
end