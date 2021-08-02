import controlP5.*;

final int PARTICLE_NUM = 100000;

Particle p[];

ControlP5 GUI;
float sensor_angle = 0.3;
float pupil_angle = 0.3;
float sensor_dist = 5;
float move_speed = 0.5;

float pupil_size;
float pupil_around_size;
float iris_size;

int sliderValue;
PShader filter_shader;
PGraphics pg;
void setup(){
  size(1000,1000,P2D);
  pg = createGraphics(300,300,P2D);
  p = new Particle[PARTICLE_NUM];
  
  pupil_size = pg.width/8;
  pupil_size = pg.width/8;
  iris_size = pg.width/3;
  
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
  GUI.addSlider("sensor_angle")
    .setRange(0, PI)
    .setPosition(50, 40)
    .setSize(200, 15);
  GUI.addSlider("pupil_angle")
    .setRange(0, PI)
    .setPosition(50, 60)
    .setSize(200, 15);
  GUI.addSlider("sensor_dist")
    .setRange(0, 20)
    .setPosition(50, 80)
    .setSize(200, 15);
  GUI.addSlider("move_speed")
    .setRange(0, 5)
    .setPosition(50, 100)
    .setSize(200, 15);
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
  //setup();
  save(frameCount+".png");
}
