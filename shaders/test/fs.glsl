	extern vec2 size;

	vec4 effect( vec4 colour, Image texture, vec2 texture_coords, vec2 screen_coords ){
		vec4 pixel = Texel(texture, texture_coords);
		vec2 st = screen_coords/size;
		
		return vec4(st.x, st.y,1.,1.) * colour * pixel;
	}