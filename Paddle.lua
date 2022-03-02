

Paddle = Class{}

function Paddle:init(x)
    self.x = x
    self.y = VIRTUAL_HEIGHT / 2 - 10
    self.width = 5
    self.height = 30

    self.dy = 0
end

function Paddle:update(dt)
    if self.dy < 0 then
        self.y = math.max(0, self.y + self.dy * dt)
    elseif self.dy > 0 then
        self.y = math.min(VIRTUAL_HEIGHT - self.height, self.y + self.dy * dt)
    end


end

function Paddle:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end

function Paddle:superhit(ball)
    
    local ballPosX = ball.x + ball.width
    local ballPosY = ball.y + ball.height

    local paddlePosX = self.x + self.width
    local paddlePosY = self.y + self.height
    --ballPosX = 30, ballPosY = 200
    if ballPosX < paddlePosX + 20 and ballPosY < paddlePosY and ballPosY > self.y then
        ball.dx = ball.dx * 3
    end
end
