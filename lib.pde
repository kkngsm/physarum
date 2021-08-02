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
    PVector center = new PVector(pg.width/2, pg.height/2);
    float distance = PVector.dist(center, pos);
    if(distance < pupil_size+pupil_around_size){
      float weight = (distance-pupil_size)/pupil_around_size;
      
      sense(prev_pixels, 
      theta*weight + pupil_angle*(1-weight), 
      dist *weight + pupil_dist*(1-weight));
      pos = PVector.add(pos, new PVector(sin(angle), cos(angle)).mult( move_speed*weight + pupil_speed*(1-weight)));
    }else{
      sense(prev_pixels, theta, dist);
      pos = PVector.add(pos, new PVector(sin(angle), cos(angle)).mult(move_speed));
    }
    
    if(distance < pupil_size){
      angle = atan2(pos.x-center.x, pos.y - center.y);
    }else if(distance > pupil_size+iris_size){
      angle = atan2(pos.x-center.x, pos.y - center.y) + PI;
    }
  }
  
  void draw(color[] pixels){
    int px = X((int)pos.x, (int)pos.y);
    int red = pixels[px] >> 16 & 0xFF;
    pixels[px] = color(min(red + 100, 255));
  }
}

int X(int x, int y){
  return (((x % pg.width) + pg.width) % pg.width)+pg.width*(((y % pg.height) + pg.height) % pg.height);
}
