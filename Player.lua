require 'class'
vector = require 'hump.vector'

Player = newclass("Player")

function Player:init(pos)
  self.pos = pos
  self.ballPos = pos:clone()
  self.startAngle = 1
  self.shieldRadius = 50
  self.radius = 10
  self.angle = 0.35 * math.pi
  self.angularVelocity = 8
  self.targetAngle = self.angle
  self.wasHit = false
  self.dy = 0
  self.ddy = 1
  self.wasSpaceDown = false
end

function Player:update(dt)
  -- Handle input
  if love.keyboard.isDown("right") then
    self.startAngle = (self.startAngle + self.angularVelocity * dt) % (2 * math.pi)
  end
  if love.keyboard.isDown("left") then
    self.startAngle = (self.startAngle - self.angularVelocity * dt) % (2 * math.pi)
  end

  -- Lerp shield width
  local shieldMutability = 0.5
  if math.abs(self.targetAngle - self.angle) > 0.1 then
    if self.targetAngle < self.angle then
      self.angle = self.angle - shieldMutability * dt
    else
      self.angle = self.angle + shieldMutability * dt
    end
  end

  if self.ballPos.y > 300 then
    self.ddy = 0
    self.dy = 0
    self.ballPos.y = 300
  else
    self.ddy = 1
  end

  if love.keyboard.isDown(" ") then
    if self.ballPos.y >= 300 and not self.wasSpaceDown then
      self.dy = -8
    end
    self.wasSpaceDown = true
  else
    self.wasSpaceDown = false
  end

  -- Kinematics
  self.dy = self.dy + self.ddy
  self.ballPos.y = self.ballPos.y + self.dy

end

function Player:draw()
  love.graphics.setColor(71, 71, 82)
  love.graphics.arc("fill", self.pos.x, self.pos.y, self.shieldRadius, self.startAngle, self.startAngle + self.angle)
  love.graphics.setColor(91, 91, 82)
  love.graphics.circle("fill", self.pos.x, self.ballPos.y, self.radius, 50)
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

function Player:setShieldWidth(width)
  self.targetAngle = width
end
