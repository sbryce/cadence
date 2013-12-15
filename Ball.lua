require 'class'
vector = require 'hump.vector'

Ball = newclass("Ball")

function Ball:init(player, pos, vel, beat, radius)
  self.player = player
  self.pos = pos
  self.vel = vel
  self.active = true
  self.prevPos = pos
  self.collisionTime = collisionTime
  self.beat = beat
  self.radius = radius
  self.willHit = false
end

function Ball:update(dt)
  local dir = self.player.pos - self.pos
  dir:normalize_inplace()
  self.pos = self.pos + self.vel * dir * dt
  local distFromCenter = math.abs(self.player.pos:dist(self.pos))
  local prevDistFromCenter = math.abs(self.player.pos:dist(self.prevPos))
  if prevDistFromCenter > self.player.radius and distFromCenter < self.player.radius then
    if self.player:isBlocked(self.pos) then
      self.active = false
    else
      self.willHit = true
    end
  end
  self.prevPos = self.pos
end

function Ball:draw()
  love.graphics.setColor(71, 71, 82)
  love.graphics.circle("fill", self.pos.x, self.pos.y, self.radius, 20)
end
