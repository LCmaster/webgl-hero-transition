#define PI 3.14159265359

varying vec2 vUv;

uniform float u_opacity;
uniform sampler2D colorMap;
uniform vec2 u_imageResolution;
uniform vec2 u_screenResolution;

uniform float u_zoom;
uniform float u_innerAngle;
uniform float u_middleAngle;
uniform float u_outterAngle;

uniform float u_imageAspectRatio;
uniform float u_screenAspectRatio;

float map(float value,float inMin,float inMax,float outMin,float outMax){
  return outMin+(outMax-outMin)*(value-inMin)/(inMax-inMin);
}

vec2 map(vec2 value,vec2 inMin,vec2 inMax,vec2 outMin,vec2 outMax){
  return outMin+(outMax-outMin)*(value-inMin)/(inMax-inMin);
}

vec3 map(vec3 value,vec3 inMin,vec3 inMax,vec3 outMin,vec3 outMax){
  return outMin+(outMax-outMin)*(value-inMin)/(inMax-inMin);
}

float circle(vec2 position,float radius){
  vec2 screenAspectRatio=vec2(u_screenAspectRatio,1.);
  return step(radius,distance(position*screenAspectRatio,vec2(.5*screenAspectRatio)));
}

vec2 rotateUV(vec2 uv_coord,float angle){
  vec2 screenAspectRatio=vec2(u_screenAspectRatio,1.);
  vec2 coord=uv_coord;
  float sin_factor=sin(angle);
  float cos_factor=cos(angle);
  coord-=.5;
  coord=coord*mat2(cos_factor,sin_factor,-sin_factor,cos_factor);
  coord+=.5;
  return coord;
}

void main(){
  // =================================== //
  // === Centered Concentric Circles === //
  // =================================== //
  vec3 innerCircle=vec3(map(circle(vUv,.3),0.,1.,1.,0.));
  vec3 outterCircle=vec3(map(circle(vUv,.75),0.,1.,1.,0.));
  
  vec3 overlay=map((outterCircle-innerCircle)*.25,vec3(0.),vec3(1.),vec3(1.),vec3(0.));
  
  // =================================== //
  // =========== Texture UVs =========== //
  // =================================== //
  float lowerBound=u_zoom-1.;
  float upperBound=2.-u_zoom;
  vec2 uv_coord=map(vUv,vec2(0.),vec2(1.),vec2(lowerBound),vec2(upperBound));
  
  vec2 coord=rotateUV(uv_coord,-PI*2.*u_innerAngle);
  vec4 tex1=texture2D(colorMap,coord);
  
  coord=rotateUV(uv_coord,-PI*2.*u_middleAngle);
  vec4 tex2=texture2D(colorMap,coord);
  
  coord=rotateUV(uv_coord,-PI*2.*u_outterAngle);
  vec4 tex3=texture2D(colorMap,coord);
  
  vec4 step1=mix(tex3,tex2,outterCircle.x);
  vec4 step2=mix(step1,tex1,innerCircle.x);
  
  gl_FragColor=vec4(step2.xyz*overlay,u_opacity);
}