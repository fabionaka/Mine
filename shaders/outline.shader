shader_type canvas_item;
uniform float width : hint_range(0,5);
uniform vec4 outline_color : hint_color;
uniform sampler2D textureName;
uniform vec2 textureName_size;



void fragment() {
	float size = width * 1.0 /float(textureName_size.x);
	vec4 sprite_color = texture(TEXTURE, UV);
	float alpha = -4.0 * sprite_color.a;
	
	alpha += texture(TEXTURE, UV + vec2(size, 0.0)).a;
	alpha += texture(TEXTURE, UV + vec2(-size, 0.0)).a;
	alpha += texture(TEXTURE, UV + vec2(0.0, size)).a;
	alpha += texture(TEXTURE, UV + vec2(0.0, -size)).a;
	
	vec4 final_color = mix(sprite_color, outline_color, clamp(alpha,0.0,1.0));
	COLOR = vec4(final_color.rgb, clamp(abs(alpha) + sprite_color.a, 0.0, 1.0));
	
}