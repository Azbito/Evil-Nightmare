player = world:newRectangleCollider(300, 40, 40, 100, {collision_class = "Player"})
player:setFixedRotation(true)
player.speed = 240
player.runningSpeed = 340
player.animation = animations.idle
player.direction = 1
player.grounded = true
cooldown = 0

function playerUpdate(dt)
  if player.body then
    local colliders = world:queryRectangleArea(player:getX() - 20, player:getY() + 50, 40, 2, {'Platform', 'PlatformJT'})

    if player.isJumping and #colliders > 0.5 then
      player.isJumping = false
    end

    if #colliders > 0 then
      player.grounded = true
    else 
      player.grounded = false
    end

    player.isLinearJump = false
    player.isWalking = false
    player.isRunning = false
    player.isAttacking = false
    player.isMoving = false

    px, py = player:getPosition()
    cooldown = math.max(cooldown - dt, 0)

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
  -- if player.grounded then
    -- if player.isRunning then
    --   player.animation = animations.run
    -- end
    if player.isJumping then
      player.animation = animations.jump
    end

    if player.isWalking --[[and player.isRunning == false]] then
      player.animation = animations.walk
    -- elseif not player.isWalking then 
      -- player.animation = animations.jump
    end
    print(player.isJumping)

    if not player.isJumping and not player.isWalking then 
    player.animation = animations.idle
    end

    -- if player.isAttacking == true then
    --   player.animation = animations.attack
    -- end 
  -- elseif player.isJumping and not player.grounded then
    -- player.animation = animations.jump
  -- end
  if player:enter('Danger') then
    player:destroy()
  end

  -- player.animation:update(dt)
end

function playerDraw()
  local px, py = player:getPosition()
  player.animation:draw(sprites.playerSheet, px, py, nil, .1 * player.direction, .1, 575.5, 660)
end

function love.keypressed(key)
  if key == "up" or key == "w" then
      player:applyLinearImpulse(0, -4000)
      player.isJumping = true
    end
end
