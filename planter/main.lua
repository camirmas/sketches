local love = require 'love'
local lsystem = require 'l_system'
local plant = require 'plant'

local debug = false

local lSystemToString = lsystem.lSystemToString

local canvas
local plants = {}
local plantInterval = .1
local maxPlants = 30
local scale = 1
local window = { width = 1080, height = 1920 }
local t = 0
local paused = true

function love.load()
    -- Set random seed
    math.randomseed(os.time())

    -- Set the window size
    love.window.setMode(window.width, window.height, { borderless = true })

    -- Set nearest-neighbor scaling
    love.graphics.setDefaultFilter("nearest", "nearest")

    -- Create the canvas
    canvas = love.graphics.newCanvas(window.width / scale, window.height / scale)
end

function love.update(dt)
    -- If space pressed, pause or unpause
    if love.keyboard.isDown("space") then
        paused = not paused
    end

    if paused then
        return
    end

    -- Update the L-system
    for _, p in ipairs(plants) do
        plant.updatePlant(p, dt)
    end

    -- Remove dead plants
    for i = #plants, 1, -1 do
        if not plants[i].alive then
            table.remove(plants, i)
        end
    end

    -- Increment the timer
    t = t + dt

    if t > plantInterval and #plants < maxPlants then
        local p = plant.createPlant(math.random(0, window.width / scale), math.random(100 / scale, window.height / scale))
        table.insert(plants, p)
        t = 0
    end
end

function love.draw()
    -- Set the canvas as the drawing target
    love.graphics.setCanvas(canvas)

    -- Clear the canvas
    love.graphics.clear(1 / 255, 77 / 255, 62 / 255)

    -- Draw the plants
    for _, p in ipairs(plants) do
        plant.drawPlant(p, canvas)
    end

    -- Reset the drawing target to the screen
    love.graphics.setCanvas()

    -- Draw the canvas to the screen
    love.graphics.draw(canvas, 0, 0, 0, scale, scale)

    -- Draw the L-system generation count
    if debug and #plants > 0 then
        love.graphics.print(lSystemToString(plants[1].lSystem), 10, 10)
        love.graphics.print("Generation: " .. plants[1].lSystem.gen, 10, 30)
        love.graphics.print("Time: " .. plants[1].t, 10, 50)
    end
end
