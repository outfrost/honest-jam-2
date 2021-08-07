shader_type canvas_item;

uniform vec4 color: hint_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform float scale: hint_range(0.0, 10.0) = 0.5;

float noise(vec2 co) {
	return fract(sin(dot(co, vec2(12.9898,78.233))) * 43758.5453);
}

void fragment() {
	vec2 dvec = abs(vec2(0.5, 0.5) - SCREEN_UV);

	float d = max(dvec.x, dvec.y);
	float l = length(dvec);
	d = mix(d, l, smoothstep(-0.15, 0.25, l - d));

	float fade = smoothstep(0.25, 0.9, d) * 4.0;

	float vignette = fade * scale;
	float dithered = vignette + (noise(SCREEN_UV) * 0.05);

	COLOR = color;
	COLOR.a *= clamp(dithered, 0.0, 1.0);
}
