shader_type spatial;

vec4 blur5(sampler2D image, vec2 uv, vec2 resolution, vec2 direction) {
	vec4 color = vec4(0.0);
	vec2 off1 = vec2(1.3333333333333333) * direction;
	color += texture(image, uv) * 0.29411764705882354;
	color += texture(image, uv + (off1 / resolution)) * 0.35294117647058826;
	color += texture(image, uv - (off1 / resolution)) * 0.35294117647058826;
	return color; 
}

vec4 gather_brightness(sampler2D image, vec2 uv, vec2 resolution) {
	int range = 8;
	float max_dist = float(range);

	vec4 color = texture(image, uv);
	
	for (int i = 0; i < range; i++) {
		float f = float(i & 1);
		float dist = float(i);
		vec2 off1 = dist * vec2(1.0, f);
		vec2 off2 = dist * vec2(- f, 1.0);
		vec2 off3 = dist * vec2(- 1.0, - f);
		vec2 off4 = dist * vec2(f, - 1.0);
		float dist_perc = dist / max_dist;
		float weight = 0.0125 * (1.0 - (dist_perc * dist_perc)) / max_dist;
		color += max(texture(image, uv + (off1 / resolution)) * weight, 0.0);
		color += max(texture(image, uv + (off2 / resolution)) * weight, 0.0);
		color += max(texture(image, uv + (off3 / resolution)) * weight, 0.0);
		color += max(texture(image, uv + (off4 / resolution)) * weight, 0.0);
	}
	
	return color; 
}

void vertex() {
	POSITION = vec4(VERTEX, 1.0);
}

const int iterations = 16;

void fragment() {
	float depth = texture(DEPTH_TEXTURE, SCREEN_UV).x;
	float blurred_depth = gather_brightness(DEPTH_TEXTURE, SCREEN_UV, VIEWPORT_SIZE).x;
	vec4 view = INV_PROJECTION_MATRIX * (vec4(SCREEN_UV, blurred_depth, 1.0) * 2.0 - 1.0);
	view.xyz /= view.w;
	float linear_depth = -view.z;

	vec3 colour = texture(SCREEN_TEXTURE, SCREEN_UV).xyz;
	float tint = 1.0 - (linear_depth / 200.0);
//	ALBEDO = vec3(tint);
	ALBEDO = vec3(blurred_depth);
//	ALBEDO = colour * tint;
//	ALBEDO = vec3(depth);
//	EMISSION = vec3(1.0, 1.0, 1.0);
}