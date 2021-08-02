class Particle{
  PVector pos;
  float angle;
  
  Particle(PVector _pos, float _angle){
    pos = _pos;
    angle = _angle;
  }
  
  PVector get_sense_pos(float theta, float dist){
    return PVector.add(pos, new PVector(sin(angle+theta), cos(angle+theta)).mult(dist));
  }
  
  void sense(color[] prev_pixels, float theta, float dist){
    
    PVector front = get_sense_pos(0, dist);
    PVector left = get_sense_pos(theta, dist);
    PVector right = get_sense_pos(-theta, dist);
    color fcol = prev_pixels[X((int)front.x, (int)front.y)];
    color lcol = prev_pixels[X((int)left.x, (int)left.y)];
    color rcol = prev_pixels[X((int)right.x, (int)right.y)];
    int fred = fcol >> 16 & 0xFF;
    int lred = lcol >> 16 & 0xFF;
    int rred = rcol >> 16 & 0xFF;
    if(lred > fred && fred < rred){
        angle += ceil(random(2)-1)*theta;
    }else if(lred < fred && fred < rred){
        angle -= theta;
    }else if(lred > fred && fred > rred){
        angle += theta;
    }
  }
  
  
  void move(color[] prev_pixels, float theta,  float dist){

    float distance = PVector.dist(CENTER, pos);

    if(distance < pupil_size){
      reset();
    }else if(distance < pupil_size+pupil_around_size){
      if(random(1) < rate_to_reset){
         reset(); 
      }
      float weight = (distance-pupil_size)/pupil_around_size;
      
      sense(prev_pixels, 
      theta*weight + pupil_angle*(1-weight), 
      dist *weight + pupil_dist*(1-weight));
      pos = PVector.add(pos, new PVector(sin(angle), cos(angle)).mult( move_speed*weight + pupil_speed*(1-weight)));
    }else{
      if(random(1) < rate_to_reset*0.5){
         reset(); 
      }
      sense(prev_pixels, theta, dist);
      pos = PVector.add(pos, new PVector(sin(angle), cos(angle)).mult(move_speed));
      float x = lerp(sin(angle), CENTER.x - pos.x, Inward_force);
      float y = lerp(cos(angle), CENTER.y - pos.y, Inward_force);
      angle = atan2(x, y);
    }


    if(distance < pupil_size || (distance <  pupil_size+pupil_around_size && random(1) < rate_to_reset)){

    }
  }
  
  void draw(color[] pixels){
    int px = X((int)pos.x, (int)pos.y);
    int red = pixels[px] >> 16 & 0xFF;
    pixels[px] = color(min(red + 100, 255));
  }
  
  void reset(){
    float rand = (random(1)-0.5)*PI*4;
    PVector p = new PVector(sin(rand), cos(rand)).normalize();
    pos = p.mult(pupil_size+iris_size).add(CENTER);
    angle = random(1) * PI * 2; 
  }
}

int X(int x, int y){
  return (((x % pg.width) + pg.width) % pg.width)+pg.width*(((y % pg.height) + pg.height) % pg.height);
}
