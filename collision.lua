function circleRecCollision(center, radius, pos, width, height)
  if center.x > pos.x and center.x < pos.x + width and center.y < pos.y + height and center.y > pos.y then
    return true
  else
    return false
  end
end
