local lsystem = require "l_system"
local utils = require "utils"

local createLSystem = lsystem.createLSystem
local applyRules = lsystem.applyRules

-- Function to set the angle for the L-system
local function handleAngle(angle)
    return function(rng)
        return angle
    end
end

-- Function to set the F rule for the L-system
local function handleF(rng)
    local res = "F"

    -- Chance to use double F
    if rng:random() > 0.7 then
        res = res .. "F"
    end

    return res
end

-- Function to handle the bracket rules for the L-system
local function handleBracket(b)
    return function(rng)
        return b
    end
end

-- Function to handle the X rule for the L-system
local function handleX(rng)
    local result

    local angleChanges = { "", "+", "-" }
    local angleChange = angleChanges[rng:random(#angleChanges)]

    if rng:random() > 0.5 then
        angleChange = "+"
    else
        angleChange = "-"
    end

    if rng:random() > 0.4 then
        result = "F-[[X]+" .. angleChange .. "X]+F[+FX]-X"
    elseif rng:random() > 0.2 then
        result = "F[+" .. angleChange .. "X]F[-X]+" .. angleChange .. "X"
    else
        result = "F[+" .. angleChange .. "X]-X"
    end

    if rng:random() > 0.5 then
        result = result .. "o"
    end

    return result
end

-- Function to create a plant
local function createPlant(x, y)
    local axiom = "X"
    local rules = {
        { "X", handleX },
        { "F", handleF },
        { "+", handleAngle("+") },
        { "-", handleAngle("-") },
        { "[", handleBracket("[") },
        { "]", handleBracket("]") }
    }
    local genTime = math.random(0.1, .7)   -- The time between generations
    local maxLifeTime = math.random(5, 10) -- The maximum lifetime of the L-system

    -- Create the L-system
    local lSystem = createLSystem(axiom, rules)

    local flowerColors = {
        { 1,   0.8, 0.8 }, -- Light Pink
        { 0.7, 0.7, 1 },   -- Lavender
        { 1,   0.5, 0.7 }, -- Peach
        { 0.6, 0.8, 1 },   -- Light Blue
        { 1,   1,   0.7 }  -- Soft Yellow
    }
    local flowerColor = flowerColors[math.random(1, #flowerColors)]

    local plant = {
        x = x,
        y = y,
        lSystem = lSystem,
        d = 10,                    -- The distance to move forward
        delta_angle = 15,          -- The angle to turn left or right
        t = 0,                     -- Timer for generation
        genTime = genTime,         -- Time between generations in seconds
        lifeTime = 0,              -- Current lifetime of the plant in seconds
        maxLifeTime = maxLifeTime, -- Maximum lifetime of the plant in seconds
        colors = {
            stem = { 0, 193 / 255, 156 / 255, 1 },
            flowers = flowerColor
        },
        alive = true
    }

    return plant
end

-- Function to update the plant
local function updatePlant(plant, dt)
    plant.lifeTime = plant.lifeTime + dt
    plant.t = plant.t + dt

    if plant.lifeTime > plant.maxLifeTime then
        plant.alive = false
        return
    end
    if plant.t > plant.genTime then
        plant.t = plant.t - plant.genTime
        applyRules(plant.lSystem)
    end
end

-- Function to draw the plant
local function drawPlant(plant, canvas)
    local lSystem = plant.lSystem

    -- Draw the L-system from the bottom center
    love.graphics.setCanvas(canvas)
    love.graphics.push()
    love.graphics.translate(plant.x, plant.y)

    local string = lSystem.currentString
    local x, y = 0, 0
    local d = plant.d
    local delta_angle = plant.delta_angle
    local angle = -90
    local stack = {}

    for i = 1, #string do
        local char = string:sub(i, i)
        if char == 'F' then
            local newX = x + d * math.cos(utils.degToRad(angle))
            local newY = y + d * math.sin(utils.degToRad(angle))
            -- set color
            love.graphics.setColor(plant.colors.stem)
            love.graphics.line(x, y, newX, newY)

            -- reset color
            love.graphics.setColor(1, 1, 1, 1)

            -- update position
            x = newX
            y = newY
        elseif char == '+' then
            angle = math.min(angle + delta_angle) -- Turn right, clamped between minAngle and maxAngle
        elseif char == '-' then
            angle = math.max(angle - delta_angle) -- Turn left, clamped between minAngle and maxAngle
        elseif char == '[' then
            table.insert(stack, { x, y, angle })  -- Push stack
        elseif char == ']' then
            local state = table.remove(stack)     -- Pop stack
            x, y, angle = state[1], state[2], state[3]
        elseif char == 'o' then
            -- Draw flowers
            love.graphics.setColor(plant.colors.flowers)
            love.graphics.circle("fill", x, y, 2)

            -- reset color
            love.graphics.setColor(1, 1, 1, 1)
        end
    end

    love.graphics.pop()
    love.graphics.setCanvas()
end

return {
    createPlant = createPlant,
    updatePlant = updatePlant,
    drawPlant = drawPlant
}
