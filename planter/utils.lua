-- Function to sample from a Gaussian distribution
local function sampleFromGaussian(mean, stdDev)
    local u1 = math.random()
    local u2 = math.random()
    local z = math.sqrt(-2 * math.log(u1)) * math.cos(2 * math.pi * u2)
    return mean + z * stdDev
end

-- Degree to radian conversion
local function degToRad(deg)
    return deg * math.pi / 180
end

-- Radian to degree conversion
local function radToDeg(rad)
    return rad * 180 / math.pi
end

return {
    sampleFromGaussian = sampleFromGaussian,
    degToRad = degToRad,
    radToDeg = radToDeg,
}
