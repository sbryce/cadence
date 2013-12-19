require 'class'
require 'Obstacle'

Floor = newclass("Floor")

function Floor:init(player)
  self.obst = Obstacle(player)
  self.player = player
end

function Floor:update(dt)
  self.obst:update(dt)
end

function Floor:draw()
  love.graphics.setColor(20, 20, 20)
  love.graphics.rectangle("fill", 0, 310, 1000, 800)
  self.obst:draw()
end
