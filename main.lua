function love.load()
  love.window.setMode(1280, 720)

  anim8 = require 'libraries/anim8/anim8'
  sti = require 'libraries/Simple-Tiled-Implementation/sti'
  cameraFile = require 'libraries/hump/camera'

  cam = cameraFile()

  sprites = {}
  sprites.playerSheet = love.graphics.newImage('sprites/playerSheet.png')
  sprites.fireBall = love.graphics.newImage('sprites/fireBall.png')

  local grid = anim8.newGrid(1151, 1151, sprites.playerSheet:getWidth(), sprites.playerSheet:getHeight())

  animations = {}
  animations.idle = anim8.newAnimation(grid("1-1", 1), 5)
  animations.jump = anim8.newAnimation(grid('2-2', 1), 2)
  animations.walk = anim8.newAnimation(grid('1-5', 2), 0.3)
  animations.run = anim8.newAnimation(grid('1-8', 3), 0.2)
  
  wf = require 'libraries/windfield/windfield'
  world = wf.newWorld(0, 800, false)
  world:setQueryDebugDrawing(true)
  world:addCollisionClass('Platform')
  world:addCollisionClass('PlatformJT')
  world:addCollisionClass('Player' --[[, {ignores = {'Platform'}}]])
  world:addCollisionClass('Danger')

  require('player')
  require('enemy')

  enemies = {}

  -- dangerZone = world:newRectangleCollider(0, 550, 800, 50, {collision_class = "Danger"})
  -- dangerZone:setType('static')

  platforms = {}

  loadMap()

  spawnEnemy(50, 100)
end
----------------------------------------------------------
function love.update(dt)
  world:update(dt)
  gameMap:update(dt)
  playerUpdate(dt)
  updateEnemies(dt)

  local px, py = player:getPosition()
  player.animation:update(dt)
end
----------------------------------------------------------------------
function love.draw()
      gameMap:drawLayer(gameMap.layers["Layer 1"])
      world:draw()
      playerDraw()
    end

    
  --   function love.mousepressed(x, y, button)
  --     if button == 1 then 
  --       local colliders = world:queryCircleArea(x, y, 200, {'Platform', 'Danger'})
  --       for i, c in ipairs(colliders) do
  --         c:destroy()
  --       end 
  --   end
  -- end

function spawnPlatform(x, y, width, height)
  if width > 0 and height > 0 then
    local platform = world:newRectangleCollider(x, y, width, height, {collision_class = "Platform"})
    platform:setType('static')
    platform:setCollisionClass('Platform')
    table.insert(platforms, platform)
  end
end

function spawnJumpThroughPlatforms(x, y, width, height)
  if width > 0 and height > 0 then
    local platformJT = world:newRectangleCollider(x, y, width, height, {collision_class = "PlatformJT"})
    platformJT:setType('static')
    platformJT:setCollisionClass('PlatformJT')
    player:setPreSolve(function(collider_1, collider_2, contact)        
      
      local px, py = collider_1:getPosition()            
      local pw = 20
      local ph = 40
      local tx, ty = collider_2:getPosition() 
      local tw = 1
      local th = 1
      
      if ph + py > ty - th / 2 then contact:setEnabled(false) end
      table.insert(platforms, platformJT)
    end)
  end
end

function love.keypressed(key)
  if player.grounded then
    if key == "up" or key == "w" then
        player:applyLinearImpulse(0, -4000)
        player.isJumping = true
      end
  end
end


function loadMap()
  gameMap = sti('maps/level2.lua')
  
  for i, obj in ipairs(gameMap.layers["Platforms"].objects) do
      spawnPlatform(obj.x, obj.y, obj.width, obj.height)
  end

  for i, jtp in ipairs(gameMap.layers["JumpThroughPlatforms"].objects) do
    spawnJumpThroughPlatforms(jtp.x, jtp.y, jtp.width, jtp.height)
  end
end

function distanceBetween(x1, y1, x2, y2)
  return math.sqrt((x2 - x1)^2 + (y2-y1)^2)
end

