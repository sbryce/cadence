require 'class'
vector = require 'hump.vector'
Timer = require 'hump.timer'
require 'Player'
require 'NoteGroup'

game = {}

function game:enter()
  player = Player(vector(400, 300))
  noteGroup = NoteGroup("fifths", 120, player)
end

function game:update(dt)
  player:update(dt)
  noteGroup:update(dt)
  Timer.update(dt)
end

function game:draw()
  player:draw()
  noteGroup:draw()
end
