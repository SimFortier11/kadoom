function love.load()
  love.window.setTitle('KADOOM !')
  sprites = {}
  sprites.player = love.graphics.newImage('sprites/player.png')
  sprites.fireBolt = love.graphics.newImage('sprites/bullet.png')
  sprites.zombie = love.graphics.newImage('sprites/zombie.png')
  sprites.background = love.graphics.newImage('sprites/background.png')

  player = {}
  player.x = 200
  player.y = 200
  player.centerX = sprites.player:getWidth() / 2
  player.centerY = sprites.player:getHeight() / 2
  player.speed = 360

  zombies = {}
  fireBolts = {}

  textProps = {}
  textProps.font = love.graphics.newFont('font/BEARPAW_.ttf', 50)
  textProps.color = {1, 1, 1}

  soundFX = {}
  soundFX.fireBolt = love.audio.newSource('sounds/wjl_fireball.flac', 'static')
  soundFX.splat = love.audio.newSource('sounds/slykmrbyches_splattt.mp3', 'static')

  scoreProps = {}
  scoreProps.title = 'Zombie Slain: '
  scoreProps.x = 10


  timerProps = {}
  timerProps.title = 'Time: '
  timerProps.x = love.graphics.getWidth() - 225

  mainMenuProps = {}
  mainMenuProps.text = 'Click Anywere to Start !'
  mainMenuProps.x = 0
  mainMenuProps.y = love.graphics.getHeight() / 2
  mainMenuProps.limit = love.graphics.getWidth()

  titleProps = {}
  titleProps.text = 'KADOOM'
  titleProps.font = love.graphics.newFont('font/BEARPAW_.ttf', 150)
  titleProps.x = 0
  titleProps.y = mainMenuProps.y - 150
  titleProps.limit = love.graphics.getWidth()

  endMenuProps = {}
  endMenuProps.title = 'YOU ARE DEAD !'
  endMenuProps.color = {0.75, 0, 0}
  endMenuProps.text = 'Zombie Slain:'
  endMenuProps.subText = 'Click Anywere to Restart !'

  gameState = 1
  maxTime = 2
  timer = maxTime
  score = 0

end

function love.update(dt)

  if gameState == 2 then
    if love.keyboard.isDown('s') and player.y < love.graphics.getHeight() then
      player.y = player.y + player.speed * dt
    end
    if love.keyboard.isDown('w') and player.y > 0 then
      player.y = player.y - player.speed * dt
    end
    if love.keyboard.isDown('d') and player.x < love.graphics.getWidth() then
      player.x = player.x + player.speed * dt
    end
    if love.keyboard.isDown('a') and player.x > 0 then
      player.x = player.x - player.speed * dt
    end
  end
  for i, z in ipairs(zombies) do
    z.x = z.x + math.cos(zombiePlayerAngle(z)) * z.speed * dt
    z.y = z.y + math.sin(zombiePlayerAngle(z)) * z.speed * dt

    if distanceBetween (z.x, z.y, player.x, player.y) < 30 then
      for i, z in ipairs(zombies) do
        zombie[i] = nil
        gameState = 3
      end
    end
  end
  for i, b in ipairs(fireBolts) do
    b.x = b.x + math.cos(b.direction) * b.speed * dt
    b.y = b.y + math.sin(b.direction) * b.speed * dt
  end

  for i = #fireBolts, 1, - 1 do
    local b = fireBolts[i]
    if b.x < 0 or b.y < 0 or b.x > love.graphics.getWidth() or b.y > love.graphics.getHeight() or b.dead == true then
      table.remove(fireBolts, i)
    end
  end

  for i, z in ipairs(zombies) do
    for j, b in ipairs(fireBolts) do
      if distanceBetween (z.x, z.y, b.x, b.y) < 20 then
        z.dead = true
        b.dead = true
      end
    end
  end

  for i = #zombies, 1, - 1 do
    local z = zombies[i]
    if z.dead == true then
      score = score + 1
      soundFX.splat:play()
      table.remove(zombies, i)
    end
  end

  if gameState == 2 then
    timer = timer - dt
    if timer <= 0 then
      raiseZombie()
      maxTime = maxTime * 0.95
      timer = maxTime
    end
  end
end

