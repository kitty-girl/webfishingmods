shader_type canvas_item;

uniform vec4 light_replace : hint_color = vec4(1.0,0.929,0.835,1.0);
uniform vec4 dim_replace : hint_color = vec4(0.706,0.506,0.255,1.0);
uniform vec4 mid_replace : hint_color = vec4(0.706,0.506,0.255,1.0);
uniform vec4 dark_replace : hint_color = vec4(0.416,0.267,0.125,1.0);
uniform vec4 accent_replace : hint_color = vec4(0.353,0.459,0.353,1.0);
uniform vec4 worth_replace : hint_color = vec4(0.706,0.506,0.255,1.0);

vec3 ge(vec3 x, vec3 y) { return 1.0 - max(sign(y - x), 0.0); }
vec3 le(vec3 x, vec3 y) { return 1.0 - max(sign(x - y), 0.0); }

float check_colors(vec3 a, vec3 b) {
	vec3 c = ge(a, b-vec3(0.05)) * le(a, b+vec3(0.05));
	return c.r*c.g*c.b;
}

vec3 replace_colors(vec3 base, vec3 from, vec3 with) {
	return (with-base)*check_colors(base,from);
}

void fragment() {
	vec4 c = COLOR;
	COLOR.a = texture(TEXTURE,UV).a;
	COLOR.rgb +=  (light_replace.rgb-c.rgb)*check_colors(c.rgb,vec3(1.000,0.933,0.835));
	COLOR.rgb +=    (dim_replace.rgb-c.rgb)*check_colors(c.rgb,vec3(0.835,0.667,0.451));
	COLOR.rgb +=    (mid_replace.rgb-c.rgb)*check_colors(c.rgb,vec3(0.706,0.506,0.255));
	COLOR.rgb +=   (dark_replace.rgb-c.rgb)*check_colors(c.rgb,vec3(0.416,0.267,0.125));
	COLOR.rgb += (accent_replace.rgb-c.rgb)*check_colors(c.rgb,vec3(0.353,0.459,0.353));
	COLOR.rgb +=  (worth_replace.rgb-c.rgb)*check_colors(c.rgb,vec3(0.643,0.667,0.224));
}