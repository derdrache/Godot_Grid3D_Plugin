shader_type spatial;
render_mode depth_draw_always;

uniform vec3 color : source_color = vec3(1);
uniform float radius = 0.35;

void fragment() {
	vec2 center = UV - vec2(0.5);
   
    float dist = length(center);
    
    float alpha = 1.0 - smoothstep(radius, radius, dist);
    
    ALBEDO = color;
	ALPHA = alpha;
}
