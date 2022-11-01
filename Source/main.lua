require("player")
require("bat")
require("battery")
require("leaf")
require("torch")

function love.load()
    -- Game variables.
    Score = 0
    Power = 50
    Running = false
    GameOver = false

    -- Seed random numbers.
    math.randomseed(os.time())

    -- Game Font Sizes.
    PowerFont = love.graphics.newFont(24)
    ScoreFont = love.graphics.newFont(35)
    GameFont = love.graphics.newFont(120)

    -- Load Game Sounds.
    Pickup = love.audio.newSource("assets/pickup.ogg", "static")
    Over = love.audio.newSource("assets/gameover.ogg", "static")
    Hum = love.audio.newSource("assets/hum.ogg", "static")
    Hum:setLooping(true)
    Music = love.audio.newSource("assets/music.ogg", "stream")
    Music:setLooping(true)
    Music:play()

    -- Load Game Graphics.
    love.graphics.setDefaultFilter("nearest", "nearest")
    BatterySpriteSheet = love.graphics.newImage("assets/battery.png")
    BatSpriteSheet = love.graphics.newImage("assets/bat.png")
    LeafSpriteSheet = love.graphics.newImage("assets/leaves.png")
    PlayerSpriteSheet = love.graphics.newImage("assets/player.png")
    Background = love.graphics.newImage("assets/background.png")
    TorchSpriteSheet = love.graphics.newImage("assets/torch.png")

    -- Instantiate Game objects.
    MyPlayer = Player:new(12, 16, 10, 0.4)
    MyTorch = Torch:new(64, 64, 7)
    MyBattery = Battery:new(12, 16, 4)
    MyBattery:reset()

    Bats = {}
    for _=1, 5 do
        local bat = Bat:new(19, 14, 5, 0.4)
        bat:reset()
        table.insert(Bats, bat)
    end

    Leaves = {}
    for _=1, 20 do
        local leaf = Leaf:new(14, 13, 2, 100)
        table.insert(Leaves, leaf)
    end
end

function love.update(dt)
    if Running then
        MyPlayer:update(dt)
        MyTorch:update(dt)
        for _, bat in pairs(Bats) do
            bat:update(dt)
        end
        MyBattery:update()
        for _, leaf in pairs(Leaves) do
            leaf:update(dt)
        end
        Score = Score + dt
    elseif love.keyboard.isDown("space") then
        Running = true
        Score = 0
        Power = 50
        MyPlayer.x = (love.graphics.getWidth() - MyPlayer.width) / 2
        MyPlayer.y = (love.graphics.getHeight() - MyPlayer.height) / 2
        MyBattery:reset()
        for _, bat in pairs(Bats) do
            bat:reset()
        end
        Music:play()
    end
end

function love.keypressed(k)
    if k == 'escape' then
       love.event.quit()
    end
 end

function love.draw()
    love.graphics.draw(Background, 0, 0, 0, 5)
    MyBattery:draw()
    MyPlayer:draw()
    for _, bat in pairs(Bats) do
        bat:draw()
    end
    MyTorch:draw()
    for _, leaf in pairs(Leaves) do
        leaf:draw()
    end
    love.graphics.setFont(ScoreFont)
    love.graphics.print("Score: " .. math.floor(Score), love.graphics.getWidth() -220, 10)
    love.graphics.setColor(0, 0, 0, 1.0)
    love.graphics.rectangle("fill", 20, 20, 200, 30)
    if Power > 66 then
        love.graphics.setColor(0, 1.0, 0, 1.0)
    elseif Power > 33 then
        love.graphics.setColor(1.0, 1.0, 0, 1.0)
    else
        love.graphics.setColor(1.0, 0, 0, 1.0)
    end
    love.graphics.rectangle("fill", 20, 20, Power * 2, 30)
    love.graphics.setColor(1.0, 1.0, 1.0, 1.0)
    love.graphics.rectangle("line", 20, 20, 200, 30)
    love.graphics.setFont(PowerFont)
    love.graphics.print(math.floor(Power) .. "%", 107, 21)
    love.graphics.setFont(GameFont)
    if not Running then
        love.graphics.printf("PrEsS sPaCe", 0, 400, love.graphics.getWidth(), "center")
        if GameOver then
            love.graphics.printf("GaMe OvEr!", 0, 200, love.graphics.getWidth(), "center")
        else
            love.graphics.printf("B.A.T. Brightness", 0, 200, love.graphics.getWidth(), "center")
        end
    end
end

function CheckCollision(a, b)
    if a.x + a.width > b.x and a.x < b.x + b.width and a.y + a.height > b.y and a.y < b.y + b.height then
        return true
    else
        return false
    end
end

function PlayerCollision(a, b)
    if a.x + a.width > b.x + 40 and a.x < b.x + b.width - 40 and a.y + a.height > b.y + 20 and a.y < b.y + b.height - 20 then
        return true
    else
        return false
    end
end