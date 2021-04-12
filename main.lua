function love.load()
	require("Intro/intro")
	introInitialise("Games")
	love.graphics.setBackgroundColour(50/100, 69/100, 45/100)
	screen = {}
	screen.font = love.graphics.newFont("Public_Sans/static/PublicSans-Black.ttf", 20)

	car = {}
	car.image = love.graphics.newImage("car.png")
	car.shadow = love.graphics.newImage("carShadow.png")
	car.x = love.graphics.getWidth()/2
	car.y = love.graphics.getHeight()/2
	car.xV = 0
	car.yV = 0
	car.dir = -90
	car.dirV = 0
	car.speed = 0
	car.dirNormalised = math.fmod(car.dir, 360)
	car.vDir = -90

	skidmark = {}
	local sh = love.filesystem.read('vignette.frag')--love.filesystem.read('lights.frag')
	myShader = love.graphics.newShader(sh)
	-- myShader = love.graphics.newShader[[
	-- 	#define NUM_LIGHTS 32

	-- 	struct Light {
	-- 		vec2 position;
	-- 		vec3 colourr;
	-- 		float power;
	-- 	};
	-- 	extern vec2 size;
	-- 	extern vec2 Lightt lights[NUM_LIGHTS];
	-- 	extern int num_lights;

	-- 	const float constant = 1.0;
	-- 	const float linier = 0.09;
	-- 	const floar quadratic = 0.032;

 --    vec4 effect( vec4 colour, Image texture, vec2 texture_coords, vec2 screen_coords ){
		
	-- 	vec4 pixel = Texel(texture, texture_coords);
 --    vec2 scale = screen_coords / size;
    
 --    return pixel*colour;
	-- }
 --  ]]
  myShader:send("size",{love.graphics.getWidth()*love.graphics.getDPIScale(), love.graphics.getHeight()*love.graphics.getDPIScale()}) 
end

function love.update(dt)
	introUpdate(dt)
	
	if love.keyboard.isDown("right") or love.keyboard.isDown("d") then 
		car.dirV = car.dirV + 1 * dt * car.speed
	end
	if love.keyboard.isDown("left") or love.keyboard.isDown("a") then 
		car.dirV = car.dirV - 1 * dt * car.speed
	end
	if love.keyboard.isDown("up") or love.keyboard.isDown("w") then 
		car.speed = car.speed + 1
	end
	if love.keyboard.isDown("down") or love.keyboard.isDown("s") then 
		car.speed = car.speed - 1
	end
	if love.keyboard.isDown("r") then 
		car.x = love.graphics.getWidth()/2
		car.y = love.graphics.getHeight()/2
		car.xV = 0
		car.yV = 0
		car.dir = -90
		car.dirV = 0
		car.speed = 0
	end

	if car.x > love.graphics.getWidth() or car.x < 0 then 
		--car.dir = -car.dir
		car.x = car.x - car.xV
		car.xV = -car.xV
	end
	if car.y > love.graphics.getHeight() or car.y < 0 then 
		--car.dir = -(car.dir+90)-90
		car.y = car.y - car.yV
		car.yV = -car.yV
	end

	car.dir = car.dir + car.dirV
	car.dirV = car.dirV * 0.9
	car.xV = car.xV + math.sin(-car.dir/180*math.pi) * dt * car.speed
	car.yV = car.yV + math.cos(car.dir/180*math.pi) * dt * car.speed
	car.xV = car.xV * 0.95
	car.yV = car.yV * 0.95
	car.speed = car.speed * 0.96
	car.x = car.x + car.xV
	car.y = car.y + car.yV
	car.dirNormalised = math.fmod(car.dir+360*fuckBoolean(car.dir>0)-180, 360)-(360*fuckBoolean(car.dir>0)-180)
	car.vDir = math.fmod((math.atan2(car.yV, car.xV)/math.pi*180)-90+360*fuckBoolean((math.atan2(car.yV, car.xV)/math.pi*180)-90>0)-180, 360)-(360*fuckBoolean((math.atan2(car.yV, car.xV)/math.pi*180)-90>0)-180)--(math.atan2(car.yV, car.xV)/math.pi*180)-90
end

function love.draw()
	love.graphics.setShader(myShader)

	-- myShader:send("num_lights", 2)    

 --  myShader:send("lights[0].position", {
 --      car.x*love.graphics.getDPIScale(),
 --      car.y*love.graphics.getDPIScale()
 --  })
	-- myShader:send("lights[0].colourr", {
 --      0.9, 0.8, 0.7
 --  })
	-- myShader:send("lights[0].power", 50)

	-- myShader:send("lights[1].position", {
 --      love.mouse.getX()*love.graphics.getDPIScale(),
 --      love.mouse.getY()*love.graphics.getDPIScale()
 --  })
	-- myShader:send("lights[1].colourr", {
 --      1.0, 0.5, 0.2
 --  })
	-- myShader:send("lights[1].power", 300)

	love.graphics.setColour(50/100, 69/100, 45/100)
	love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

	love.graphics.setColour(0,0,0,0.8)
	love.graphics.draw(car.shadow, car.x, car.y, (car.dirNormalised+90)/180*math.pi, 0.7, 0.7, car.image:getWidth()/2, car.image:getHeight()/2)
	love.graphics.setColour(1,1,1,1)
	love.graphics.draw(car.image, car.x, car.y, (car.dirNormalised+90)/180*math.pi, 0.7, 0.7, car.image:getWidth()/2, car.image:getHeight()/2)
	love.graphics.setColour(0,0,1,0.2)
	--love.graphics.draw(car.image, car.x, car.y, (car.vDir+90)/180*math.pi, 0.7, 0.7, car.image:getWidth()/2, car.image:getHeight()/2)
	--love.graphics.setColour(1,1,1,1)
	--love.graphics.circle("fill", car.x, car.y, 18)

	love.graphics.setColour(0,0,0,0.25)
	love.graphics.print(math.floor(car.speed), 10, 10)
	love.graphics.print("[WASD][R]", 10, love.graphics.getHeight()-screen.font:getHeight()-10)
	
	
	love.graphics.setColour(1,0,0,0.25)
	love.graphics.print(math.floor(car.vDir), love.graphics.getWidth()-screen.font:getWidth(math.floor(car.vDir)) - 10, 10)
	love.graphics.setColour(0,0,1,0.25)
	love.graphics.print(math.floor(car.dirNormalised), love.graphics.getWidth()-screen.font:getWidth(math.floor(car.dirNormalised)) - 10, 10 + screen.font:getHeight())

	love.graphics.setShader()

	introDraw()
end
