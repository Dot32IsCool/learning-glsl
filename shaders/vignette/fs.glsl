	extern vec2 size;

	const vec3 acolour = vec3(0.3, 0.4, 0.5);
	const vec3 bcolour = vec3(1.0, 1.0, 1.0);

	vec4 effect( vec4 colour, Image texture, vec2 texture_coords, vec2 screen_coords ){
		
		vec4 pixel = Texel(texture, texture_coords);
		vec2 nearest_point = screen_coords/size;// normalise coordinates

		nearest_point = sign(nearest_point)*floor(abs(nearest_point)+0.5);// rounds to int
		
		vec3 r = mix(acolour, bcolour, pow(distance(nearest_point, screen_coords/size), 0.5));
		
		return pixel * colour * vec4(r, 1.0);
	}