
-- Import libraries
local GUI = require("GUI")
local system = require("System")
local devices = require("Component")
local component = require("component")
---------------------------------------------------------------------------------
local adapters = component.list()
-- Add a new window to MineOS workspace
local workspace, window, menu = system.addWindow(GUI.filledWindow(1, 1, 60, 20, 0xE1E1E1))

-- Add single cell layout to window
local layout = window:addChild(GUI.layout(1, 1, window.width, window.height, 1, 1))

--component.getItemsInNetwork([filter:table]):table
-- Add nice gray text object to layout
for i = 0, #adapters do
  layout:addChild(GUI.text(1, 1, 0x4B4B4B, "ad".. adapters[i]))
end
--local screenText = layout:addChild(GUI.text(1, 1, 0x4B4B4B, "123"))
--local screenText2 = layout:addChild(GUI.text(1, 1, 0x4B4B4B, "asd"))

-- Customize MineOS menu for this application by your will
local contextMenu = menu:addContextMenuItem("File")
contextMenu:addItem("New")
contextMenu:addSeparator()
contextMenu:addItem("Open")
contextMenu:addItem("Save", true)
contextMenu:addItem("Save as")
contextMenu:addSeparator()
contextMenu:addItem("Close").onTouch = function()
	window:remove()
end

-- You can also add items without context menu
menu:addItem("Example item").onTouch = function()
	GUI.alert("It works!")
end

-- Create callback function with resizing rules when window changes its' size
window.onResize = function(newWidth, newHeight)
  window.backgroundPanel.width, window.backgroundPanel.height = newWidth, newHeight
  layout.width, layout.height = newWidth, newHeight
end

---------------------------------------------------------------------------------

-- Draw changes on screen after customizing your window
workspace:draw()