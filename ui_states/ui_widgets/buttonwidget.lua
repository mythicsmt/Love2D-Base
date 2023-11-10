ButtonWidget = {}
ButtonWidget.__index = ButtonWidget

function ButtonWidget.new(params)
    local self = setmetatable({}, ButtonWidget)

    self.delegate = params.delegate or nil
    self.x = params.x or 0
    self.y = params.y or 0
    self.width = params.width or 100
    self.height = params.height or 30
    self.text = params.text or "Button"
    self.fontcolor = params.fontcolor or {1, 1, 1, 1}
    self.outlinecolor = params.outlinecolor or {1, 1, 1, 1}
    self.fillcolor = params.fillcolor or {1, 1, 1, 1}
    self.hoverFillColor = params.hoverFillColor or {.8, .8, .8, 1}    
    self.hoverFontColor = params.hoverFontColor or {1, 1, 1, 1}    
    self.hoverOutlineColor = params.hoverOutlineColor or {.6, .6, .6, 1}
    self.isMouseOver = false

    return self
end

function ButtonWidget:draw()
    local mouseX = love.mouse.getX()
    local mouseY = love.mouse.getY()
    self.isMouseOver = self:isPointInside(mouseX, mouseY)

    love.graphics.setLineWidth(2)

    if self.isMouseOver then
        love.graphics.setColor(self.hoverFillColor)
    else
        love.graphics.setColor(self.fillcolor)
    end
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)

    if self.isMouseOver then
        love.graphics.setColor(self.hoverOutlineColor)
    else
        love.graphics.setColor(self.outlinecolor)
    end    
    love.graphics.rectangle("line", self.x, self.y, self.width, self.height)

    if self.isMouseOver then
        love.graphics.setColor(self.hoverFontColor)
    else
        love.graphics.setColor(self.fontcolor)
    end
    local textWidth = love.graphics.getFont():getWidth(self.text)
    local textHeight = love.graphics.getFont():getHeight()
    local textX = self.x + (self.width - textWidth) / 2
    local textY = self.y + (self.height - textHeight) / 2
    love.graphics.print(self.text, textX, textY)

    love.graphics.setLineWidth(1)
end

function ButtonWidget:handleMousePressed(x, y, button, istouch, presses)
    if self:isPointInside(x, y) then
        if self.delegate and type(self.delegate.buttonClicked) == "function" then
            self.delegate:buttonClicked(self)
        end
    end
end

function ButtonWidget:isPointInside(x, y)
    return x >= self.x and x <= self.x + self.width and y >= self.y and y <= self.y + self.height
end

return ButtonWidget