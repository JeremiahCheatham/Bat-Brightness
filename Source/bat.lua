Bat = {
    x = 0,
    y = 0,
    speed = 0,
    spriteNum = 1
}

function Bat:new(width, height, scale, duration)
    local newBat = {}
    newBat.quads = {}
    for y = 0, BatSpriteSheet:getHeight() - height, height do
        for x = 0, BatSpriteSheet:getWidth() - width, width do
            table.insert(newBat.quads, love.graphics.newQuad(x, y, width, height, BatSpriteSheet:getDimensions()))
        end
    end
    newBat.width = width * scale
    newBat.height = height * scale
    newBat.scale = scale
    newBat.duration = duration or 1
    newBat.currentTime = ( math.random(0, 100) / 100 ) * duration
    setmetatable(newBat, self)
    self.__index = self
    return newBat
end

function Bat:reset()
    self.y = math.random(0, (love.graphics.getHeight() - self.height))
    self.speed = math.random(200, 400)
    if math.random(0, 1) == 1 then
        self.x = math.random(love.graphics.getWidth(), love.graphics.getWidth() * 2)
        self.speed = -self.speed
    else
        self.x = math.random(-self.width, -self.width - love.graphics.getWidth())
    end
end

function Bat:update(dt)
    self.x = self.x + self.speed * dt
    if PlayerCollision(self, MyPlayer) then
        Running = false
        GameOver = true
        Over:play()
        Music:stop()
        Hum:stop()
    end
    if MyTorch.spriteNum > 0 then
        if CheckCollision(self, MyTorch) then
            local x1 = self.x + self.width / 2
            local x2 = MyTorch.x + MyTorch.width / 2
            local y1 = self.y + self.height / 2
            local y2 = MyTorch.y + MyTorch.height / 2
            if MyTorch.spriteNum == 1 then
                if (y2 - y1) >= math.abs(x2 - x1) then
                    self:checkDiagonal(x1, x2, y1, y2)
                end
            end
            if MyTorch.spriteNum == 2 then
                if (x1 - x2) >= math.abs(y2 - y1) then
                    self:checkDiagonal(x1, x2, y1, y2)
                end
            end
            if MyTorch.spriteNum == 3 then
                if (y1 - y2) >= math.abs(x2 - x1) then
                    self:checkDiagonal(x1, x2, y1, y2)
                end
            end
            if MyTorch.spriteNum == 4 then
                if (x2 - x1) >= math.abs(y2 - y1) then
                    self:checkDiagonal(x1, x2, y1, y2)
                end
            end
        end
    end
    self:animate(dt)
    self:checkBoundaries()
end

function Bat:checkDiagonal(x1, x2, y1, y2)
    local distance = (MyTorch.width / 2 + self.width / 2)^2
    if distance >= ((x2 - x1) ^ 2 + (y2 - y1) ^ 2) then
        if x1 > x2 then
            self.speed = math.abs(self.speed)
        else
            self.speed = -math.abs(self.speed)
        end
    end
end

function Bat:animate(dt)
    self.currentTime = self.currentTime + dt
    if self.currentTime >= self.duration then
        self.currentTime = self.currentTime - self.duration
    end
    self.spriteNum = math.floor(self.currentTime / self.duration * #self.quads) + 1
end

function Bat:checkBoundaries()
    if self.x < -self.width then
        self:reset()
    elseif self.x > love.graphics.getWidth() then
        self:reset()
    end
end

function Bat:draw()
    love.graphics.draw(BatSpriteSheet, self.quads[self.spriteNum], self.x, self.y, 0, self.scale, self.scale)
end