textProps = {}
textProps.font = love.graphics.newFont('font/BEARPAW_.ttf', 50)
textProps.color = {1, 1, 1}

scoreProps = {}
scoreProps.title = 'Zombie Slain: '
scoreProps.x = 10
scoreProps.y = 10

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
