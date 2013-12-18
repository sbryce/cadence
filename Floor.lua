require 'class'
require 'Obstacle'

Floor = newclass("Floor")

function Floor:init()
  self.obst = Obstacle()
end

function Floor:draw()
  love.graphics.setColor(20, 20, 20)
  love.graphics.rectangle("fill", 0, 310, 1000, 800)
  self.obst:draw()
end
