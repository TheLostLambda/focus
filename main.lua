function love.load()
   gravity = 2000
   speed = 230
   floatFactor = 0.5
   groundLevel = 100
   jumpPower = 575
   world = {}
   player = { x = 50, y = groundLevel, vx = 0, vy = 0, w = 50, h = 50}
   winx, winy = love.graphics.getDimensions()
   newBlock(500, 100, 50, 150)
   newBlock(550, 100, 50, 100)
   newBlock(600, 100, 150, 20)
   newBlock(750, 100, 50, 100)
end

function newBlock(x, y, w, h)
	world[#world+1] = {x = x, y = y, w = w, h = h}
end

function love.keypressed(key)
   if player.y == groundLevel and key == "space" then
      player.vy = jumpPower
   end
end

function love.update(dt)
   player.x = player.x + player.vx * dt
   player.y = player.y + player.vy * dt
   if player.y < groundLevel then
      player.y = groundLevel
      player.vy = 0
   else
      if love.keyboard.isDown("space") then
	 player.vy = player.vy - gravity * dt * floatFactor
      else
	 player.vy = player.vy - gravity * dt
      end
   end
    if love.keyboard.isDown("left") then
       player.x = player.x - speed * dt
    elseif love.keyboard.isDown("right") then
       player.x = player.x + speed * dt
    end
end
   
function love.draw()
   for i = 1, #world do  
      love.graphics.setColor(1,0,0)
      block = world[i]
      love.graphics.rectangle("fill", block.x, winy - block.y, block.w, -block.h)
   end
   love.graphics.setColor(1, 1, 1)
   love.graphics.rectangle("fill", player.x, winy - player.y, player.w, -player.h)
   love.graphics.setColor(0, 1, 1)
   love.graphics.rectangle("fill", 0, winy, winx, -groundLevel)
end
