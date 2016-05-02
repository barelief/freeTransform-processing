class Point
{
  float x, y;
  PVector position;
  PVector positionBegin;
  boolean sticked = false;

  Point(int x, int y)
  {
    position = new PVector (x, y);
    positionBegin = position.get();
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

    if (position.dist(P)<10) stroke(255, 0, 0);
    else stroke(0);
    if (mousePressed && !lockedToMouse)
    {
      if (position.dist(P)<10)
      {
        sticked = true;
        lockedToMouse = true;
      }
    }
  }

  void updatePosition()
  {
    if (sticked) 
    {
      position.set(mouseX, mouseY);
      positionBegin = position.get();
    }
  }
}

