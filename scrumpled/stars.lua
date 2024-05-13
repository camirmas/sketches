local config = require "config"

local starColors = {
    { 1,   1,   1 },
    { 0.7, 0.7, 1 },
    { 1,   0.8, 0.8 },
    { 0.8, 0.9, 1 },
    { 1,   1,   0.9 },
}

local function createStar()
    local x = math.random(0, config.width)
    local y = math.random(0, config.height * .8)

    return {
        x = x,
        y = y,
        color = starColors[math.random(1, #starColors)],
        vel = { x = 0, y = 0 },
        flickerTime = math.random(5, 10),
        t = 0,

        update = function(self)
            self.t = self.t + 1

            if self.t > self.flickerTime then
                self.t = 0
                self.color = starColors[math.random(1, #starColors)]
            end
        end,

        draw = function(self)
            love.graphics.setColor(self.color)
            love.graphics.points(self.x, self.y)
        end
    }
end

return {
    createStar = createStar
}
