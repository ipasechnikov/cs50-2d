---@diagnostic disable: duplicate-set-field

local lldebugger
if arg[2] == 'debug' then
  lldebugger = require('lldebugger')
  lldebugger.start()
end



local push = require('lib.push')


WINDOW_WIDTH   = 1280
WINDOW_HEIGHT  = 720

VIRTUAL_WIDTH  = 432
VIRTUAL_HEIGHT = 243


function love.load()
  love.graphics.setDefaultFilter('nearest', 'nearest')
  love.window.setTitle('1-flappy-bird')

  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
    resizable = true,
    vsync = true,
    fullscreen = false,
  })

  push:setupScreen(
    VIRTUAL_WIDTH, VIRTUAL_HEIGHT,
    WINDOW_WIDTH, WINDOW_HEIGHT,
    { resizable = true, fullscreen = false }
  )
end

function love.update(dt)
end

function love.draw()
  push:start()

  push:finish()
end

function love.resize(w, h)
  push:resize(w, h)
end

local love_errorhandler = love.errorhandler
function love.errorhandler(msg)
  if lldebugger then
    error(msg, 2)
  else
    return love_errorhandler(msg)
  end
end
