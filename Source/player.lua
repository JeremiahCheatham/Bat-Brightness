Player = {
    x = 300,
    y = 300,
    speed = 500,
    spriteNum = 1,
    isRight = true,
    isMoving = false
}

function Player:new(width, height, scale, duration)
    local newPlayer = {}
    newPlayer.quads = {}
    for y = 0, PlayerSpriteSheet:getHeight() - height, height do
        for x = 0, PlayerSpriteSheet:getWidth() - width, width do
            table.insert(newPlayer.quads, love.graphics.newQuad(x, y, width, height, PlayerSpriteSheet:getDimensions()))
        end
    end
    newPlayer.width = width * scale
    newPlayer.height = height * scale
    newPlayer.scale = scale
    newPlayer.duration = duration or 1
    newPlayer.currentTime = 0
    setmetatable(newPlayer, self)
    self.__index = self
    return newPlayer
end

function Player:update(dt)
    self:moove(dt)
    self:animate(dt)
    self:checkBoundaries()
end

function Player:animate(dt)
    if self.isMoving then
        self.currentTime = self.currentTime + dt
        if self.currentTime >= self.duration then
            self.currentTime = self.currentTime - self.duration
        end
        self.spriteNum = math.floor(self.currentTime / self.duration * (#self.quads - 1)) + 2
    else
        self.spriteNum = 1
        self.currentTime = 0
    end
end

function Player:moove(dt)
    self.isMoving = false
    if love.keyboard.isDown("w") then
        self.y = self.y - self.speed * dt
        self.isMoving = true
    end
    if love.keyboard.isDown("s") then
        self.y = self.y + self.speed * dt
        self.isMoving = true
    end
    if love.keyboard.isDown("a") then
        self.x = self.x - self.speed * dt
        self.isRight = false
        self.isMoving = true
    end
    if love.keyboard.isDown("d") then
        self.x = self.x + self.speed * dt
        self.isRight = true
        self.isMoving = true
    end
end

function Player:checkBoundaries()
    if self.y < 0 then
        self.y = 0
    elseif self.y + self.height > love.graphics.getHeight() then
        self.y = love.graphics.getHeight() - self.height
    end
    if self.x < 0 then
        self.x = 0
    elseif self.x + self.width > love.graphics.getWidth() then
        self.x = love.graphics.getWidth() - self.width
    end
end

function Player:draw()
    if self.isRight then
        love.graphics.draw(PlayerSpriteSheet, self.quads[self.spriteNum], self.x, self.y, 0, self.scale, self.scale)
    else
        love.graphics.draw(PlayerSpriteSheet, self.quads[self.spriteNum], self.x + self.width, self.y, 0, -self.scale, self.scale)
    end
end