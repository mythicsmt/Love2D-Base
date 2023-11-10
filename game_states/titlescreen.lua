local TitleScreen = {}
TitleScreen.__index = TitleScreen

function TitleScreen.new()
    local self = setmetatable({}, TitleScreen)

    return self
end

function TitleScreen:enter()
    --
end

function TitleScreen:exit()
    --
end

function TitleScreen:handleMousePressed(x, y, button, istouch, presses)
    --
end

function TitleScreen:handleMouseMoved(x, y, dx, dy, istouch)
    --
end

function TitleScreen:handleKeyPressed(key, scancode, isrepeat)
    --
end

function TitleScreen:update(dt)
    --
end

function TitleScreen:draw()
    --
end

return TitleScreen