local wind = {
    t = 0,
    vel = { x = 0, y = 0 },
    gustTimer = 0,
    gustVel = { x = 0, y = 0 },
    maxGustTime = 300,

    update = function(self)
        -- Randomly change the wind direction
        if self.gustTimer == 0 then
            self.gustTimer = math.random(60, self.maxGustTime)
            self.gustVel.x = self.gustVel.x * 0.9 + (math.random() * 0.5 - 0.25) * 0.1
        end

        self.gustTimer = self.gustTimer - 1

        self.t = (self.t + 1) % 60
        self.vel.x = self.gustVel.x + math.cos(self.t / 40) * .1
    end,
}

return wind
