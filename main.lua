
function love.load()
   gravity = 750
   speed = 150
   floatFactor = 0.2
   groundLevel = 100
   timer = 0
   timePassed = 0
   justObstacle = false
   oWorld = {}
   player = { x = 50,
	      y = groundLevel,
	      vx = 0,
	      vy = 0 }
   winx, winy = love.graphics.getDimensions()
   math.randomseed(os.time())
end

function obstacles()
--	math.randomseed(math.random())
	oWorld[#oWorld + 1] = { 
		x = math.random(0,winx-10),
		y = winy,
		vx = 0,
		vy = -10,
		w = 10,
		h = 10 }
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
	
	for i=1, #oWorld do
	    obs = oWorld[i]
		obs.y = obs.y - obs.vy * dt
		obs.vy = obs.vy + gravity * dt
	end
	
	timer = timer + dt
	if math.floor(timer) % 3 == 0 and not justObstacle then
		obstacles()
		justObstacle = true
 	elseif math.floor(timer) % 3 ~= 0 then
		justObstacle = false
	end
	
--	if math.floor(timer) % 2 == 0 then
--		obstacles()
--	end
end
   
function love.draw()
	love.graphics.setColor(1, 0, 1)
	for i=1, #oWorld do
		obstacle = oWorld[i]
		love.graphics.rectangle("fill", obstacle.x, winy-obstacle.y, obstacle.w, -obstacle.h)
	end
	love.graphics.print(tostring(timer))
   love.graphics.setColor(1, 1, 1)
   love.graphics.rectangle("fill", player.x, winy - player.y, 50, -50)
   love.graphics.setColor(0, 1, 1)
   love.graphics.rectangle("fill", 0, winy, winx, -groundLevel)
end
