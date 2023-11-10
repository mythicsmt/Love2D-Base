local Utilities = require "utilities"
Connection = {}
Connection.__index = Connection

function Connection.new(node1, node2)
    local self = setmetatable({}, Connection)
    local point1, point2 = Utilities.calculateIntersectionsOnLineBetweenCircles(node1, node2)

    if not point1 or not point2 then
        return nil
    end

    self.x1 = point1.x
    self.y1 = point1.y
    self.x2 = point2.x
    self.y2 = point2.y

    self.parentNode = node1
    self.baseColor = {.5, .7, .9}
    self.nodes = {}

    return self
end

function Connection:addNode(node)
    table.insert(self.nodes, node)
end

function Connection:draw()
    love.graphics.setColor(self.baseColor)
    love.graphics.line(self.x1, self.y1, self.x2, self.y2)

    for _, node in ipairs(self.nodes) do
        node:draw()
    end       
end

function Connection:drawGhost(alpha)
    love.graphics.setColor(self.baseColor[1], self.baseColor[2], self.baseColor[3], alpha)
    love.graphics.line(self.x1, self.y1, self.x2, self.y2)

    for _, node in ipairs(self.nodes) do
        node:drawGhost(alpha)
    end           
end

return Connection