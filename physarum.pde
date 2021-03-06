import controlP5.*;

final int PARTICLE_NUM = 100000;

Particle p[];

ControlP5 GUI;
float sensor_angle = 0.3;
float sensor_dist = 5;
float move_speed = 0.5;

int sliderValue;
PShader filter_shader;
PGraphics pg;
void setup(){
  size(1000,1000,P2D);
  pg = createGraphics(500,500,P2D);
  p = new Particle[PARTICLE_NUM];
  
  for(int i = 0; i< PARTICLE_NUM; i++){
    p[i]= new Particle(new PVector(random(1)*pg.width, random(1)*pg.height), random(1)*PI*2);
  }
  filter_shader = loadShader("filter.glsl");
  background(0);
  filter_shader.set("_iResolution", (float)pg.width, (float)pg.height);
  filter_shader.set("_Decay", 0.1);
  
  GUI = new ControlP5(this);
  int y = 1;
  GUI.addSlider("sensor_angle")
    .setRange(0, PI*0.5)
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
  //if(frameCount < 600){
  //  pg.save(frameCount + ".png");
  //}else{
  //      exit();
  //}
  
}

void keyPressed(){
  if(key=='\n'){
    save(frameCount+".png");
    println("saved!");
  }else{
    setup();
  }
}
