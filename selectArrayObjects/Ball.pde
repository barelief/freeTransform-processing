class Ball
{
  int size;
  PVector position;

  //interaction
  boolean isOver=false;
  boolean isLockedToMouse=false;

  Ball(float size_, PVector position_)
  {
    size = (int)size_;
    position = position_;
  }

  void update()
  {
    checkIfPressed();
  }
  
  void draw()
  {
    render();
    update();
    debug();
  }

  // display mouse
  void render()
  {
    if(isOver)fill(89);else fill(99);
    if(isLockedToMouse)fill(69);
    ellipse(position.x, position.y, size, size);
  }
  

  // check how this ball object interacts with the mouse
  void checkIfPressed()
  {
    if (mouse.dist(position)<size/2)
    {
      isOver=true;
    } else 
    {
      isOver=false;
    }
  }
  
  void debug()
  {
    fill(222);
    pushMatrix();
    translate(position.x, position.y);
    text("isOver: "+isOver,0,0);
    text("isLockedToMouse: "+isLockedToMouse,0,20);
    popMatrix();
  }
  // end of class
}

