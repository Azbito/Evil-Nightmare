player = world:newRectangleCollider(300, 40, 40, 100, {collision_class = "Player"})
player:setFixedRotation(true)
player.speed = 240
player.runningSpeed = 340
player.animation = animations.idle
player.direction = 1
player.grounded = true

function playerUpdate(dt)
  if player.body then
    local colliders = world:queryRectangleArea(player:getX() - 20, player:getY() + 50, 40, 2, {'Platform'})

    if #colliders > 0 then
      player.grounded = true
      player.animation = animations.idle
    else 
      player.grounded = false
      player.animation = animations.jump
    end

    local collidersJTP = world:queryRectangleArea(player:getX() - 10, player:getY() + 50, 40, 2, {'PlatformJT'})

    if #collidersJTP > 0 then
      player.grounded = true
      player.animation = animations.idle
    end

    player.isJumping = false  
    player.isWalking = false
    player.isRunning = false
    player.isAttacking = false
    player.isMoving = false

    px, py = player:getPosition()

    if love.keyboard.isDown('right') or love.keyboard.isDown('d') then
      player:setX(px + player.speed*dt)
      player.isWalking = true
      player.direction = 1
    end
    if love.keyboard.isDown('left') or love.keyboard.isDown('a') then
      player:setX(px - player.speed*dt)
      player.isWalking = true
      player.direction = -1
    end
    if love.keyboard.isDown('right') and love.keyboard.isDown('x') then
      player:setX(px + player.runningSpeed*dt)
      player.isRunning = true
      player.direction = 1
    end
    if love.keyboard.isDown('left') and love.keyboard.isDown('x') then
      player:setX(px - player.runningSpeed*dt)
      player.isRunning = true
      player.direction = -1
    end
    if love.keyboard.isDown('d') and love.keyboard.isDown('j') then
      player:setX(px + player.runningSpeed*dt)
      player.isRunning = true
      player.direction = 1
    end
    if love.keyboard.isDown('a') and love.keyboard.isDown('j') then
      player:setX(px - player.runningSpeed*dt)
      player.isRunning = true
      player.direction = -1
    end
    if love.keyboard.isDown('k') and cooldown == 0 then
      player.isAttacking = true
      cooldown = 2
    end
  end

  if player.grounded then
    player.animation = animations.idle
    if player.isWalking then
    player.animation = animations.walk
    end
    if player.isRunning then
    player.animation = animations.run
    end
    if player.isAttacking then
    player.animation = animations.attack
    end
  else
    player.animation = animations.jump
  end

  if player:enter('Danger') then
    player:destroy()
  end

  player.animation:update(dt)
end

function playerDraw()
  local px, py = player:getPosition()
  player.animation:draw(sprites.playerSheet, px, py, nil, .1 * player.direction, .1, 575.5, 660)
end