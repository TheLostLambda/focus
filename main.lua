function love.load()
   gravity = 400
   groundLevel = 100
   player = { x = 50,
	      y = groundLevel,
	      vx = 0,
	      vy = 0 }
   winx, winy = love.graphics.getDimensions()
end

function love.keypressed(key)
   if player.y == groundLevel and key == "space" then
      player.vy = player.vy + 200
   end
end

function love.update(dt)
   player.x = player.x + player.vx * dt
   player.y = player.y + player.vy * dt
   if player.y < groundLevel then
      player.y = groundLevel
      player.vy = 0
   else
     player.vy = player.vy - gravity * dt
   end
end
   
function love.draw()
   love.graphics.setColor(1, 1, 1)
   love.graphics.rectangle("fill", player.x, winy - player.y, 50, -50)
   love.graphics.setColor(0, 1, 1)
   love.graphics.rectangle("fill", 0, winy, winx, -groundLevel)
end
