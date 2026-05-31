local lldebugger
if arg[2] == 'debug' then
  lldebugger = require('lldebugger')
  lldebugger.start()
end

WINDOW_WIDTH   = 1280
WINDOW_HEIGHT  = 720

VIRTUAL_WIDTH  = 432
VIRTUAL_HEIGHT = 243

PADDLE_WIDTH   = 5
PADDLE_HEIGHT  = 20

BALL_SIZE      = 4

require('Paddle')
require('Ball')
local push = require('push')

function love.load()
  love.graphics.setDefaultFilter('nearest', 'nearest')
  love.window.setTitle('0-pong')

  math.randomseed(os.time())

  smallFont    = love.graphics.newFont('font.ttf', 8)
  largeFont    = love.graphics.newFont('font.ttf', 32)

  player1      = Paddle(5, 10, PADDLE_WIDTH, PADDLE_HEIGHT)
  player2      = Paddle(
    VIRTUAL_WIDTH - PADDLE_WIDTH - 5,
    VIRTUAL_HEIGHT - PADDLE_HEIGHT - 10,
    PADDLE_WIDTH,
    PADDLE_HEIGHT
  )

  ball         = Ball(
    VIRTUAL_WIDTH / 2 - BALL_SIZE / 2,
    VIRTUAL_HEIGHT / 2 - BALL_SIZE / 2,
    BALL_SIZE,
    BALL_SIZE
  )

  player1Score = 0
  player2Score = 0

  gameState    = 'start'

  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
    resizable = false,
    vsync = true,
    fullscreen = false,
  })

  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT)
end

function love.keypressed(key)
  if key == 'escape' then
    love.event.quit()
  elseif key == 'enter' or key == 'return' then
    if gameState == 'start' then
      gameState = 'play'
    else
      gameState = 'start'
      ball:reset()
    end
  end
end

function love.update(dt)
  if gameState == 'play' then
    if ball:collides(player1) then
      ball.dx = -ball.dx * 1.03
      ball.x = player1.x + player1.width

      if ball.dy < 0 then
        ball.dy = -math.random(10, 150)
      else
        ball.dy = math.random(10, 150)
      end
    elseif ball:collides(player2) then
      ball.dx = -ball.dx * 1.03
      ball.x = player2.x

      if ball.dy < 0 then
        ball.dy = -math.random(10, 150)
      else
        ball.dy = math.random(10, 150)
      end
    end
  end

  if love.keyboard.isDown('w') then
    player1:moveUp(dt)
  elseif love.keyboard.isDown('s') then
    player1:moveDown(dt)
  end

  if love.keyboard.isDown('up') then
    player2:moveUp(dt)
  elseif love.keyboard.isDown('down') then
    player2:moveDown(dt)
  end

  if gameState == 'play' then
    ball:update(dt)
  end
end

function love.draw()
  push:start()
  love.graphics.clear(40 / 255, 45 / 255, 52 / 255, 1)

  love.graphics.setFont(largeFont)
  love.graphics.print(
    player1.score,
    VIRTUAL_WIDTH / 2 - 50,
    VIRTUAL_HEIGHT / 2 - 40
  )
  love.graphics.print(
    player2.score,
    VIRTUAL_WIDTH / 2 + 50 - largeFont:getWidth(player2Score),
    VIRTUAL_HEIGHT / 2 - 40
  )

  love.graphics.setFont(smallFont)
  local gameStateStr = "Hello '" .. gameState .. "' state"
  love.graphics.printf(gameStateStr, 0, VIRTUAL_HEIGHT / 2 - 80, VIRTUAL_WIDTH, 'center')

  player1:render()
  player2:render()
  ball:render()

  displayFPS()

  push:finish()
end

function displayFPS()
  love.graphics.setFont(smallFont)
  love.graphics.setColor(0, 255 / 255, 0, 255 / 255)
  love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
  love.graphics.setColor(1, 1, 1, 1)
end

local love_errorhandler = love.errorhandler
function love.errorhandler(msg)
  if lldebugger then
    error(msg, 2)
  else
    return love_errorhandler(msg)
  end
end
