--[[
    Window resize Script
]]

units = {
    maximum       = { x = 0.00, y = 0.00, w = 1.00, h = 1.00 },
    top50         = { x = 0.00, y = 0.00, w = 1.00, h = 0.50 },
    bot50         = { x = 0.00, y = 0.50, w = 1.00, h = 0.50 },
    left50        = { x = 0.00, y = 0.00, w = 0.50, h = 1.00 },
    right50       = { x = 0.50, y = 0.00, w = 0.50, h = 1.00 },
    left33        = { x = 0.00, y = 0.00, w = 0.34, h = 1.00 },
    right33       = { x = 0.66, y = 0.00, w = 0.34, h = 1.00 },
    left66        = { x = 0.00, y = 0.00, w = 0.66, h = 1.00 },
    right66       = { x = 0.34, y = 0.00, w = 0.66, h = 1.00 },
    top25Left     = { x = 0.00, y = 0.00, w = 0.50, h = 0.50 },
    bot25Left     = { x = 0.00, y = 0.50, w = 0.50, h = 0.50 },
    top25Right    = { x = 0.50, y = 0.00, w = 0.50, h = 0.50 },
    bot25Right    = { x = 0.50, y = 0.50, w = 0.50, h = 0.50 },
}
-- Window base keybinding
mash = { 'shift', 'alt', 'cmd' }

hs.hotkey.bind(mash, 'F',     function() hs.window.focusedWindow():move(units.maximum,     nil, true) end) -- Fullscreen
hs.hotkey.bind(mash, 'C',     function() hs.window.focusedWindow():centerOnScreen(nil, true) end) -- Center

-- Half (50% of screen size)
hs.hotkey.bind(mash, 'Up',    function() hs.window.focusedWindow():move(units.top50,       nil, true) end)
hs.hotkey.bind(mash, 'Down',  function() hs.window.focusedWindow():move(units.bot50,       nil, true) end)
hs.hotkey.bind(mash, 'Left',  function() hs.window.focusedWindow():move(units.left50,      nil, true) end)
hs.hotkey.bind(mash, 'Right', function() hs.window.focusedWindow():move(units.right50,     nil, true) end)

-- Percentage 66% and 33% leftand right
hs.hotkey.bind(mash, 'E',     function() hs.window.focusedWindow():move(units.left66,      nil, true) end)
hs.hotkey.bind(mash, 'R',     function() hs.window.focusedWindow():move(units.right66,     nil, true) end)
hs.hotkey.bind(mash, 'T',     function() hs.window.focusedWindow():move(units.left33,      nil, true) end)
hs.hotkey.bind(mash, 'Y',     function() hs.window.focusedWindow():move(units.right33,     nil, true) end)

-- Quarters (1/4 of screen size)
hs.hotkey.bind(mash, 'Q',     function() hs.window.focusedWindow():move(units.top25Left,   nil, true) end)
hs.hotkey.bind(mash, 'A',     function() hs.window.focusedWindow():move(units.bot25Left,   nil, true) end)
hs.hotkey.bind(mash, 'W',     function() hs.window.focusedWindow():move(units.top25Right,  nil, true) end)
hs.hotkey.bind(mash, 'S',     function() hs.window.focusedWindow():move(units.bot25Right,  nil, true) end)



-- Move the focused window to another monitor
function moveWindowToDisplay(d)
    return function()
        local displays = hs.screen.allScreens()
        local win = hs.window.focusedWindow()
        win:moveToScreen(displays[d], false, true)
    end
end

hs.hotkey.bind(mash, "1", moveWindowToDisplay(1))
hs.hotkey.bind(mash, "2", moveWindowToDisplay(2))


-- spaceModifier has to be a number!
function sendToWorkspace(spaceModifier)
    print('Move: ', spaceModifier)
    local win        = hs.window.frontmostWindow()
    local clickPoint = win:zoomButtonRect()
    local sleepTime  = 1000
  
    -- check if all conditions are ok to move the window
    local shouldMoveWindow = hs.fnutils.every({
      clickPoint ~= nil
    }, function(test) return test end)
  
    if not shouldMoveWindow then return end
  
    clickPoint.x = clickPoint.x + clickPoint.w + 5
    clickPoint.y = clickPoint.y + clickPoint.h / 2
  
    -- fix for Chrome UI
    if win:application():title() == 'Google Chrome' then
      clickPoint.y = clickPoint.y - clickPoint.h
    end
  
    hs.eventtap.event.newMouseEvent(hs.eventtap.event.types.leftMouseDown, clickPoint):post()
    hs.timer.usleep(300000)
  
    moveWorkspace(spaceModifier)
  
    hs.timer.usleep(sleepTime)
    hs.eventtap.event.newMouseEvent(hs.eventtap.event.types.leftMouseUp, clickPoint):post()
  
  end


-- -- -- Define window mode workflow events
local moveWindowLeft = function() sendToWorkspace("Left") end
local moveWindowRight = function() sendToWorkspace("Right") end

hs.hotkey.bind(mash, "O",  moveWindowLeft,   nil, moveWindowLeft)
hs.hotkey.bind(mash, "P",  moveWindowRight,  nil, moveWindowRight)


-- Move between workspaces
function moveWorkspace(spaceModifier)
  hs.eventtap.event.newKeyEvent('ctrl', true):post()
  hs.eventtap.event.newKeyEvent(spaceModifier, true):post()
  hs.timer.usleep(300000)
  hs.eventtap.event.newKeyEvent(spaceModifier, false):post()
  hs.eventtap.event.newKeyEvent('ctrl', false):post()
end



-- -- -- Define window mode workflow events
local moveToLeft = function() moveWorkspace("Left") end
local moveToRight = function() moveWorkspace("Right") end

hs.hotkey.bind(mash, "9",  moveToLeft,   nil, moveToLeft)
hs.hotkey.bind(mash, "0",  moveToRight,  nil, moveToRight)