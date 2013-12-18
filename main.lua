Gamestate = require 'hump.gamestate'
require 'game'

local menu = {}

function love:load()
  Gamestate.push(menu)
  Gamestate.registerEvents()
end

function menu:draw()
  love.graphics.setBackgroundColor(0, 0, 0)
  love.graphics.setColor(255, 255, 255)
  love.graphics.print("Press space to continue", 10, 10)
end

function menu:keyreleased(key)
  if key == ' ' then
      Gamestate.switch(game)
  end
end
