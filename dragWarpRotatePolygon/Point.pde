class Point
{
  float x, y; // made additiona float for easier coordienate reading from outside the class (i.e. A.x, B.y etc)
  PVector position; // actual position vector
  PVector beginPosition; // this is the lock state of the postion, it's used when starting calculating offset vector to understand the starting point of the transformation
  boolean sticked = false; // is this point sticked to mouse?

  // transformations
  PVector tmp; // temporary copy of the postion vector neede for the rotation transformations

  float angle=0; // 
  float startAngle=0; 

  float offsetAngle=0;
  float startOffsetAngle=0;

  int sensitivity= 30;

  Point(int x, int y)
  {
    position = new PVector (x, y);
    beginPosition = position.get();
    tmp = new PVector();
  }

  void draw()
  {
    update();
    lookup();
    render();
  }

  void update()
  {
    x = position.x;
    y = position.y;
  }

  void render()
  {
    rectMode(CENTER);
    pushStyle();
    if (sticked) stroke(0, 255, 0); 
    //else
    //  stroke(25, 25, 200);
    rect(x, y, 5, 5);
    stroke(255, 0, 0);
    //rect(tmp.x, tmp.y, 5, 5);
    // text((int)degrees(angle), x+20, y+10);
    popStyle();
  }


  void lookup()
  {
    // here we simply warp points 

    if (position.dist(P)<sensitivity && !quad.polygonLockedToMouse && !quad.rotationLockedToMouse ) 
    {
      quad.state = State.POINT;
      stroke(255, 0, 0);
      if (mousePressed && ! quad.pointLockedToMouse )
      {
        sticked = true;

        quad.pointLockedToMouse = true; // here we lock to mouse so other 3 points won't stick to the mouse
      }
    } else 
    {
      stroke(0);
    }
  }

  void startRotating()
  {
    startOffsetAngle = quad.anchorLine.heading();
    beginPosition.set(position); // uzlockink A pozicija ir uzseivinka ja i beginPosition vektoriu
    tmp = PVector.sub(beginPosition, quad.lockAnchor);
    startAngle  = tmp.heading();
  }

  void rotate()
  {
    offsetAngle = quad.anchorLine.heading() - startOffsetAngle; // OK kiek isviso rotate offsetas buvo atliktas pradedant nuo 0 (mousePressed) baigiant iki paskutinio moueDragged

    angle = startAngle + offsetAngle; // final rotation amount
    tmp = PVector.sub(beginPosition, quad.lockAnchor); // sukurk laikina (absolute position) vektoriu nuo anchoro iki A tashko 
    tmp.rotate(-tmp.heading()); // grazink i nuline pozicija
    tmp.rotate(angle); // ir dadek savo norima rorate amount
    tmp.add(quad.lockAnchor); // padek vektoriu atgal i vieta ekrane
    position.set(tmp); // updeitink originalu vektoriu pagal transformuota laikin
  }

  void updatePosition()
  {
    if (sticked) 
    {
      position.set(P);
    }
  }
}

