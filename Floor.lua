require 'class'
require 'Obstacle'

Floor = newclass("Floor")

function Floor:init(player)
  --self.obst = Obstacle(player)
  self.player = player
end

function Floor:update(dt)
  --self.obst:update(dt)
end

function Floor:draw()
  --love.graphics.setColor(38, 61, 4)
  --love.graphics.rectangle("fill", 0, 310, 1000, 800)
  for i = 1, 4 do
    love.graphics.setColor(137 - (i + 1) * 10, 118 - (i + 1) * 10, 184 - (i + 1) * 10)
    love.graphics.rectangle("fill", 0, 310 + (i - 1) * 100, 1000, 100)
  end
end
