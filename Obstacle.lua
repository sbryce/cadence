require 'class'

Obstacle = newclass("Obstacle")

function Obstacle:init()
  self.height = 10
  self.width = 10
  self.pos = vector(500, 310 - self.height)
end

function Obstacle:draw()
  love.graphics.rectangle("fill", self.pos.x, self.pos.y, self.width, self.height)
end
