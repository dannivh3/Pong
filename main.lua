WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200


push = require 'push'
function love.load()
    math.randomseed(os.time())
    love.graphics.setDefaultFilter('nearest', 'nearest')
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT,WINDOW_WIDTH,WINDOW_HEIGHT,{
        fullscreen = false,
        vsync = true,
        resizable = false
    })
    basicFont = love.graphics.newFont('basic-font.ttf', 16)
    scoreFont = love.graphics.newFont('basic-font.ttf', 32)

    p1Score = 0
    p2Score = 0

    p1Y = VIRTUAL_HEIGHT / 2 - 10
    p2Y = VIRTUAL_HEIGHT / 2 - 10

    

    gamestate = 'serve'

end

function love.update(dt)
    if love.keyboard.isDown('w') then
        p1Y = math.max(0, p1Y + (-PADDLE_SPEED * dt))
    elseif love.keyboard.isDown('s') then
        p1Y = math.min(VIRTUAL_HEIGHT - 20, p1Y + (PADDLE_SPEED * dt))
    end

    if love.keyboard.isDown('up') then
        p2Y = math.max(0, p2Y + (-PADDLE_SPEED * dt))
    elseif love.keyboard.isDown('down') then
        p2Y = math.min(VIRTUAL_HEIGHT - 20, p2Y + (PADDLE_SPEED * dt))
    end

    if gamestate == 'serve' then
        ballX = VIRTUAL_WIDTH / 2 - 2
        ballY = VIRTUAL_HEIGHT / 2 - 2

        ballDX = math.random(2) == 1 and 100 or -100
        ballDY = math.random(-50, 50)
    end
    if gamestate == 'play' then
        ballX = ballX + ballDX * dt
        ballY = ballY + ballDY * dt
    end
end

function love.keypressed(key) 
    if key == 'escape' then
        love.event.quit()
    end
    if key == 'enter' or key == 'return' then
        if gamestate == 'serve' then
            gamestate = 'play'

        elseif gamestate == 'play' then
            gamestate = 'serve'
        end
    end

end

function love.draw()
    push:apply('start')

    love.graphics.clear(51/255, 0/255, 102/255, 1)

    love.graphics.rectangle('fill', ballX, ballY, 4, 4)

    love.graphics.rectangle('fill', 5, p1Y, 5, 20)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH-10, p2Y, 5, 20)

    love.graphics.setFont(basicFont)
    love.graphics.printf("Hello Pong!", 0, 20, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(scoreFont)
    love.graphics.print(p1Score, VIRTUAL_WIDTH / 2 - 60, VIRTUAL_HEIGHT / 3)
    love.graphics.print(p2Score, VIRTUAL_WIDTH / 2 + 40, VIRTUAL_HEIGHT / 3)

    push:apply('end')
end