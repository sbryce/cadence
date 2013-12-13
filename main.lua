require 'class'
vector = require 'hump.vector'
Timer = require 'hump.timer'
require 'player'
require 'noteGroup'

function love.load()
  player = Player(vector(400, 300))
  noteGroup = NoteGroup("fifths", 120, player)
end

function love.update(dt)
  player:update(dt)
  noteGroup:update(dt)
  Timer.update(dt)
end

function love.draw()
  player:draw()
  noteGroup:draw()
end
