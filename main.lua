function love.load()
  love.window.setTitle('KADOOM !')
  sprites={}
  sprites.player = love.graphics.newImage('sprites/player.png')
  sprites.fireBolt = love.graphics.newImage('sprites/bullet.png')
  sprites.zombie = love.graphics.newImage('sprites/zombie.png')
  sprites.background = love.graphics.newImage('sprites/background.png')

  player = {}
  player.x = 200
  player.y = 200
  player.centerX = sprites.player:getWidth()/2
  player.centerY = sprites.player:getHeight()/2
  player.speed = 360

  zombies = {}
  fireBolts = {}

end

function love.update(dt)

  if love.keyboard.isDown('s') then
   player.y = player.y + player.speed * dt
  end
  if love.keyboard.isDown('w') then
   player.y = player.y - player.speed * dt
  end
  if love.keyboard.isDown('d') then
   player.x = player.x + player.speed * dt
  end
  if love.keyboard.isDown('a') then
   player.x = player.x - player.speed * dt
  end

  for i,z in ipairs(zombies) do
    z.x = z.x + math.cos(zombiePlayerAngle(z)) * z.speed * dt
    z.y = z.y + math.sin(zombiePlayerAngle(z)) * z.speed * dt

    if distanceBetween (z.x,z.y,player.x,player.y)< 30 then
        for i,z in ipairs(zombies) do
            zombie[i] = nil
        end
    end
  end
  for i,b in ipairs(fireBolts) do
    b.x = b.x + math.cos(b.direction) * b.speed * dt
    b.y = b.y + math.sin(b.direction) * b.speed * dt
  end

  for i=#fireBolts,1,-1 do
    local b = fireBolts[i]
    if b.x < 0 or b.y < 0 or b.x > love.graphics.getWidth() or b.y > love.graphics.getHeight() or b.dead == true then
      table.remove(fireBolts,i)
    end
  end

  for i,z in ipairs(zombies) do
    for j,b in ipairs(fireBolts) do
      if distanceBetween (z.x, z.y, b.x, b.y) < 20 then
        z.dead = true
        b.dead = true
      end
    end
  end

  for i=#zombies,1,-1 do
    local z = zombies[i]
    if z.dead == true then
      table.remove(zombies,i)
    end
  end

end

function love.draw()
  love.graphics.draw(sprites.background,0,0)
  love.graphics.draw(sprites.player,player.x,player.y, playerMouseAngle(),nil,nil,player.centerX,player.centerY)

  for i,z in ipairs(zombies) do
    love.graphics.draw(sprites.zombie, z.x, z.y,zombiePlayerAngle(z),nil,nil,z.centerX,z.centerY)
  end

  for i,b in ipairs(fireBolts) do
      love.graphics.draw(sprites.fireBolt, b.x, b.y,nil,b.widthModifier,b.heightModifier)
  end

end


function playerMouseAngle()
  return math.atan2(player.y-love.mouse.getY(), player.x-love.mouse.getX()) + math.pi
end

function zombiePlayerAngle(nemesis)
  return math.atan2(player.y-nemesis.y, player.x-nemesis.x)
end

function summonFireBolt()
  fireBolt={}
  fireBolt.x = player.x
  fireBolt.y = player.y
  fireBolt.widthModifier = 0.5
  fireBolt.heightModifier = 0.5
  fireBolt.speed = 500
  fireBolt.dead = false
  fireBolt.direction = playerMouseAngle()

  table.insert(fireBolts,fireBolt)
end

function raiseZombie()
  zombie={}
  zombie.x=math.random(0, love.graphics.getWidth())
  zombie.y=math.random(0, love.graphics.getHeight())
  zombie.centerX = sprites.zombie:getWidth()/2
  zombie.centerY = sprites.zombie:getHeight()/2
  zombie.dead = false
  zombie.speed= 180

  table.insert(zombies,zombie)

end

function love.keypressed(key, scancode, isrepeat)
  if key == 'space' then
    raiseZombie()
  end
end

function love.mousepressed(x, y, button, isTouch)
  if button==1 then
    summonFireBolt()
  end
end

function distanceBetween(x1,y1,x2,y2)
  return math.sqrt((y2 - y1)^2 +(x2 - x1)^2 )
end
