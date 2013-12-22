require 'class'

Sky = newclass("Sky")

function Sky:init()

end

function Sky:draw()
  love.graphics.setColor(207, 230, 230)
  love.graphics.rectangle("fill", 0, 0, 1000, 100)
  love.graphics.setColor(177, 230, 230)
  love.graphics.rectangle("fill", 0, 100, 1000, 100)
  love.graphics.setColor(147, 230, 230)
  love.graphics.rectangle("fill", 0, 200, 1000, 100)
  love.graphics.setColor(117, 230, 230)
  love.graphics.rectangle("fill", 0, 300, 1000, 100)
end
