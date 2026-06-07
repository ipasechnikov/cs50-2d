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

  smallFont     = love.graphics.newFont('font.ttf', 8)
  largeFont     = love.graphics.newFont('font.ttf', 32)

  player1       = Paddle(5, 10, PADDLE_WIDTH, PADDLE_HEIGHT)
  player2       = Paddle(
    VIRTUAL_WIDTH - PADDLE_WIDTH - 5,
    VIRTUAL_HEIGHT - PADDLE_HEIGHT - 10,
    PADDLE_WIDTH,
    PADDLE_HEIGHT
  )

  ball          = Ball(
    VIRTUAL_WIDTH / 2 - BALL_SIZE / 2,
    VIRTUAL_HEIGHT / 2 - BALL_SIZE / 2,
    BALL_SIZE,
    BALL_SIZE
  )

  player1Score  = 0
  player2Score  = 0
  servingPlayer = math.random(1, 2)

  gameState     = 'start'

  sounds        = {
    ['paddle_hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
    ['wall_hit']   = love.audio.newSource('sounds/wall_hit.wav', 'static'),
    ['score']      = love.audio.newSource('sounds/score.wav', 'static')
  }

  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
    resizable = true,
    vsync = true,
    fullscreen = false,
  })

  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, { resizable = true, fullscreen = false })
end

function love.keypressed(key)
  if key == 'escape' then
    love.event.quit()
  elseif key == 'enter' or key == 'return' then
    if gameState == 'start' then
      gameState = 'serve'
    elseif gameState == 'serve' then
      if servingPlayer == 1 then
        ball.dx = 100
      elseif servingPlayer == 2 then
        ball.dx = -100
      end
      gameState = 'play'
    elseif gameState == 'done' then
      gameState = 'serve'

      ball:reset()

      player1Score = 0
      player2Score = 0

      if winningPlayer == 1 then
        servingPlayer = 2
      else
        servingPlayer = 1
      end
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

      sounds['paddle_hit']:play()
    elseif ball:collides(player2) then
      ball.dx = -ball.dx * 1.03
      ball.x = player2.x - ball.width

      if ball.dy < 0 then
        ball.dy = -math.random(10, 150)
      else
        ball.dy = math.random(10, 150)
      end

      sounds['paddle_hit']:play()
    end

    if ball.y <= 0 then
      ball.y = 0
      ball.dy = -ball.dy
      sounds['wall_hit']:play()
    end

    if ball.y >= VIRTUAL_HEIGHT - ball.height then
      ball.y = VIRTUAL_HEIGHT - ball.height
      ball.dy = -ball.dy
      sounds['wall_hit']:play()
    end

    if ball.x < 0 then
      servingPlayer = 1
      player2Score = player2Score + 1
      sounds['score']:play()

      if player2Score == 10 then
        winningPlayer = 2
        gameState = 'done'
      else
        ball:reset()
        gameState = 'serve'
      end
    elseif ball.x > VIRTUAL_WIDTH then
      servingPlayer = 2
      player1Score = player1Score + 1
      sounds['score']:play()

      if player1Score == 10 then
        winningPlayer = 1
        gameState = 'done'
      else
        ball:reset()
        gameState = 'serve'
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
    player1Score,
    VIRTUAL_WIDTH / 2 - 50,
    VIRTUAL_HEIGHT / 2 - 40
  )
  love.graphics.print(
    player2Score,
    VIRTUAL_WIDTH / 2 + 50 - largeFont:getWidth(player2Score),
    VIRTUAL_HEIGHT / 2 - 40
  )

  if gameState == 'start' then
    love.graphics.setFont(smallFont)
    love.graphics.printf('Welcome to Pong!', 0, 10, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Press Enter to begin!', 0, 20, VIRTUAL_WIDTH, 'center')
  elseif gameState == 'serve' then
    love.graphics.setFont(smallFont)
    love.graphics.printf('Player ' .. tostring(servingPlayer) .. "'s serve!", 0, 10, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Press Enter to serve!', 0, 20, VIRTUAL_WIDTH, 'center')
  elseif gameState == 'play' then
  elseif gameState == 'done' then
    love.graphics.setFont(largeFont)
    love.graphics.printf('Player ' .. tostring(winningPlayer) .. ' wins!', 0, 10, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(smallFont)
    love.graphics.printf('Press Enter to restart!', 0, largeFont:getHeight() + 20, VIRTUAL_WIDTH, 'center')
  end

  player1:render()
  player2:render()
  ball:render()

  displayFPS()

  push:finish()
end

function love.resize(w, h)
  push:resize(w, h)
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
