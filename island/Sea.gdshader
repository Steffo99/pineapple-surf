shader_type spatial;

uniform float speed_x;
uniform float speed_y;
uniform float size;
uniform sampler2D sea;

void fragment() {
	float x = fract(UV.x * size + sin(TIME) * speed_x);
	float y = fract(UV.y * size - TIME * 2.0 * speed_y);
	
	vec4 color = texture(sea, vec2(x, y));
	ALBEDO = vec3(color.r, color.g, color.b);
}
