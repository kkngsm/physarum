import controlP5.*;

final int PARTICLE_NUM = 100000;

Particle p[];

ControlP5 GUI;
float sensor_angle = 0.32;
float sensor_dist = 3.7;
float move_speed = 1.12;

float pupil_angle = 0.83;
float pupil_dist = 6.39;
float pupil_speed = 0.95;

float Inward_force = 0.01;
float rate_to_reset = 0.01;

float pupil_size;
float pupil_around_size;
float iris_size;

int sliderValue;
PShader filter_shader;
PGraphics pg;

PVector CENTER;
void setup(){
  size(1000,1000,P2D);
  pg = createGraphics(500,500,P2D);
  p = new Particle[PARTICLE_NUM];
  
  pupil_size = pg.width*0.1;
  pupil_around_size = pg.width*0.1;
  iris_size = pg.width*0.4;
  
  for(int i = 0; i< PARTICLE_NUM; i++){
    float ang = random(1)*PI*2;
    float dist = random(1)*iris_size+pupil_size;
    p[i]= new Particle(new PVector(sin(ang)*dist+pg.width/2, cos(ang)*dist+pg.height/2), random(1)*PI*2);
  }
  filter_shader = loadShader("filter.glsl");
  background(0);
  filter_shader.set("_iResolution", (float)pg.width, (float)pg.height);
  filter_shader.set("_Decay", 0.1);
  
  GUI = new ControlP5(this);
  int y = 1;
  GUI.addSlider("sensor_angle")
    .setRange(0, PI)
    .setPosition(50, 20*(y++))
    .setSize(200, 15);
  GUI.addSlider("sensor_dist")
    .setRange(0, 20)
    .setPosition(50, 20*(y++))
    .setSize(200, 15);
  GUI.addSlider("move_speed")
    .setRange(0, 5)
    .setPosition(50, 20*(y++))
    .setSize(200, 15);
  y++;
  GUI.addSlider("pupil_angle")
    .setRange(0, PI)
    .setPosition(50, 20*(y++))
    .setSize(200, 15);
  GUI.addSlider("pupil_dist")
    .setRange(0, 20)
    .setPosition(50, 20*(y++))
    .setSize(200, 15);
  GUI.addSlider("pupil_speed")
    .setRange(0, 5)
    .setPosition(50, 20*(y++))
    .setSize(200, 15);
  y++;
  GUI.addSlider("Inward_force")
    .setRange(0, 0.1)
    .setPosition(50, 20*(y++))
    .setSize(200, 15);
  GUI.addSlider("rate_to_reset")
    .setRange(0, 0.05)
    .setPosition(50, 20*(y++))
    .setSize(200, 15);

  CENTER = new PVector(pg.width/2, pg.height/2);
}
void draw(){
  color[] prev_pixels = new color[pg.width*pg.height];
  filter_shader.set("_Tex", pg.get());
  pg.beginDraw();
  pg.shader(filter_shader);
  pg.rect(0, 0, pg.width, pg.height);
  pg.resetShader();

  pg.loadPixels();
  arrayCopy(pg.pixels, prev_pixels);
  for(int i = 0; i< PARTICLE_NUM; i++){
    p[i].move(prev_pixels, sensor_angle, sensor_dist);
    p[i].draw(pg.pixels);
  }
  pg.updatePixels();
  pg.endDraw();
  image(pg, 0, 0, width, height);
  //pg.save(frameCount + ".png");
}

void keyPressed(){
  if(key=='\n'){
    save(frameCount+".png");
    println("saved!");
  }else{
    setup();
  }


}
