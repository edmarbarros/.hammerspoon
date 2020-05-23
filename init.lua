----------------------------------------------------------------------------------------------------
-- Main init file
--


-- Reload Hammerspoon hotkey
hs.hotkey.bind({ "alt", "ctrl", "shift" }, "r", function() hs.reload() end)

-- Start IPC module
require("hs.ipc")

-- Local Modules
local WindowManagment            = require('window/WindowManagment')
