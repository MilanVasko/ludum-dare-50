shader_type canvas_item;

const float PI = 3.1415926535;

void vertex() {
}

float cone(vec2 pos) {
	return 1.0 - pow(abs(mix(-1.0, 1.0, pos.x)) / mix(0.15, 1.0, pos.y), 2.0);
}

float strength(vec2 pos) {
	return pow(1.0 - pos.y, 0.5);
}

void fragment() {
	float result = 1.0;
	result *= cone(UV);
	result *= strength(UV);
	
	COLOR.a = max(result, 0.0);
}

void light() {
	// nothing
}