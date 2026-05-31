require('class')

Paddle = class()

function Paddle:init(x, y, width, height)
  self.x = x
  self.y = y
  self.width = width
  self.height = height
  self.speed = 200
  self.score = 0
end

function Paddle:update(dt)
end

function Paddle:render()
  love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end

function Paddle:moveUp(dt)
  local newY = self.y - self.speed * dt
  self.y = math.max(0, newY)
end

function Paddle:moveDown(dt)
  local newY = self.y + self.speed * dt
  self.y = math.min(VIRTUAL_HEIGHT - self.height, newY)
end

function Paddle:incScore()
  self.score = self.score + 1
end
