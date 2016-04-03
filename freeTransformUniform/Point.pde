class Point
{
  float x, y; // this is additiona float for easier coordienate reading from outside the class (i.e. A.x, B.y etc)
  PVector position; // actual position vector
  PVector beginPosition; // this is the lock state of the postion, it's used when starting calculating offset vector to understand the starting point of the transformation
  PVector offsetPosition; // 
  boolean sticked = false; // is this point sticked to mouse?

  // transformations
  PVector tmp; // temporary copy of the postion vector neede for the rotation transformations

  float angle=0; // 
  float startAngle=0; 

  float offsetAngle=0;
  float startOffsetAngle=0;

  int sensitivity= 30;

  int id;

  Point(float x, float y, int id_)
  {
    position = new PVector (x, y);
    beginPosition = position.get();
    tmp = new PVector();
    id = id_;
  }

  void draw()
  {
    update();
    render();
  }

  void update()
  {
    x = position.x;
    y = position.y;
  }

  void reset()
  {
    beginPosition = position.get();
  }

  void render()
  {
    rectMode(CENTER);
    pushStyle();
    noFill();

    // make the right colouring: black when not in focus, yellow when focused, green when dragging
    if (isFocusedOnThePoint()) 
    {
      if (!quad.dragLock) {
        // quad.pointLockedToMouse = true;
        stroke(255, 255, 0);
        quad.selectedPoint = id;
      } else 
      {
        //quad.pointLockedToMouse = false;
        stroke(0, 255, 0);
      }
    } else stroke(0);

    rect(x, y, 5, 5);
    popStyle();
  }

  boolean isFocusedOnThePoint()
  {
    if (position.dist(P)<sensitivity) 
      return true; 
    else return false;
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

  void drag()
  {
    if (sticked) 
    {
      position = PVector.add(beginPosition, quad.offset); // reposition point A based the offset made by P
    }
  }

  void updatePosition()
  {
    if (sticked) 
    {
      position.set(P);
    }
  }
}