function love.draw()

  if gameState == 2 then
    love.graphics.draw(sprites.background, 0, 0)
    love.graphics.draw(sprites.player, player.x, player.y, playerMouseAngle(), nil, nil, player.centerX, player.centerY)
    love.graphics.print(scoreProps.title .. score, scoreProps.x)

    for i, z in ipairs(zombies) do
      love.graphics.draw(sprites.zombie, z.x, z.y, zombiePlayerAngle(z), nil, nil, z.centerX, z.centerY)
    end

    for i, b in ipairs(fireBolts) do
      love.graphics.draw(sprites.fireBolt, b.x, b.y, nil, b.widthModifier, b.heightModifier)
    end
  end
  if gameState == 1 then
    --Title
    love.graphics.setFont(titleProps.font)
    love.graphics.setColor(textProps.color)
    love.graphics.printf(titleProps.text, titleProps.x, titleProps.y, titleProps.limit, 'center')
    --Text Menu
    love.graphics.setFont(textProps.font)
    love.graphics.printf(mainMenuProps.text, mainMenuProps.x, mainMenuProps.y, mainMenuProps.limit, 'center')
  end
  if gameState == 3 then
    --Title
    love.graphics.setFont(titleProps.font)
    love.graphics.setColor(endMenuProps.color)
    love.graphics.printf(endMenuProps.title, titleProps.x, titleProps.y, titleProps.limit, 'center')
    -- Other Text
    love.graphics.setFont(textProps.font)
    love.graphics.printf(endMenuProps.text, mainMenuProps.x, mainMenuProps.y, mainMenuProps.limit, 'center')
    love.graphics.printf(score, mainMenuProps.x, mainMenuProps.y + 60, mainMenuProps.limit, 'center')
    love.graphics.printf(endMenuProps.subText, mainMenuProps.x, mainMenuProps.y + 120, mainMenuProps.limit, 'center')
  end
end


function playerMouseAngle()
  return math.atan2(player.y - love.mouse.getY(), player.x - love.mouse.getX()) + math.pi
end

function zombiePlayerAngle(nemesis)
  return math.atan2(player.y - nemesis.y, player.x - nemesis.x)
end

function summonFireBolt()
  fireBolt = {}
  fireBolt.x = player.x
  fireBolt.y = player.y
  fireBolt.widthModifier = 0.5
  fireBolt.heightModifier = 0.5
  fireBolt.speed = 500
  fireBolt.dead = false
  fireBolt.direction = playerMouseAngle()
  soundFX.fireBolt:play()

  table.insert(fireBolts, fireBolt)
end

function raiseZombie()
  zombie = {}
  zombie.x = 0
  zombie.y = 0
  zombie.centerX = sprites.zombie:getWidth() / 2
  zombie.centerY = sprites.zombie:getHeight() / 2
  zombie.dead = false
  zombie.speed = 180

  local side = math.random(1, 4)

  -- Start from left(1),top(2),right(3),down(4)
  if side == 1 then
    zombie.x = -30
    zombie.y = math.random(0, love.graphics.getHeight())
  elseif side == 2 then
    zombie.x = math.random(0, love.graphics.getWidth())
    zombie.y = -30
  elseif side == 3 then
    zombie.x = love.graphics.getWidth() + 30
    zombie.y = math.random(0, love.graphics.getHeight())
  elseif side == 4 then
    zombie.x = math.random(0, love.graphics.getWidth())
    zombie.y = love.graphics.getHeight() + 30
  end

  table.insert(zombies, zombie)

end

-- function love.keypressed(key, scancode, isrepeat)
--   if button == 1 then
--     if gameState == 1 then
--       gameState = 2
--     end
--     if gameState == 3 then
--       score = 0
--       maxTime = 2
--       gameState = 2
--     end
--   end
-- end

function love.mousepressed(x, y, button, isTouch)
  if button == 1 then
    if gameState == 1 then
      gameState = 2
    end
    if gameState == 2 then
      summonFireBolt()
    end
    if gameState == 3 then
      score = 0
      maxTime = 2
      gameState = 2
    end
  end
end

function distanceBetween(x1, y1, x2, y2)
  return math.sqrt((y2 - y1)^2 + (x2 - x1)^2 )
end
