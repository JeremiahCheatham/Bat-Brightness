Battery = {
    x = 0,
    y = 0,
}

function Battery:new(width, height, scale)
    local newBattery = {}
    newBattery.width = width * scale
    newBattery.height = height * scale
    newBattery.scale = scale
    setmetatable(newBattery, self)
    self.__index = self
    return newBattery
end

function Battery:reset()
    self.y = math.random(0, (love.graphics.getHeight() - self.height))
    self.x = math.random(0, (love.graphics.getWidth() - self.width))
end

function Battery:update()
    if PlayerCollision(self, MyPlayer) then
        Power = Power + 25
        if Power > 100 then
            Power = 100
        end
        Pickup:play()
        self:reset()
    end
end


function Battery:draw()
    love.graphics.draw(BatterySpriteSheet, self.x, self.y, 0, self.scale, self.scale)
end