require 'class'
require 'collision'
require 'gameOver'

Obstacle = newclass("Obstacle")

function Obstacle:init(x, width, vel, player)
  self.height = 20
  self.width = width
  self.pos = vector(x, 310 - self.height)
  self.vel = -vel
  self.player = player
end

function Obstacle:update(dt)
  self.pos.x = self.pos.x + self.vel * dt
  if circleRecCollision(self.player.ballPos, self.player.radius, self.pos, self.width, self.height) then
    love.audio.stop()
    Gamestate.switch(gameOver)
  end
end

function Obstacle:draw()
  love.graphics.rectangle("fill", self.pos.x, self.pos.y, self.width, self.height)
end
