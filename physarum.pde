final int PARTICLE_NUM = 100000;

Particle p[];

float sensor_angle = 0.3;
float sensor_dist = 5;

PShader filter_shader;

void setup(){
  size(500,500, P2D);
  
  p = new Particle[PARTICLE_NUM];
  for(int i = 0; i< PARTICLE_NUM; i++){
    p[i]= new Particle(new PVector(random(1)*width, random(1)*height), random(1)*PI*2);
  }
  filter_shader = loadShader("filter.glsl");
  background(0);
  
  filter_shader.set("_iResolution", (float)width, (float)height);
  filter_shader.set("_Decay", 0.1);
}

void draw(){
  PImage pg = get();
  filter_shader.set("_Tex", pg);

  shader(filter_shader);
  rect(0, 0, width, height);
  resetShader();
  
  color[] prev_pixels = new color[width*height];

  loadPixels();
  arrayCopy(pixels, prev_pixels);
  

  for(int i = 0; i< PARTICLE_NUM; i++){
    p[i].move(prev_pixels, sensor_angle, sensor_dist);
    p[i].draw(pixels);
  }
  updatePixels();
}
