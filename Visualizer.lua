require 'class'
require 'Player'

Visualizer = newclass("Visualizer")

function Visualizer:init(top, opacity, speed, width)
  self.x = 0
  self.width = width
  self.height = 400
  self.pulseDelta = 20
  self.top = top
  self.opacity = opacity
  self.seed = math.random(1, 200)
  self.speed = speed
  self.offset = 0
end

function Visualizer:update(dt)
  pulse(self, "height", self.pulseDelta, 0.02, 0.4)
  self.offset = self.offset - self.speed * dt
end

function Visualizer:draw()
  math.randomseed(self.seed)
  for i = 0, 40 do
    love.graphics.setColor(236 + math.random(-5, 5), 216 + math.random(-5, 5), 217 + math.random(-5, 5), self.opacity)
    love.graphics.rectangle("fill", self.x + i * self.width + (self.offset % (20 * self.width)), self.top - self.height + math.random(100), self.width, self.height)
    love.graphics.rectangle("fill", self.x + i * self.width + (self.offset % (20 * self.width)) - (20 * self.width), self.top - self.height + math.random(100), self.width, self.height)
  end
end
