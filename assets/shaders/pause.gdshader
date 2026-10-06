shader_type canvas_item;

// Controls the intensity of the static mix over the black background
uniform float static_intensity : hint_range(0.0, 1.0) = 0.25;
uniform float scanline_count : hint_range(10.0, 1080.0) = 300.0;

// High-speed pseudo-random noise calculation
float random(vec2 co) {
    return fract(sin(dot(co.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

void fragment() {
    vec2 uv = SCREEN_UV;
    
    // 1. Generate procedural high-frequency white noise based on time
    float noise = random(uv + vec2(TIME * 0.13, TIME * 0.21));
    
    // 2. Create the scrolling horizontal scanlines
    float scanline = sin(uv.y * scanline_count + TIME * 5.0) * 0.15;
    
    // 3. Establish a cold, gritty dark gray base tone for the background
    vec3 base_darkness = vec3(0.03, 0.03, 0.04);
    vec3 static_color = vec3(noise);
    
    // Combine passes: Base darkness + noise mix + scanline distortions
    vec3 final_color = mix(base_darkness, static_color, static_intensity);
    final_color -= vec3(scanline);
    
    // CRITICAL FIX: Multiply by the node's alpha (COLOR.a) so the fade actually works!
    COLOR = vec4(final_color, 0.92 * COLOR.a); 
}