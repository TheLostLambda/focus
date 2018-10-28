require "control"

local thread
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

   if thread == nil then
      thread = love.thread.newThread( [[require "control"
   control.setup(love)]] )
      thread:start( 99, 1000 )
   end

   jumping = false
   goLeft = false
   goRight = false

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
      player = { x = 30, y = groundLevel, vx = scrollSpeed, vy = 0, w = 30, h = 30}
      --thread = love.thread.newThread( [[require "control"
      --control.setup(love)]] )
      --thread:start( 99, 1000 )
      newBlock(500, 100, 50, 150)
      newBlock(550, 100, 50, 100)
      newBlock(600, 100, 150, 20)
      newBlock(750, 100, 50, 100)
      newBlock(500, 300, 300, 50)

      newBlock(750, 100, 50, 150)
      newBlock(850, 100, 300, 200)
      newBlock(850, 400, 300, 100)
      newBlock(900, 300, 300, 100)
      newBlock(1250, 150, 50, 300)
      newBlock(1200, 200, 50, 50)

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

function doJump()
   hitEdge = physics.collisions(player, world)[1]
   if (player.y == groundLevel or hitEdge ~= nil)  then
      player.vy = jumpPower
   end
end

function transform(x)
   return math.exp(-math.abs(x/20))
end

function love.keypressed(key)
   if key == "r" then
      love.load()
   end
   if key == "escape" then
      love.event.quit()
   end
   if key == "space" then
      doJump()
   end
end

function love.update(dt)
   if rip then
      return
   end
   if player.x > winPoint then
      win = true
   end
   if #physics.collisions(player, oWorld) > 0 then
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
            player.vx = scrollSpeed
            if player.x <= shift then
               rip = true
               return
            end
         end
         if (hitEdge[1] == 1 or hitEdge[1] == 3) and oldx >= right then
            player.x = right
            player.vx = scrollSpeed
         end
         if (hitEdge[1] == 1 or hitEdge[1] == 4) and oldy >= top and
                 player.x ~= right and player.x + player.w ~= left then
            print(player.x)
            print(right)
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
      player.vx = scrollSpeed
   end
   if player.x + player.w > shift + winx then
      player.x = shift + winx - player.w
      player.vx = scrollSpeed
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
      player.vx = scrollSpeed - speed
   elseif love.keyboard.isDown("right") then
      player.vx = scrollSpeed + speed
   else
      player.vx = scrollSpeed
   end

   local info = love.thread.getChannel( 'info' ):pop()
   if info then
      io.write(info.."\n")
      if string.match(info, "waveIn") then
         io.write("!!!")
         handLeft()
      elseif string.match(info, "waveOut") then
         handRight()
      elseif string.match(info, "fist") or string.match(info, "fingerSpread") then
         handFist()
      elseif string.match(info, "rest") then
         handRest()
      end
   end
   local data = love.thread.getChannel( 'data' ):pop()
   if data then

      --         io.write("1: " .. data[1] .. " 2: " .. data[2] .. " 3: " .. data[3] .. " 4: " .. data[4] .. "\n")
      --6 up
      --8 left
      --4 right
      --2 down
      --      player.vy = (transform(data[3]) - transform(data[1]))*2000
      --      player.vx = (transform(data[4]) - transform(data [2]))*500


   end
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
   love.graphics.setColor(1, 0, 1)
   for i=1, #oWorld do
      obstacle = oWorld[i]
      love.graphics.rectangle("fill", obstacle.x - shift, winy-obstacle.y, obstacle.w, -obstacle.h)
   end
   for i = 1, #world do
      love.graphics.setColor(1,0,0)
      block = world[i]
      love.graphics.rectangle("fill", block.x - shift, winy - block.y, block.w, -block.h)
   end
   love.graphics.setColor(1, 1, 1)
   love.graphics.rectangle("fill", player.x - shift, winy - player.y, player.w, -player.h)
   love.graphics.setColor(0, 1, 1)
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


function handLeft()
   io.write("!LLLLL!")
   goLeft = true
end

function handRight()
   io.write("!RRRRR!")
   goRight = true
end

function handFist()
   io.write("!FIST!")
   jumping = true
   doJump()
end

function handRest()
   io.write("!REST!")
   goLeft = false
   goRight = false
   jumping = false
end

