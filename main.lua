require 'class'
vector = require 'hump.vector'
Timer = require 'hump.timer'
require 'player'
require 'noteWrangler'

function love.load()
  player = Player(vector(400, 300))
  noteWrangler = NoteWrangler(player)
end

function love.update(dt)
  player:update(dt)
  noteWrangler:update(dt)
  Timer.update(dt)
end

function love.draw()
  player:draw()
  noteWrangler:draw()
end
