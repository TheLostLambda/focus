require "control"

local thread

function love.load()
   gravity = 1000
   speed = 150
   floatFactor = 0.2
   groundLevel = 100
   jumpPower = 300
   player = { x = 50, y = groundLevel, vx = 0, vy = 0, w = 50, h = 50}
   winx, winy = love.graphics.getDimensions()

   thread = love.thread.newThread( [[require "control"
   control.setup(love)]] )
   thread:start( 99, 1000 )
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
   --io.write("Im awake")
   local info = love.thread.getChannel( 'info' ):pop()
   if info then
      io.write(info)
   end
end

function love.draw()
   love.graphics.setColor(1, 1, 1)
   love.graphics.rectangle("fill", player.x, winy - player.y, player.w, -player.h)
   love.graphics.setColor(0, 1, 1)
   love.graphics.rectangle("fill", 0, winy, winx, -groundLevel)
end
