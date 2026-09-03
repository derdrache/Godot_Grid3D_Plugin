shader_type spatial;

uniform float circleRadius = .5;
uniform vec2 gridSize = vec2(10, 10);
uniform vec4 borderColor: source_color = vec4(1);
uniform vec4 cellColor: source_color = vec4(0, 0, 0, 1);

void fragment() {
	vec2 uvGrid = fract(UV * gridSize);

    float dist = length(uvGrid - 0.5);
    float circle = smoothstep(circleRadius, circleRadius - 0.02, dist);
	
	if (circle > 0.0){
		ALBEDO.rgb = cellColor.rgb;
		ALPHA = cellColor.a;
	}else{
		ALBEDO.rgb = borderColor.rgb;
		ALPHA = borderColor.a;
	}
}
