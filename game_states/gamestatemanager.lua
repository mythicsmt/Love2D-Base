local TitleScreen = require("game_states/TitleScreen")
local BaseBuilding = require("game_states/BaseBuilding")

local GameStateManager = {}
GameStateManager.__index = GameStateManager

function GameStateManager.new()
    local self = setmetatable({}, GameStateManager)
    
    self.states = {}
    
    self:addState("TitleScreen", TitleScreen.new())
    self:addState("BaseBuilding", BaseBuilding.new())

    self:changeState("BaseBuilding")

    return self
end

function GameStateManager:addState(stateName, state)
    self.states[stateName] = state
end

function GameStateManager:changeState(newState)
    if self.currentState then
        self.currentState:exit()
    end

    self.currentState = self.states[newState]

    if self.currentState then
        self.currentState:enter()
    end
end

function GameStateManager:handleMousePressed(x, y, button, istouch, presses)
    if self.currentState then
        self.currentState:handleMousePressed(x, y, button, istouch, presses)
    end
end

function GameStateManager:handleMouseMoved(x, y, dx, dy, istouch)
    if self.currentState then
        self.currentState:handleMouseMoved(x, y, dx, dy, istouch)
    end
end

function GameStateManager:handleKeyPressed(key, scancode, isrepeat)
    if self.currentState then
        self.currentState:handleKeyPressed(key, scancode, isrepeat)
    end
end

function GameStateManager:update(dt)
    if self.currentState then
        self.currentState:update(dt)
    end
end

function GameStateManager:draw()
    if self.currentState then
        self.currentState:draw()
    end
end

return GameStateManager