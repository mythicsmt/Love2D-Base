Node = {}
Node.__index = Node

function Node.new(x, y, r)
    local self = setmetatable({}, Node)
    self.x = x or 0
    self.y = y or 0
    self.r = r or 10

    self.fillColor = {0, 1, 0, 1}
    self.outlineColor = {0, 1, 0, 1}

    self.connections = {}

    return self
end

function Node:addConnection(connection)
    table.insert(self.connections, connection)
end

function Node:draw()
    love.graphics.setColor(self.fillColor)
    love.graphics.circle("fill", self.x, self.y, self.r)

    love.graphics.setColor(self.outlineColor)
    love.graphics.circle("line", self.x, self.y, self.r)

    for _, connection in ipairs(self.connections) do
        connection:draw()
    end    
end

function Node:drawGhost(alpha)
    love.graphics.setColor(self.fillColor[1], self.fillColor[2], self.fillColor[3], alpha)
    love.graphics.circle("fill", self.x, self.y, self.r)

    love.graphics.setColor(self.outlineColor[1], self.outlineColor[2], self.outlineColor[3], alpha)
    love.graphics.circle("line", self.x, self.y, self.r)

    for _, connection in ipairs(self.connections) do
        connection:drawGhost(alpha)
    end    
end

return Node