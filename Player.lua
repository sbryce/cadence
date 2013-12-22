require 'class'
vector = require 'hump.vector'
GameState = require 'hump.gamestate'
Timer = require 'hump.timer'
require 'CollisionEffect'

Player = newclass("Player")

function Player:init(pos)
  self.pos = pos
  self.ballPos = pos:clone()
  self.startAngle = 1
  self.shieldRadius = 80
  self.radius = 4
  self.angle = 0.35 * math.pi
  self.angularVelocity = 8
  self.targetAngle = self.angle
  self.wasHit = false
  self.dy = 0
  self.ddy = 0
  self.wasSpaceDown = false
  self.health = 4
  self.origColor = {208, 165, 195}
  self.shieldColor = self.origColor
  self.ballColor = self.origColor
  self.shieldDrawRadius = self.shieldRadius
end

function pulse(obj, attr, delta, uptime, downtime)
  if math.floor(game.globalBeat) > math.floor(game.prevGlobalBeat) then
    Timer.tween(uptime, obj, {[attr] = obj[attr] + delta}, 'linear', function() pulseDown(obj, attr, delta, downtime) end)
  end
end

function pulseDown(obj, attr, delta, downtime)
  Timer.tween(downtime, obj, {[attr] = obj[attr] - delta}, 'bounce')
end

function Player:takeDamage()
  self.health = self.health - 1
  if self.health == 0 then
    GameState.switch(gameOver)
  end
  self.shieldColor = {255, 255, 255}
  self.ballColor = {255, 255, 255}
  Timer.add(0.2, function() self:resetColors() end)
end

function Player:blockBall()
  
end

function Player:resetColors()
  self.shieldColor = self.origColor
  self.ballColor = self.origColor
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
    self.ddy = 3000
  end

  if love.keyboard.isDown(" ") then
    if self.ballPos.y >= 300 and not self.wasSpaceDown then
      self.dy = -500
      table.insert(game.effects, CollisionEffect(vector(self.ballPos.x, 300)))
    end
    self.wasSpaceDown = true
  else
    self.wasSpaceDown = false
  end

  pulse(self, "radius", 2, 0.02, 0.4)
  pulse(self, "shieldDrawRadius", 10, 0.02, 0.4)

  -- Kinematics
  self.dy = self.dy + self.ddy * dt
  self.ballPos.y = self.ballPos.y + self.dy * dt
end

function Player:draw()
  self:drawShield()
  for i = 0, self.health do
    local col = {math.max(self.ballColor[1] - 20 * (i)), math.max(0, self.ballColor[2] - 20 * (i)), math.max(0, self.ballColor[3] - 20 * (i))}
    --print(col[1], col[2], col[3])
    love.graphics.setColor(col)
    love.graphics.circle("fill", self.pos.x, self.ballPos.y, self.radius * (self.health - i), 50)
  end
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

function Player:drawShield()
  love.graphics.setColor(self.shieldColor)
  love.graphics.setLine(7, "smooth")
  local res = 10
  for i = 0, res - 1 do
    local vec1 = vector(self.shieldDrawRadius, 0):rotated(self.startAngle + i * (self.angle / res)) + self.pos
    local vec2 = vector(self.shieldDrawRadius, 0):rotated(self.startAngle + (i + 1) * (self.angle / res)) + self.pos
    love.graphics.line(vec1.x, vec1.y, vec2.x, vec2.y)
  end
end
