--require "control"
--local thread
require "physics"

function obstacles()
   oWorld[#oWorld + 1] = { 
      x = math.random(shift,winx-50+shift),
      y = winy,
      vx = 0,
      vy = 100,
      w = 40,
      h = 40 }
end

function newBlock(x, y, w, h)
   world[#world+1] = {x = x, y = y, w = w, h = h}
end

function newLava(x, y, w, h)
   oWorld[#oWorld+1] = {x = x, y = y, w = w, h = h, vx = 0, vy = 0}
end

function love.load()
   rip = false
   win = false
   winx, winy = love.graphics.getDimensions()
   love.graphics.setNewFont(64)
   love.window.setTitle("Focus")
   oWorld = {}
   world = {}
   justObstacle = false
   timer = 0
   shift = 0
   math.randomseed(os.time())

   if level == nil then
      level = 1
   end
   
   if level == 1 then
      gravity = 2000
      speed = 230
      floatFactor = 0.5
      groundLevel = 100
      jumpPower = 575
      scrollSpeed = 50
      rainDelay = 2
      player = { x = 30, y = groundLevel, vx = 0 --[[scrollSpeed]], vy = 0, w = 30, h = 30}
      --thread = love.thread.newThread( [[require "control"
      --control.setup(love)]] )
      --thread:start( 99, 1000 )
      newBlock(500, 100, 50, 150)
      newBlock(550, 100, 50, 100)
      newBlock(600, 100, 150, 20)
      newBlock(750, 100, 50, 100)
      newLava(600, 120, 150, 60) 
      
      newBlock(750, 100, 50, 150)
      newBlock(850, 100, 300, 200)
      newBlock(850, 400, 300, 60)
      newBlock(900, 300, 300, 100)
      newBlock(1250, 150, 50, 300)
      newBlock(1200, 200, 50, 50)
      newLava(1150, 100, 350, 40)
      
      newBlock(1400, 100, 50, 50)
      newBlock(1450, 100, 50, 100)
      newBlock(1500, 100, 50, 150)
      newBlock(1550, 100, 50, 200)
      newBlock(1600, 100, 50, 250)
      newBlock(1650, 100, 50, 300)
      
      newBlock(1650, 350, 50, 100)   
      newBlock(1700, 300, 450, 50)
      newBlock(1750, 200, 450, 50)
      newBlock(2200, 150, 50, 500)
      winPoint = 2300
   end
end

function love.keypressed(key)
   if key == "r" then
      love.load()
   end
   if key == "escape" then
      love.event.quit()
   end
   hitEdge = physics.collisions(player, world)
   if player.y == groundLevel and key == "space" then
      player.vy = jumpPower
   elseif key == "space" then
      for i = 1, #hitEdge do
	 blocky = hitEdge[i]
	 if blocky[2].y + blocky[2].h <= player.y then
	    player.vy = jumpPower
	    break
	 end
      end
   end
end

function love.update(dt)
   if rip then
      return
   end
   if player.x > winPoint then
      win = true
   end
   if #physics.collisions(player, oWorld) > 0 and not win then
      rip = true
   end
   oldx = player.x
   oldy = player.y
   player.x = player.x + player.vx * dt
   player.y = player.y + player.vy * dt
   collideroonis = physics.collisions(player,world)
   for i = 1, #collideroonis do
      hitEdge = collideroonis[i]
      if hitEdge ~= nil then
	 top = hitEdge[2].y + hitEdge[2].h
	 left = hitEdge[2].x
	 right = hitEdge[2].x + hitEdge[2].w
	 bottom = hitEdge[2].y
	 if (hitEdge[1] == 2 or hitEdge[1] == 4) and oldx + player.w <= left then
	    player.x = left - player.w
	    player.vx = 0 --scrollSpeed
	    if player.x <= shift then
	       rip = true
	       return
	    end
	 end
	 if (hitEdge[1] == 1 or hitEdge[1] == 3) and oldx >= right then
	    player.x = right
	    player.vx = 0 --scrollSpeed
	 end
	 if (hitEdge[1] == 1 or hitEdge[1] == 4) and oldy >= top and
	 player.x ~= right and player.x + player.w ~= left then
	    player.y = top
	    player.vy = 0
	 end
	 if (hitEdge[1] == 2 or hitEdge[1] == 3) and oldy + player.h <= bottom then
	    player.y = bottom - player.h
	    player.vy = 0
	 end
      end
   end
   if player.x < shift then
      player.x = shift
      player.vx = 0 --scrollSpeed
      smush = physics.collisions(player, world)
      for i = 1, #smush do
         if smush[i][1] == 2 then
            rip = true
	    break
         end
      end
   end
   if player.x + player.w > shift + winx then
      player.x = shift + winx - player.w
      player.vx = 0 --scrollSpeed
   end
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
      player.vx = 0 --[[scrollSpeed]] - speed
   elseif love.keyboard.isDown("right") then
      player.vx = 0 --[[scrollSpeed]] + speed
   else
      player.vx = 0 --scrollSpeed
   end
   --[[
   local info = love.thread.getChannel( 'info' ):pop()
   if info then
      io.write(info.."\n")
      if string.match(info, "waveIn") then
         io.write("!!!")
         handLeft()
      elseif string.match(info, "waveOut") then
         handRight()
      elseif string.match(info, "fist") then
         handFist()
      end
   end]]
   for i=1, #oWorld do
      obs = oWorld[i]
      obs.y = obs.y - obs.vy * dt
      obs.x = obs.x - obs.vx * dt
   end
   shift = shift + scrollSpeed * dt
   timer = timer + dt
   if math.floor(timer) % rainDelay == 0 and not justObstacle then
      obstacles()
      justObstacle = true
   elseif math.floor(timer) % rainDelay ~= 0 then
      justObstacle = false
   end
end

function love.draw()
   love.graphics.setBackgroundColor(135 / 255, 206 / 255, 235 / 255)
   love.graphics.setColor(234 / 255, 72 / 255, 0)
   for i=1, #oWorld do
      obstacle = oWorld[i]
      love.graphics.rectangle("fill", obstacle.x - shift, winy-obstacle.y, obstacle.w, -obstacle.h)
   end
   for i = 1, #world do  
      love.graphics.setColor(166 / 255, 128 / 255, 100 / 255)
      block = world[i]
      love.graphics.rectangle("fill", block.x - shift, winy - block.y, block.w, -block.h)
   end
   love.graphics.setColor(0.3, 0.3, 0.3)
   love.graphics.rectangle("fill", player.x - shift, winy - player.y, player.w, -player.h)
   love.graphics.setColor(63 / 255, 112 / 255, 77 / 255)
   love.graphics.rectangle("fill", 0, winy, winx, -groundLevel)
   if rip or win then
      love.graphics.setColor(0, 0, 0, 0.75)
      love.graphics.rectangle("fill", 0, 0, winx, winy)
      love.graphics.setColor(1,1,1)
      if rip then
	 love.graphics.printf("RIP\n(Press 'r' to restart)", 0, winy * 0.33, winx, "center")
      else
	 love.graphics.printf("You Win!\n(Press 'r' to continue)", 0, winy * 0.33, winx, "center")
	 level = level + 1
      end
   end
end

--[[
function handLeft()
   io.write("!LLLLL!")
end

function handRight()
   io.write("!RRRRR!")
end

function handFist()
   io.write("!FIST!")
end
]]
