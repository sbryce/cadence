require 'class'
require 'collision'
require 'gameOver'

Obstacle = newclass("Obstacle")

function Obstacle:init(player)
  self.height = 20
  self.width = 20
  self.pos = vector(1000, 310 - self.height)
  self.vel = -4
  self.player = player
end

function Obstacle:update()
  self.pos.x = self.pos.x + self.vel
  if circleRecCollision(self.player.ballPos, self.player.radius, self.pos, self.width, self.height) then
    Gamestate.switch(gameOver)
  end
end

function Obstacle:draw()
  love.graphics.rectangle("fill", self.pos.x, self.pos.y, self.width, self.height)
end
