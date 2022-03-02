Ball = Class{}

function Ball:init(serving)
    self.x = VIRTUAL_WIDTH / 2 - 2
    self.y = VIRTUAL_HEIGHT / 2 - 2

    self.width = 4
    self.height = 4

    self.serving = serving

    self.dx = self.serving == 1 and BALL_SPEED or -BALL_SPEED
    self.dy = math.random(-50,50)
end
function Ball:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end
function Ball:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height )
end
function Ball:reset(serving)
    self.x = VIRTUAL_WIDTH / 2 - 2
    self.y = VIRTUAL_HEIGHT / 2 - 2
    self.dx = serving == 1 and BALL_SPEED or -BALL_SPEED
    self.dy = math.random(-50,50)
end
function Ball:collides(target)
    if self.x > target.x + target.width or self.x + self.width < target.x then
        return false
    end
    if self.y > target.y + target.height or self.y + self.height < target.y then
        return false
    end
    return true
end

-- this formula changes the dy acording to where the ball hit the paddle
function Ball:bounce(target)
    local targetMiddle = (target.y + target.height) - (target.height / 2)
    self.dy = self.dy + ((self.y - targetMiddle) * 4 + (target.dy * 0.5)) 
end