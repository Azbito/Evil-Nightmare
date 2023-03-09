function shootFire()
  fireBall = {}

  fireBall.x = player.x
  fireBall.y = player.y
  fireBall.speed = 500
  fireBall.dead = false
  fireBall.direction = fireBall.y
  table.insert(fireBalls, fireBall)
end


function fireUpdate(dt)
  fx, fy = fireBall:getPosition()
  fireBall:setX(fx + fireBall.speed * dt)
end

function fireDraw()
  for i,f in ipairs(fireBall) do
    love.graphics.draw(sprites.fireBall, f.x, f.y, nil, .5, nil, sprites.fireBall:getWidth()/2, sprites.fireBall:getHeight()/2)  
  end
end

function attack()
  if love.keyboard.isDown('l') or love.keyboard.isDown('c') then
     shootFire()
  end
end
