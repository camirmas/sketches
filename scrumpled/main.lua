local config = require 'config'
local fire = require 'fire'
local smoke = require 'smoke'
local wind = require 'wind'
local stars = require 'stars'
local meteors = require 'meteors'

local canvas
local background

local game = {
    fire = {},
    smoke = {},
    stars = {},
    meteors = {},
    meteorCountDown = 0,
}

function love.load()
    -- This function will run when the game starts.
    -- Use it to initialize your game.
    love.graphics.setFont(love.graphics.newFont(config.font))
    love.graphics.setColor(1, 1, 1)

    -- load background image
    background = love.graphics.newImage('images/bg2.png')

    -- Set the window size
    love.window.setMode(config.width * config.scale, config.height * config.scale, { borderless = true })

    -- Set the window title
    love.window.setTitle('Scrumpled')

    -- Create the canvas
    canvas = love.graphics.newCanvas(config.width, config.height)

    -- Set filter to nearest
    canvas:setFilter('nearest', 'nearest')

    for _ = 1, 50 do
        table.insert(game.stars, stars.createStar())
    end
end

function love.update(dt)
    -- This function is called every frame, with 'dt' being the time in seconds since the last frame.
    -- Use this function for game logic, such as moving objects and checking for collisions.

    -- Update the wind
    wind:update()

    -- Update the stars
    for _, s in ipairs(game.stars) do
        s:update()
    end

    -- Update the fire particles
    for i, f in ipairs(game.fire) do
        f:update()
    end

    -- Update the smoke particles
    for i, s in ipairs(game.smoke) do
        s.vel.x = wind.vel.x + math.random(-10, 10) * .01
        s:update()
    end

    -- Remove dead fire particles
    for i = #game.fire, 1, -1 do
        if not game.fire[i].alive then
            table.remove(game.fire, i)

            -- Chance to create smoke particle
            if math.random() < 0.2 then
                table.insert(game.smoke, smoke.createSmoke(game.fire[i].x, game.fire[i].y))
            end
        end
    end

    -- Remove dead smoke particles
    for i = #game.smoke, 1, -1 do
        if not game.smoke[i].alive then
            table.remove(game.smoke, i)
        end
    end

    -- Create fire particles
    for i = 1, 5 do
        table.insert(game.fire, fire.createFire(math.random(config.width / 2 - 7 + 15, config.width / 2 + 7 + 15),
            config.height - 8))
    end

    -- Create meteor
    if game.meteorCountDown <= 0 then
        table.insert(game.meteors, meteors.createMeteor())
        game.meteorCountDown = math.random(120, 180)
    else
        game.meteorCountDown = game.meteorCountDown - 1

        -- Update the meteors
        for i, m in ipairs(game.meteors) do
            m:update()
        end
    end
end

function love.draw()
    -- This function is called every frame.
    -- Use it to draw on the screen.

    -- Set the color to white
    love.graphics.setColor(1, 1, 1)

    -- Display the number of fire particles
    -- love.graphics.print('Fire particles: ' .. #game.fire, 0, 0)

    -- Set the canvas
    love.graphics.setCanvas(canvas)

    -- Clear the canvas
    love.graphics.clear()

    -- Draw the background
    love.graphics.draw(background, 0, 0)

    -- Draw the stars
    for _, s in ipairs(game.stars) do
        love.graphics.setColor(s.color)
        love.graphics.points(s.x, s.y)
    end

    -- Draw the meteors
    for _, m in ipairs(game.meteors) do
        m:draw()
    end

    -- Draw the smoke
    for _, s in ipairs(game.smoke) do
        s:draw()
    end

    -- Draw the fire
    for _, f in ipairs(game.fire) do
        f:draw()
    end

    -- Reset the color
    love.graphics.setColor(1, 1, 1)

    -- Scale the canvas
    love.graphics.scale(config.scale, config.scale)

    -- Reset the canvas
    love.graphics.setCanvas()

    -- Draw the canvas
    love.graphics.draw(canvas, 0, 0)
end

function love.keypressed(key)
    -- This function is called every time a key is pressed.
    if key == 'escape' then
        love.event.quit()
    end
end
