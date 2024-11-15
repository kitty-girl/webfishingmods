shader_type canvas_item;

uniform vec4 white_replace : hint_color = vec4(1.0,0.933,0.835,1.0);
uniform vec4 yellow_replace : hint_color = vec4(0.835,0.667,0.451,1.0);
uniform vec4 green_replace : hint_color = vec4(0.353,0.459,0.353,1.0);

vec4 ge(vec4 x, vec4 y) { return 1.0 - max(sign(y - x), 0.0); }
vec4 le(vec4 x, vec4 y) { return 1.0 - max(sign(x - y), 0.0); }

float check_colors(vec4 a, vec4 b) {
	vec4 c = ge(a, b-vec4(0.05)) * le(a, b+vec4(0.05));
	return c.r*c.g*c.b*c.a;
}

void fragment() {
	vec4 c = texture(TEXTURE,UV);
	COLOR = (white_replace*check_colors(c,vec4(1.0,0.933,0.835,1.0)));
	COLOR += (yellow_replace*check_colors(c,vec4(0.835,0.667,0.451,1.0)));
	COLOR += (green_replace*check_colors(c,vec4(0.353,0.459,0.353,1.0)));
}