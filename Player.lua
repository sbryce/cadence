require 'class'
vector = require 'hump.vector'

Player = newclass("Player")

function Player:init(pos)
  self.pos = pos
  self.startAngle = 1
  self.radius = 50
  self.angle = 0.35 * math.pi
  self.angularVelocity = 8
end

function Player:update(dt)
  if love.keyboard.isDown("right") then
    self.startAngle = (self.startAngle + self.angularVelocity * dt) % (2 * math.pi)
  end
  if love.keyboard.isDown("left") then
    self.startAngle = (self.startAngle - self.angularVelocity * dt) % (2 * math.pi)
  end
end

function Player:draw()
  love.graphics.setColor(71, 71, 82)
  love.graphics.arc("line", self.pos.x, self.pos.y, self.radius, self.startAngle, self.startAngle + self.angle)
end

function Player:isBlocked(vec)
    local centerToPoint = vec - self.pos
    centerToPoint:normalize_inplace()
    local vecAngle
    if centerToPoint:cross(vector(1, 0)) > 0 then
      vecAngle = 2 * math.pi - math.acos(centerToPoint * vector(1, 0))
    else
      vecAngle = math.acos(centerToPoint * vector(1, 0))
    end
    --Handle the case where the shield is straddling the 0/2pi rotation line 
    if self.startAngle + self.angle > 2 * math.pi then
      if vecAngle > self.startAngle or vecAngle < self.startAngle + self.angle - (2 * math.pi) then
        return true
      end
    end
    if vecAngle > self.startAngle and vecAngle < self.startAngle + self.angle then
      return true
    end
  return false
end
