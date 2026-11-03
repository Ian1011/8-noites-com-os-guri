shader_type spatial;
render_mode unshaded;

uniform float noise_scale = 180.0;
uniform float noise_speed = 25.0;

float random(vec2 position) {
	return fract(
		sin(dot(position, vec2(12.9898, 78.233)))
		* 43758.5453
	);
}

void fragment() {
	vec2 pixel = floor(UV * noise_scale);

	float frame = floor(TIME * noise_speed);

	float noise = random(
		pixel + vec2(frame, frame)
	);

	ALBEDO = vec3(noise);
}