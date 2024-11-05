shader_type spatial;
render_mode cull_disabled;

uniform sampler2D texture_albedo;
uniform float speed = 1.0;

void fragment() {
	ALBEDO = texture(texture_albedo, UV+vec2(TIME*speed,0)).rgb;
	ALBEDO *= ALBEDO;
	ALPHA = 0.8;
}