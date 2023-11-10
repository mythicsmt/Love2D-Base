local Utilities = require "utilities"
local Connection = require "connection"
local Node = require "node"

local BaseBuilding = {}
BaseBuilding.__index = BaseBuilding

function BaseBuilding.new()
    local self = setmetatable({}, BaseBuilding)

    self.alphaNode = nil
    self.blueprintNode = nil
    self.blueprintConnection = nil

    return self
end

function BaseBuilding:enter()
    local centerX = Globals.screenWidth / 2
    local centerY = Globals.screenHeight / 2

    self.alphaNode = Node.new(centerX, centerY, 15)    
    self.blueprintNode = Node.new(centerX, centerY, 5)
end

function BaseBuilding:handleMousePressed(x, y, button, istouch, presses)
    if button == 1 then
        if self.blueprintConnection then
            self.blueprintConnection:addNode(self.blueprintNode)
            self.blueprintConnection.parentNode:addConnection(self.blueprintConnection)

            self.blueprintNode = nil
            self.blueprintConnection = nil
        end
    elseif button == 2 and not self.blueprintNode then
        self.blueprintNode = Node.new(self.alphaNode.x, self.alphaNode.y, 5)
    elseif button == 2 then
        self.blueprintNode.r = self.blueprintNode.r + 5
    end

    self:updateBlueprint(x, y)
end

function BaseBuilding:handleMouseMoved(x, y, dx, dy, istouch)
   self:updateBlueprint(x, y)
end

function BaseBuilding:updateBlueprint(x, y)
    local maxDistance = 100

    if self.blueprintNode then
        self.blueprintNode.x = x
        self.blueprintNode.y = y

        local nearestValidNode = Utilities.nearestValidNode(self.alphaNode, self.blueprintNode)

        if nearestValidNode then
            local distance = Utilities.distance(nearestValidNode.x, nearestValidNode.y, self.blueprintNode.x, self.blueprintNode.y)

            if distance - nearestValidNode.r - self.blueprintNode.r >= maxDistance then
                local angle = math.atan2(self.blueprintNode.y - nearestValidNode.y, self.blueprintNode.x - nearestValidNode.x)

                local newX = nearestValidNode.x + (maxDistance + nearestValidNode.r + self.blueprintNode.r) * math.cos(angle)
                local newY = nearestValidNode.y + (maxDistance + nearestValidNode.r + self.blueprintNode.r) * math.sin(angle)

                self.blueprintNode.x = newX
                self.blueprintNode.y = newY
            end
        end

        if nearestValidNode then
            self.blueprintConnection = Connection.new(nearestValidNode, self.blueprintNode)
        else
            self.blueprintConnection = nil
        end
    end
end

function BaseBuilding:handleKeyPressed(key, scancode, isrepeat)
    --
end

function BaseBuilding:exit()
    --
end

function BaseBuilding:update(dt)
    --
end

function BaseBuilding:draw()
    love.graphics.setLineStyle('rough')
    self.alphaNode:draw()

    if self.blueprintNode and self.blueprintConnection then
        self.blueprintConnection:drawGhost(.5)
        self.blueprintNode:drawGhost(.5)
    elseif self.blueprintNode then
        self.blueprintNode:drawGhost(.1)
    end
end

return BaseBuilding