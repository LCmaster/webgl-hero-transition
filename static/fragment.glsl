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

float circle(vec2 position,float radius){
  return map(step(radius,length(position)),0.,1.,1.,0.);
}

vec2 rotateUV(vec2 uv_coord,float angle){
  vec2 coord=uv_coord;
  float sin_factor=sin(angle);
  float cos_factor=cos(angle);
  coord-=.5;
  coord=coord*mat2(cos_factor,sin_factor,-sin_factor,cos_factor);
  coord+=.5;
  return coord;
}

float getScaleFactor(float screenWidth,float screenHeight,float imageWidth,float imageHeight){
  float scaleFactor;
  
  if(u_screenAspectRatio>u_imageAspectRatio){
    scaleFactor=screenWidth/imageWidth;
  }else{
    scaleFactor=screenHeight/imageHeight;
    
  }
  
  return scaleFactor;
}

void main(){
  float scaleFactor=getScaleFactor(u_screenResolution.x,u_screenResolution.y,u_imageResolution.x,u_imageResolution.y);
  
  // =================================== //
  // === Centered Concentric Circles === //
  // =================================== //
  vec2 screenAspectRatio=vec2(u_screenAspectRatio,1.);
  vec2 pos=gl_FragCoord.xy/u_screenResolution.xy;
  // pos*=scaleFactor;
  pos-=.5;
  pos*=screenAspectRatio;
  
  vec3 innerCircle=vec3(circle(pos,.25));
  vec3 outterCircle=vec3(circle(pos,.75));
  
  vec3 overlay=(vec3(1.)-((outterCircle-innerCircle)*.25))*.8;
  
  // =================================== //
  // =========== Texture UVs =========== //
  // =================================== //
  float lowerBound=u_zoom-1.;
  float upperBound=2.-u_zoom;
  vec2 uv_coord=map(vUv,vec2(0.),vec2(1.),vec2(lowerBound),vec2(upperBound));
  
  vec2 coord=rotateUV(uv_coord,-PI*2.*u_outterAngle);
  vec4 tex1=texture2D(colorMap,coord);
  
  coord=rotateUV(uv_coord,-PI*2.*u_middleAngle);
  vec4 tex2=texture2D(colorMap,coord);
  
  coord=rotateUV(uv_coord,-PI*2.*u_innerAngle);
  vec4 tex3=texture2D(colorMap,coord);
  
  vec4 step1=mix(tex2,tex3,innerCircle.x);
  vec4 step2=mix(tex1,step1,outterCircle.x);
  
  gl_FragColor=step2*vec4(overlay,u_opacity);
}