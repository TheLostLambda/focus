--require "control"

--local thread

function love.load()
   gravity = 2000
   speed = 230
   floatFactor = 0.5
   groundLevel = 100
   jumpPower = 575
   world = {}
   player = { x = 50, y = groundLevel, vx = 0, vy = 0, w = 50, h = 50}
   winx, winy = love.graphics.getDimensions()
   --thread = love.thread.newThread( [[require "control"
   --control.setup(love)]] )
   --thread:start( 99, 1000 )
   timePassed = 0
   oWorld = {}
   winx, winy = love.graphics.getDimensions()
   math.randomseed(os.time())
   obstacles()
   obstacles()
   obstacles()
end

function obstacles()
   oWorld[#oWorld + 1] = { 
      x = math.random(0,winx-10),
      y = winy,
      vx = 0,
      vy = -10,
      w = 10,
      h = 10 }
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
   hitEdge = collisions(player, world)
   if hitEdge[1] ~= nil then
      player.y = hitEdge[2].x + hitEdge[2].h
      player.vy = 0
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
      player.vx = -speed
   elseif love.keyboard.isDown("right") then
      player.vx = speed
   else
      player.vx = 0
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
      obs.vy = obs.vy + gravity * dt
   end
   timePassed = timePassed + dt
   if timePassed == 5 then
      timePassed = 0
      obstacles()
   end
end

function love.draw()
   love.graphics.setColor(1, 0, 1)
   for i=1, #oWorld do
      obstacle = oWorld[i]
      love.graphics.rectangle("fill", obstacle.x, winy-obstacle.y, obstacle.w, -obstacle.h)
   end
   for i = 1, #world do  
      love.graphics.setColor(1,0,0)
      block = world[i]
      love.graphics.rectangle("fill", block.x, winy - block.y, block.w, -block.h)
   end
   love.graphics.print(tostring(collisions(player, world)[1]))
   love.graphics.setColor(1, 1, 1)
   love.graphics.rectangle("fill", player.x, winy - player.y, player.w, -player.h)
   love.graphics.setColor(0, 1, 1)
   love.graphics.rectangle("fill", 0, winy, winx, -groundLevel)
end


function boundingPoints(obj)
   points = {}
   points[1] = {obj.x, obj.y}
   points[2] = {obj.x + obj.w, obj.y + obj.h}
   points[3] = {obj.x, obj.y + obj.h}
   points[4] = {obj.x + obj.w, obj.y}
   return points
end

function between(p, p1, p2)
   return p1[1] <= p[1] and p[1] <= p2[1] and p1[2] <= p[2] and p[2] <= p2[2]
end

function inside(p, obj)
   bounds = boundingPoints(obj)
   return between(p, bounds[1], bounds[2])
end

-- 1 : Bottom left
-- 2 : Top Right
-- 3 : Top Left
-- 4 : Bottom Right
function collisions(obj, world)
   rektdBy = {}
   box = boundingPoints(obj)
   for i, obstacle in ipairs(world) do
      for i = 1, #box do
	 if inside(box[i], obstacle) then
	    rektdBy[#rektdBy+1] = {i, obstacle}
	 end
      end
   end
   return rektdBy
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
