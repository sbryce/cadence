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
    self.player:takeDamage()
  end
end

function Obstacle:draw()
  love.graphics.setColor(137, 118, 184)
  --love.graphics.rectangle("fill", self.pos.x, self.pos.y, self.width, self.height)
  love.graphics.triangle("fill", self.pos.x, self.pos.y + self.height, self.pos.x + self.width / 2, self.pos.y, self.pos.x + self.width, self.pos.y + self.height)
end
