local system = require("System")
local filesystem = require("Filesystem")
local GUI = require("GUI")
local component = require("Component")
local computer = require("computer")
local event = require("Event")
local json = require("JSON")
local internet = require("Internet")

local localization = system.getCurrentScriptLocalization()

local internet = nil
if component.isAvailable("internet") then
  internet = component.internet
else
  GUI.alert(localization.notInternet)
  return
end

local workspace, window = system.addWindow(GUI.filledWindow(1, 1, 39, 23, 0x662480))

local progress = window:addChild(GUI.progressIndicator(window.width - 5, 2, 0x1E1E1E, 0x1E1E1E, 0xA5A5A5))
local url = window:addChild(GUI.input(5, 5, 30, 3, 0x1E1E1E, 0xA5A5A5, 0xA5A5A5, 0x1E1E1E, 0xFFFFFF, "https://", "URL", false))
--local path = window:addChild(GUI.filesystemChooser(5, 13, 30, 3, 0x1E1E1E, 0xA5A5A5, 0x1E1E1E, 0xA5A5A5, localization.choosePath, localization.choose, localization.cancel, localization.choosePath, "/"))
local file = window:addChild(GUI.input(5, 9, 30, 3, 0x1E1E1E, 0xA5A5A5, 0xA5A5A5, 0x1E1E1E, 0xFFFFFF, "/Projects/", "Local", false))
--path:setMode(GUI.IO_MODE_DIRECTORY)
local downloadButton = window:addChild(GUI.button(5, 17, 30, 3, 0x1E1E1E, 0xA5A5A5, 0xA5A5A5, 0x1E1E1E, localization.download))

window:addChild(GUI.text(1, window.height, 0xA5A5A5, "GitHub Dowloader 0.1.5"))


downloadButton.onTouch = function()
  internet.download(url.text, file.text)
  computer.pushSignal("system", "updateFileList")
  workspace:draw()
end