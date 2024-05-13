local fireColors = {
    { 0.9, 0.4, 0.1 }, -- Deep orange
    { 0.9, 0.2, 0 }, -- Dark red
    { 1,   0.5, 0.1 }, -- Bright orange
    { 0.8, 0.1, 0 }, -- Darker red
    { 1,   0.6, 0.2 }, -- Soft red
    { 1,   0.3, 0 }, -- Orange
    { 0.9, 0.5, 0.2 }, -- Amber
    { 1,   0.2, 0 }, -- Bright red
    { 0.8, 0.3, 0.1 }, -- Reddish
}

local function createFire(x, y)
    return {
        x = x,
        y = y,
        color = fireColors[math.random(1, #fireColors)],
        vel = { x = 0, y = -.25 },
        t = 0,
        maxLife = math.random(20, 50) + (math.random() < 0.2 and math.random(15, 30) or 0),
        alpha = 1,
        alive = true,
        update = function(self)
            self.t = self.t + 1
            if self.t > self.maxLife then
                self.alive = false
            end
            self.x = self.x + self.vel.x
            self.y = self.y + self.vel.y
            self.alpha = 1 - self.t / self.maxLife
        end,
        draw = function(self)
            love.graphics.setColor(self.color[1], self.color[2], self.color[3], self.alpha)
            love.graphics.points(self.x, self.y)
        end
    }
end

return {
    createFire = createFire
}
