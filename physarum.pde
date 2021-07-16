final int PARTICLE_NUM = 100000;

Particle p[];

float sensor_angle = 0.3;
float sensor_dist = 5;
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
}

void keyPressed(){
  setup();
}
