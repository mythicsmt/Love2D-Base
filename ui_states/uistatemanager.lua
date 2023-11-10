local EscapeScreen = require("ui_states/EscapeScreen")

local UIStateManager = {}
UIStateManager.__index = UIStateManager

function UIStateManager.new()
    local self = setmetatable({}, UIStateManager)

    self.states = {}
    
    self:addState("EscapeScreen", EscapeScreen.new(self))

    return self
end

function UIStateManager:addState(stateName, state)
    self.states[stateName] = state
end

function UIStateManager:clearState()
    if self.currentState then
        self.currentState:exit()
    end

    self.currentState = nil
end

function UIStateManager:changeState(newState)
    if self.currentState then
        self.currentState:exit()
    end

    self.currentState = self.states[newState]

    if self.currentState then
        self.currentState:enter()
    end
end

function UIStateManager:handleMousePressed(x, y, button, istouch, presses)
    if self.currentState then
        self.currentState:handleMousePressed(x, y, button, istouch, presses)
    end
end

function UIStateManager:handleMouseMoved(x, y, dx, dy, istouch)
    if self.currentState then
        self.currentState:handleMouseMoved(x, y, dx, dy, istouch)
    end
end

function UIStateManager:handleKeyPressed(key, scancode, isrepeat)
    if self.currentState then
        self.currentState:handleKeyPressed(key, scancode, isrepeat)
    end
end

function UIStateManager:update(dt)
    if self.currentState then
        self.currentState:update(dt)
    end
end

function UIStateManager:draw()
    if self.currentState then
        self.currentState:draw()
    end
end

function UIStateManager:resumeGame()
    self:clearState()
end

return UIStateManager