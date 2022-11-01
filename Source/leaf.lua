Leaf = {
    x = 0,
    y = 0,
    speed = 0,
    rotSpeed = 0,
    angle = 0
}

function Leaf:new(width, height, scale, speed)
    local newLeaf = {}
    newLeaf.quads = {}
    for y = 0, LeafSpriteSheet:getHeight() - height, height do
        for x = 0, LeafSpriteSheet:getWidth() - width, width do
            table.insert(newLeaf.quads, love.graphics.newQuad(x, y, width, height, LeafSpriteSheet:getDimensions()))
        end
    end
    newLeaf.width = width * scale
    newLeaf.height = height * scale
    newLeaf.scale = scale
    newLeaf.speed = speed
    newLeaf.rotSpeed = math.random(1, 4)
    newLeaf.spriteNum = math.random(1, 3)
    newLeaf.angle = math.random(1, 100) / 50
    newLeaf.x = math.random(0, (love.graphics.getWidth() - newLeaf.width))
    newLeaf.y = math.random(0, (love.graphics.getHeight() - newLeaf.height))
    setmetatable(newLeaf, self)
    self.__index = self
    return newLeaf
end

function Leaf:update(dt)
    self.x = self.x + self.speed * dt
    self.angle = self.angle + self.rotSpeed * dt
    self:checkBoundaries()
end


function Leaf:checkBoundaries()
    if self.x > love.graphics.getWidth() then
        self.x = -self.width
    end
end

function Leaf:draw()
    -- love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    love.graphics.draw(LeafSpriteSheet, self.quads[self.spriteNum], self.x, self.y, self.angle, self.scale, self.scale)
end