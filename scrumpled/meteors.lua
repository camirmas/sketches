local config = require 'config'

local meteorColors = {
    { 1,   1,   1 },
    { 0.7, 0.7, 1 },
    { 1,   0.8, 0.8 },
    { 0.8, 0.9, 1 },
    { 1,   1,   0.9 },
}

local function createMeteor()
    return {
        x = math.random(0, config.width / 4),
        y = math.random(0, config.height / 2),
        color = meteorColors[math.random(1, #meteorColors)],
        trail = {},
        vel = { x = 4, y = -1 },
        t = 0,
        maxLife = 10 + math.random() * 60,
        alive = true,
        alpha = 1,
        update = function(self)
            self.t = self.t + 1

            if self.t + #self.trail > self.maxLife then
                -- remove the oldest point
                table.remove(self.trail, 1)
            end

            if self.t > self.maxLife then
                self.alive = false
            end
            self.x = self.x + self.vel.x
            self.vel.y = self.vel.y + 0.05
            self.y = self.y + self.vel.y
            self.alpha = 1 - self.t / self.maxLife
            table.insert(self.trail, { x = self.x, y = self.y })
        end,
        draw = function(self)
            local points = {}
            love.graphics.setColor(self.color[1], self.color[2], self.color[3], self.alpha)

            -- Draw the trail
            for i, p in ipairs(self.trail) do
                table.insert(points, p.x)
                table.insert(points, p.y)
            end

            if #points > 3 then
                love.graphics.setLineWidth(1)
                love.graphics.setLineStyle('rough')
                love.graphics.line(points)
            end
        end
    }
end

return {
    createMeteor = createMeteor
}