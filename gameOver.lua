gameOver = {}


function gameOver:enter()
  love.audio.stop()
end

function gameOver:keyreleased(key)
  if key == ' ' then
   Gamestate.switch(game)
  end
end

function gameOver:draw()
  love.graphics.setBackgroundColor(0, 0, 0)
  love.graphics.setColor(255, 255, 255)
  love.graphics.print("Press space to retry", 10, 10)
end
