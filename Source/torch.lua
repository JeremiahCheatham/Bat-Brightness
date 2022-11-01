Torch = {
    x = 0,
    y = 0,
    spriteNum = 0
}

function Torch:new(width, height, scale)
    local newTorch = {}
    newTorch.quads = {}
    for y = 0, TorchSpriteSheet:getHeight() - height, height do
        for x = 0, TorchSpriteSheet:getWidth() - width, width do
            table.insert(newTorch.quads, love.graphics.newQuad(x, y, width, height, TorchSpriteSheet:getDimensions()))
        end
    end
    newTorch.width = width * scale
    newTorch.height = height * scale
    newTorch.scale = scale
    newTorch.xOffset = (MyPlayer.width / 2) - (newTorch.width / 2)
    newTorch.yOffset = (MyPlayer.height / 2) - (newTorch.height / 2)
    setmetatable(newTorch, self)
    self.__index = self
    return newTorch
end

function Torch:update(dt)
    self.spriteNum = 0
    if Power > 0 then
        if love.keyboard.isDown("up") then
            self.spriteNum = 1
        end
        if love.keyboard.isDown("right") then
            self.spriteNum = 2
        end
        if love.keyboard.isDown("down") then
            self.spriteNum = 3
        end
        if love.keyboard.isDown("left") then
            self.spriteNum = 4
        end
    end
    if self.spriteNum ~= 0 then
        Power = Power - 50 * dt
        if Power < 0 then
            Power = 0
        end
        self.x = MyPlayer.x + self.xOffset
        self.y = MyPlayer.y + self.yOffset
        if not Hum:isPlaying( ) then
            Hum:play()
        end
    else
        if Hum:isPlaying( ) then
            Hum:stop()
        end
    end
end

function Torch:draw()
    if self.spriteNum ~= 0 then
        love.graphics.draw(TorchSpriteSheet, self.quads[self.spriteNum], self.x, self.y, 0, self.scale)
    end
end