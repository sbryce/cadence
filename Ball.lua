require 'class'
vector = require 'hump.vector'
require 'gameOver'

Ball = newclass("Ball")

function Ball:init(player, pos, noteSpecs)
  self.player = player
  self.pos = pos
  self.vel = noteSpecs.speed
  self.active = true
  self.prevPos = pos
  self.collisionTime = collisionTime
  self.beat = noteSpecs.beat
  self.radius = noteSpecs.radius
  self.willHit = false
end

function Ball:update(dt)
  local dir = self.player.pos - self.pos
  dir:normalize_inplace()
  self.pos = self.pos + self.vel * dir * dt
  local distFromCenter = math.abs(self.player.pos:dist(self.pos))
  local prevDistFromCenter = math.abs(self.player.pos:dist(self.prevPos))
  if prevDistFromCenter > self.player.shieldRadius and distFromCenter < self.player.shieldRadius then
    if self.player:isBlocked(self.pos) then
      self.active = false
      --self.player.radius = self.player.shieldRadius * 0.8 * (self.beat / 16)
    else
      self.willHit = true
    end
  end
  if distFromCenter < self.player.radius then
    Gamestate.switch(gameOver)
  end
  self.prevPos = self.pos
end

function Ball:draw()
  love.graphics.setColor(71, 71, 82)
  love.graphics.circle("fill", self.pos.x, self.pos.y, self.radius, 20)
end
