local me = {}

me.lights = {
	{
		position = {function() return car.x*love.graphics.getDPIScale() end, function() return car.y*love.graphics.getDPIScale() end},
		colour = {0.9, 0.8, 0.7},
		power = 50
	},
	{
		position = {function() return love.mouse.getX()*love.graphics.getDPIScale() end, function() return love.mouse.getY()*love.graphics.getDPIScale() end},
		colour = {1.0, 0.5, 0.2},
		power = 300
	}
}

function me:send(sh)
	sh:send("num_lights", #self.lights) 
	
	for i=1, #self.lights do
		sh:send("lights["..(i-1).."].position", {self.lights[i].position[1](), self.lights[i].position[2]()})
		sh:send("lights["..(i-1).."].colourr", self.lights[i].colour)
		sh:send("lights["..(i-1).."].power", self.lights[i].power)
	end
end

return me