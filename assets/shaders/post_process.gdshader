shader_type canvas_item;

// Grab the texture of the game screen below this node
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

// Vignette Controls
uniform float vignette_intensity : hint_range(0.0, 3.0) = 0.4;
uniform float vignette_opacity : hint_range(0.0, 1.0) = 0.8;

// Film Grain Controls
uniform float grain_amount : hint_range(0.0, 0.1) = 0.03;

// A simple pseudo-random noise generator for the film grain
float random(vec2 uv) {
    return fract(sin(dot(uv.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

void fragment() {
	// 1. Fetch the raw game screen color at the current pixel coordinate
	vec4 screen_color = texture(screen_texture, SCREEN_UV);
	vec3 final_color = screen_color.rgb;
	
	// 2. APPLY VIGNETTE
	// Calculate distance from the current pixel to the exact center of the screen (0.5, 0.5)
	vec2 uv = SCREEN_UV - vec2(0.5);
	float d = length(uv);
	// Create a soft gradient falloff towards the edges
	float vignette = smoothstep(0.5, 0.5 - vignette_intensity, d);
	// Blend the vignette darkness into the final color calculation
	final_color = mix(final_color * vignette, final_color, 1.0 - vignette_opacity);
	
	// 3. APPLY FILM GRAIN
	// Generate shifting noise coordinates using the engine's built-in run time clock (TIME)
	vec2 grain_uv = SCREEN_UV + vec2(sin(TIME), cos(TIME));
	float noise = random(grain_uv);
	// Displace the brightness lightly based on the random noise pattern
	final_color += (noise - 0.5) * grain_amount;
	
	// Output the newly calculated color values back to the viewport display
	COLOR = vec4(final_color, screen_color.a);
}