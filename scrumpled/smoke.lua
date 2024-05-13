local smokeColors = {
    { 0.5,  0.5,  0.5 }, -- Gray
    { 0.6,  0.6,  0.6 }, -- Light Gray
    { 0.4,  0.4,  0.4 }, -- Dark Gray
    { 0.7,  0.7,  0.7 }, -- Very Light Gray
    { 0.3,  0.3,  0.3 }, -- Very Dark Gray
    { 0.55, 0.55, 0.55 }, -- Medium Gray
}

local function createSmoke(x, y)
    return {
        x = x,
        y = y,
        color = smokeColors[math.random(1, #smokeColors)],
        vel = { x = 0, y = -.2 },
        t = 0,
        maxLife = math.random(1, 10) * 60,
        alive = true,
        update = function(self)
            self.t = self.t + 1
            if self.t > self.maxLife then
                self.alive = false
            end
            self.x = self.x + self.vel.x
            self.y = self.y + self.vel.y + 0.1 * math.sin(self.t / 10)
            self.alpha = 1 - self.t / self.maxLife
        end,
        draw = function(self)
            love.graphics.setColor(self.color[1], self.color[2], self.color[3], self.alpha)
            love.graphics.points(self.x, self.y)
        end
    }
end

return {
    createSmoke = createSmoke
}
