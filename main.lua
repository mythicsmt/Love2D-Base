require "globals"

local GameStateManager = require("game_states/GameStateManager")
local UIStateManager = require("ui_states/UIStateManager")

local gameStateManager
local uiStateManager

local scaleX, scaleY

function love.load()
    love.window.setTitle("Node Management")
    love.graphics.setDefaultFilter("nearest", "nearest")

    local fullscreenModes = love.window.getFullscreenModes()
    local screenWidth, screenHeight, fullscreen = 0, 0, true

    -- Find a supported fullscreen resolution 
    for _, mode in ipairs(fullscreenModes) do
        if mode.width >= Globals.screenWidth and mode.height >= Globals.screenHeight then
            screenWidth, screenHeight = mode.width, mode.height
            break
        end
    end

    -- Remove "true" for flexible fullscreen resolution support
    if true or screenWidth == 0 or screenHeight == 0 then
        -- No supported resolution found, falling back to a default windowed resolution
        screenWidth, screenHeight, fullscreen = Globals.screenWidth, Globals.screenHeight, false
    end

    love.window.setMode(screenWidth, screenHeight, { fullscreen = fullscreen })

    local scaleX = love.graphics.getWidth() / Globals.screenWidth
    local scaleY = love.graphics.getHeight() / Globals.screenHeight

    Globals.scaleFactor = math.min(scaleX, scaleY)
    Globals.backBufferCanvas = love.graphics.newCanvas(Globals.screenWidth, Globals.screenHeight)
    Globals.backBufferCanvas:setFilter("nearest", "nearest")
    
    Globals.backBufferCanvasX = (love.graphics.getWidth() - Globals.screenWidth * Globals.scaleFactor) / 2
    Globals.backBufferCanvasY = (love.graphics.getHeight() - Globals.screenHeight * Globals.scaleFactor) / 2

    gameStateManager = GameStateManager.new()
    uiStateManager = UIStateManager.new()
end

function love.mousepressed(x, y, button, istouch, presses)
    local newX = x / Globals.scaleFactor - Globals.backBufferCanvasX / Globals.scaleFactor
    local newY = y / Globals.scaleFactor - Globals.backBufferCanvasY / Globals.scaleFactor

    gameStateManager:handleMousePressed(newX, newY, button, istouch, presses)
    uiStateManager:handleMousePressed(x, y, button, istouch, presses)
end

function love.mousemoved(x, y, dx, dy, istouch)
    local newX = x / Globals.scaleFactor - Globals.backBufferCanvasX / Globals.scaleFactor
    local newY = y / Globals.scaleFactor - Globals.backBufferCanvasY / Globals.scaleFactor

    gameStateManager:handleMouseMoved(newX, newY, dx, dy, istouch)
    uiStateManager:handleMouseMoved(x, y, dx, dy, istouch)
end

function love.keypressed(key, scancode, isrepeat)
    if key == "escape" then
        uiStateManager:changeState("EscapeScreen")
        return
    end

    gameStateManager:handleKeyPressed(key, scancode, isrepeat)
    uiStateManager:handleKeyPressed(key, scancode, isrepeat)
end

function love.update(dt)
    gameStateManager:update(dt)
    uiStateManager:update(dt)
end

function love.draw()
    love.graphics.setCanvas(Globals.backBufferCanvas)
    love.graphics.clear()
    
    gameStateManager:draw()

    love.graphics.setCanvas()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(Globals.backBufferCanvas, Globals.backBufferCanvasX, Globals.backBufferCanvasY, 0, Globals.scaleFactor, Globals.scaleFactor)    

    uiStateManager:draw()
end

