function spawnEnemy(x, y)
  local enemy = world:newRectangleCollider(x, y, 70, 90, { collision_class = "Danger" })
  enemy.direction = 1
  enemy.speed = 200
  enemy.x = x
  enemy.y = y
  enemy.dead = false
  enemy.health = 100
  table.insert(enemies, enemy)
end

function updateEnemies(dt)
  for i, e in ipairs(enemies) do
    local ex, ey = e:getPosition()

    local colliders = world:queryRectangleArea(ex + (40 * e.direction), ey + 40, 10, 10, { 'Platform' })

    if #colliders == 0 then
      e.direction = e.direction * -1
    end
    e:setX(ex + e.speed * dt * e.direction)
  end

  for i, enemy in ipairs(enemies) do
    if player.isAttacking and distanceBetween(player.x, player.y, enemy.x, enemy.y) < 300 then
      enemy.dead = true
    end
  end

  for i, enemy in ipairs(enemies) do
    if enemy.dead == false then
      enemy.x, enemy.y = enemy:getX(), enemy:getY()
      return;
    end
  end

  for i = #enemies, 1, -1 do
    local enemy = enemies[i]
    if enemy.dead == true then table.remove(enemies, i) end
  end
end
