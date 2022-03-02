WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200

BALL_SPEED = 100

push = require 'push'
Class = require 'class'

require 'Paddle'
require 'Ball'

function love.load()
    math.randomseed(os.time())
    love.window.setTitle("Pongarama")
    love.graphics.setDefaultFilter('nearest', 'nearest')
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT,WINDOW_WIDTH,WINDOW_HEIGHT,{
        fullscreen = false,
        vsync = true,
        resizable = true
    })
    basicFont = love.graphics.newFont('basic-font.ttf', 16)
    scoreFont = love.graphics.newFont('basic-font.ttf', 32)
    fpsFont = love.graphics.newFont('fps-font.ttf', 8)
   
    p1Score = 0
    p2Score = 0

    player1 = Paddle(5)
    player2 = Paddle(VIRTUAL_WIDTH - 10)
    
    servingPlayer = math.random(2)
    ball = Ball(servingPlayer)

    gamestate = 'start'
    
    love.keyboard.keysPressed = {}

end
function love.resize(w,h)
    push:resize(w,h)
    
end
function love.keypressed(key) 

    love.keyboard.keysPressed[key] = true

    if key == 'escape' then
        love.event.quit()
    end
    if key == 'enter' or key == 'return' then
        if gamestate == 'serve' or gamestate == 'start' then
            gamestate = 'play'
        end
        
    end

end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.update(dt)

    player1:update(dt)
    player2:update(dt)
    
    if ball.x <= -4 then
        p2Score = p2Score + 1
        gamestate = 'serve'
        servingPlayer = 1
    end
    if ball.x >= VIRTUAL_WIDTH then
        p1Score = p1Score + 1
        gamestate = 'serve'
        servingPlayer = 2
    end
    -- checking if ball collides with paddles
    if ball:collides(player1) then
        ball.dx = -(ball.dx - BALL_SPEED) / 2
        ball:bounce(player1)
        ball.x = player1.x + 5
    end
    if ball:collides(player2) then
        ball.dx = -(ball.dx + BALL_SPEED) / 2
        ball:bounce(player2)
        ball.x = player2.x - 4
    end

    -- Making ball bounce of walls
    if ball.y < 0 then
        ball.dy = -ball.dy
        ball.y = 0
    end
    if ball.y > VIRTUAL_HEIGHT - 4 then
        ball.dy = -ball.dy
        ball.y = VIRTUAL_HEIGHT - 4
    end

    -- getting user inputs
    if love.keyboard.isDown('w') then
        player1.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('s') then
        player1.dy = PADDLE_SPEED
    else
        player1.dy = 0
    end
    if love.keyboard.wasPressed('h') then
        player1:superhit(ball)
    end
    
    if love.keyboard.isDown('up') then
        player2.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('down') then
        player2.dy = PADDLE_SPEED
    else
        player2.dy = 0
    end

    -- Simple gamestates
    if gamestate == 'serve' then
        ball:reset(servingPlayer)
    end
    if gamestate == 'play' then
        ball:update(dt)
    end

    love.keyboard.keysPressed = {}
end



function love.draw()
    push:apply('start')

    love.graphics.clear(51/255, 0/255, 102/255, 1)
    love.graphics.setColor(1,1,1,1)
    love.graphics.rectangle('fill',VIRTUAL_WIDTH/2, 0, 1, VIRTUAL_HEIGHT/2-30)
    love.graphics.rectangle('fill',VIRTUAL_WIDTH/2, VIRTUAL_HEIGHT/2+30, 1, VIRTUAL_HEIGHT/2-30)
    love.graphics.circle('line',VIRTUAL_WIDTH/2, VIRTUAL_HEIGHT/2, 30)

    player1:render()
    player2:render()
    ball:render()

    
    love.graphics.setFont(scoreFont)
    love.graphics.print(p1Score, VIRTUAL_WIDTH / 2 - 100, VIRTUAL_HEIGHT / 4)
    love.graphics.print(p2Score, VIRTUAL_WIDTH / 2 + 80, VIRTUAL_HEIGHT / 4)

    love.graphics.setColor(149/255, 252/255, 251/255, 1)
    love.graphics.setFont(basicFont)
    
    if gamestate == 'serve' then
        love.graphics.printf("Press enter to serve!", 0, 20, VIRTUAL_WIDTH + 2, 'center')
        love.graphics.printf('Player ' .. servingPlayer .. 'Turn', 0, 38, VIRTUAL_WIDTH + 2, 'center')
    elseif gamestate == 'start'then
        love.graphics.printf('Welcome to Pongarama', 0, 20, VIRTUAL_WIDTH + 2, 'center')
        love.graphics.printf("Press enter to serve!", 0, 38, VIRTUAL_WIDTH + 2, 'center')
        love.graphics.printf('Player ' .. servingPlayer .. ' Turn', 0, 56, VIRTUAL_WIDTH + 2, 'center')
        
    end
    displayFPS()
    
    

    push:apply('end')
end

function displayFPS()
    love.graphics.setColor(0,1,0,1)
    love.graphics.setFont(fpsFont)
    love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), 40, 10)
end