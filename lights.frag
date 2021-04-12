#define NUM_LIGHTS 32

	struct Light {
		vec2 position;
		vec3 colourr;
		float power;
	};
	extern vec2 size;
	extern Light lights[NUM_LIGHTS];
	extern int num_lights;

	const float constant = 1;
	const float linier = 1.0;//0.09;
	const float quadratic = 0.00005;//0.032;

  vec4 effect( vec4 colour, Image texture, vec2 texture_coords, vec2 screen_coords ){
		
		vec4 pixel = Texel(texture, texture_coords);
    vec2 norm_screen = screen_coords / size;
    vec3 bcolour = vec3(0.3, 0.4, 0.5);

    for (int i = 0; i < num_lights; i++) {
    	Light light = lights[i];
    	vec2 norm_pos = light.position / size;

    	float distance = length(norm_pos - norm_screen) * size.x / light.power;
    	float attenuation = 1.0 / (constant + linier * distance + quadratic * distance*distance);
    	bcolour += light.colourr * attenuation;
    }
    bcolour = clamp(bcolour, 0.0, 1.0);
    
    return pixel * colour * vec4(bcolour, 1.0);
	}