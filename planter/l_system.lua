local utils = require "utils"

-- Function to create a new L-system with a given axiom and set of production rules
local function createLSystem(axiom, rules)
    return {
        axiom = axiom,                                 -- The initial string of the system
        rules = rules,                                 -- The production rules
        currentString = axiom,                         -- The current state of the string
        genParams = {},                                -- The parameters for the current generation
        gen = 1,                                       -- The current generation
        maxGen = math.random(4, 6),                    -- The maximum number of generations to process
        rng = love.math.newRandomGenerator(os.time()), -- The random number generator
    }
end

-- Function to apply production rules to the L-system to generate the next state
local function applyRules(lSystem)
    -- If the maximum number of generations has been reached, return
    if lSystem.gen >= lSystem.maxGen then
        return
    end

    local newString = ""
    -- Iterate over each character in the current string of the L-system
    for i = 1, #lSystem.currentString do
        local currentChar = lSystem.currentString:sub(i, i)
        local foundRule = false
        -- Check each rule to see if it applies to the current character
        for _, rule in ipairs(lSystem.rules) do
            if rule[1] == currentChar then
                newString = newString .. rule[2](lSystem.rng)
                foundRule = true
                break
            end
        end

        -- If no rule was applied, append the character as is to the new string
        if not foundRule then
            newString = newString .. currentChar
        end
    end
    -- Update the L-system's current string and increment the generation count
    lSystem.currentString = newString
    lSystem.gen = lSystem.gen + 1
end

-- Function to generate multiple generations of an L-system and return the results
local function generate(lSystem, generations)
    local results = {}
    -- Apply the rules the specified number of times and store each generation's result
    for i = 1, generations do
        -- Check if the maximum number of generations has been reached
        if lSystem.generation >= lSystem.maxGen then
            break
        end
        applyRules(lSystem)
        table.insert(results, lSystem.currentString)
    end
    return results
end

-- Function to convert the L-system's current state to a string representation
local function lSystemToString(lSystem)
    return "Generation " .. lSystem.gen .. ": " .. lSystem.currentString
end

-- Return the functions as a module
return {
    createLSystem = createLSystem,
    applyRules = applyRules,
    generate = generate,
    lSystemToString = lSystemToString,
}
