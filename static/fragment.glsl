#define PI 3.14159265359

varying vec2 vUv;
varying vec3 vPos;

uniform vec2 u_resolution;
uniform sampler2D colorMap;

uniform float u_zoom;
uniform float u_innerAngle;
uniform float u_middleAngle;
uniform float u_outterAngle;

vec2 map(vec2 value, vec2 inMin, vec2 inMax, vec2 outMin, vec2 outMax) {
  return outMin + (outMax - outMin) * (value - inMin) / (inMax - inMin);
}

float circle(in vec2 st, in float radius){
    vec2 dist = st - vec2(0.5);
	return 1.0 - smoothstep( radius - (radius * 0.01), radius + (radius*0.01), dot(dist,dist)*4.0);
}

vec2 rotateUV(vec2 uv_coord, float angle) {
    vec2 coord = uv_coord;
    float sin_factor = sin(angle);
    float cos_factor = cos(angle);
    coord = vec2((coord.x - 0.5) * (u_resolution.x / u_resolution.y), coord.y - 0.5) * mat2(cos_factor, sin_factor, -sin_factor, cos_factor);
    coord += 0.5;
    return coord;
}

void main(){
	vec2 st = gl_FragCoord.xy/u_resolution.xy;

    vec2 uv_coord = map(vUv, vec2(0.0), vec2(1.0), vec2(1.0 - u_zoom), vec2(1.0 - (1.0 - u_zoom)));

	vec3 innerCircle = vec3(circle(st,0.2));
	vec3 outterCircle = vec3(circle(st,0.8));

    vec3 overlay = (vec3(1.0) - ((outterCircle - innerCircle) * 0.25)) * 0.8;

    vec2 coord = rotateUV(uv_coord, PI * u_outterAngle);
    vec4 tex1 = texture2D(colorMap, coord);

    coord = rotateUV(uv_coord, PI * u_middleAngle);
    vec4 tex2 = texture2D(colorMap, coord);

    coord = rotateUV(uv_coord, PI * u_innerAngle);
    vec4 tex3 = texture2D(colorMap, coord);

    vec4 step1 = mix(tex2, tex3, innerCircle.x);
    vec4 step2 = mix(tex1, step1, outterCircle.x);
    
    gl_FragColor = step2 * vec4(overlay, 1.0);
}