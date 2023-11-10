local ButtonWidget = require("ui_states/ui_widgets/ButtonWidget")

local EscapeScreen = {}
EscapeScreen.__index = EscapeScreen

function EscapeScreen.new(delegate)
    local self = setmetatable({}, EscapeScreen)
    self.delegate = delegate

    self.quitButton = ButtonWidget.new {
        delegate = self,
        width = 150,
        height = 50,
        text = "Exit Game",
        fontcolor = {1, 1, 1, 1},
        outlinecolor = {33/255, 97/255, 140/255, 1},
        fillcolor = {41/255, 128/255, 185/255, 1},
        hoverFillColor = {200/255, 200/255, 200/255, 1},
        hoverFontColor = {80/255, 80/255, 80/255, 1},
        hoverOutlineColor = {150/255, 150/255, 150/255, 1}
    }

    self.resumeGameButton = ButtonWidget.new {
        delegate = self,
        width = 150,
        height = 50,
        text = "Resume Game",
        fontcolor = {1, 1, 1, 1},
        outlinecolor = {33/255, 97/255, 140/255, 1},
        fillcolor = {41/255, 128/255, 185/255, 1},
        hoverFillColor = {200/255, 200/255, 200/255, 1},
        hoverFontColor = {80/255, 80/255, 80/255, 1},
        hoverOutlineColor = {150/255, 150/255, 150/255, 1}
    }

    self:centerObject(self.resumeGameButton)
    self:centerObject(self.quitButton)

    self:moveBy(self.resumeGameButton, 0, -(self.resumeGameButton.height / 2 + 2))
    self:moveBy(self.quitButton, 0, self.quitButton.height / 2 + 2)

    return self
end

function EscapeScreen:enter()
    --
end

function EscapeScreen:exit()
    --
end

function EscapeScreen:handleMousePressed(x, y, button, istouch, presses)
    self.resumeGameButton:handleMousePressed(x, y, button, istouch, presses)
    self.quitButton:handleMousePressed(x, y, button, istouch, presses)
end

function EscapeScreen:handleMouseMoved(x, y, dx, dy, istouch)
    --
end

function EscapeScreen:handleKeyPressed(key, scancode, isrepeat)
    --
end

function EscapeScreen:update(dt)
    --
end

function EscapeScreen:draw()
    self.resumeGameButton:draw()
    self.quitButton:draw()
end

function EscapeScreen:buttonClicked(button)
    if button == self.quitButton then
        love.event.quit()
    elseif button == self.resumeGameButton then
        if self.delegate and type(self.delegate.resumeGame) == "function" then
            self.delegate:resumeGame()
        end
    end
end

function EscapeScreen:centerObject(object)
    local newX = love.graphics.getWidth() / 2 - object.width / 2
    local newY = love.graphics.getHeight() / 2 - object.height / 2

    object.x = newX
    object.y = newY
end

function EscapeScreen:moveBy(object, x, y)
    object.x = object.x + x
    object.y = object.y + y
end

function EscapeScreen:moveTo(object, x, y)
    object.x = x
    object.y = y
end

return EscapeScreen