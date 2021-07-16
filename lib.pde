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
  
  
  void move(color[] prev_pixels, float theta, float dist){
    sense(prev_pixels, theta, dist);
    pos = PVector.add(pos, new PVector(sin(angle), cos(angle)).mult(0.5));
  }
  
  void draw(color[] pixels){
    int px = X((int)pos.x, (int)pos.y);
    
    int red = pixels[px] >> 16 & 0xFF;
    pixels[px] = color(min(red + 80, 255));
  }
}

int X(int x, int y){
  return (((x % width) + width) % width)+width*(((y % height) + height) % height);
}
