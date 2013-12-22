require 'class'
Timer = require 'hump.timer'

CollisionEffect = newclass("CollisionEffect")

function CollisionEffect:init(pos)
  self.radius = 5
  self.color = {255, 255, 255, 150}
  self.pos = pos
  Timer.tween(0.3, self, {color = {255, 255, 255, 0}, radius = 80})
end

function CollisionEffect:update(dt)

end

function CollisionEffect:draw()
  love.graphics.setColor(self.color)
  love.graphics.circle("fill", self.pos.x, self.pos.y, self.radius, 20)
end
