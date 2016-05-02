class Point
{
  float x, y;
  PVector position;
  PVector beginPosition;
  boolean sticked = false;

  Point(int x, int y)
  {
    position = new PVector (x, y);
    beginPosition = position.get();
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
    popStyle();
  }


  void lookup()
  {
    // here we simply warp points 
    
    if (position.dist(P)<10 && !quad.polygonLockedToMouse) 
    {
      stroke(255, 0, 0);
      if (mousePressed && ! quad.pointLockedToMouse )
      {
        sticked = true;
        quad.pointLockedToMouse = true; // here we lock to mouse so other 3 points won't stick to the mouse
      }
    } else stroke(0);
  }

  void updatePosition()
  {
    if (sticked) 
    {
      position.set(P);
    }
  }
}

