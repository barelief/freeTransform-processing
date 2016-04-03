/**
*
* Point class contains information of the single poind and methods to rotate or transform it
*
* @author Bartosh Polonski
* @version 0.prototype
* @since 2015-09-13
* 
*/

class Point
{
  float x, y; // this is additiona float for easier coordienate reading from outside the class (i.e. A.x instead A.position.x)
  PVector position; // actual position vector
  PVector beginPosition; // this is the lock state of the postion, it's used when starting calculating offset vector to understand the starting point of the transformation
  boolean sticked = false; // is this point sticked to mouse?

  // rotation transformations
  PVector tmp; // temporary copy of the postion vector neede for the rotation transformations

  float angle=0; // 
  float startAngle=0; // 

  float offsetAngle=0; //
  float startOffsetAngle=0; // 

  int sensitivity= 30; // how close mouse should be to start interaction

  int id; // point id, we use this id to update quad.selectedPoint

  // constructor
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

  // reset the begin position
  void reset()
  {
    beginPosition = position.get();
  }

  void render()
  {
    rectMode(CENTER);
    pushStyle();
    noFill();

    // make the right colouring: black when not in focus, yellow when focused, green while dragging
    if (isFocusedOnThePoint()) 
    {
      if (!quad.dragLock) {
        stroke(255, 255, 0);
        quad.selectedPoint = id;
      } else 
      {
        stroke(0, 255, 0);
      }
    } else stroke(0);

    rect(x, y, 5, 5);
    popStyle();
  }
  
  // checks is mouse is close enough to the point
  boolean isFocusedOnThePoint()
  {
    if (position.dist(P)<sensitivity) 
      return true; 
    else return false;
  }
  
  // begin rotation process, lock initial positions
  // THIS METHOD NEED EXPLAINING DRAWING! (even if it works perfectly :)
  void startRotating()
  {
    startOffsetAngle = quad.anchorLine.heading(); // lock initial offset angle 
    beginPosition.set(position); // lock position A and save it to beginPosition vector
    tmp = PVector.sub(beginPosition, quad.lockAnchor); // create temporarary vector to contain infomation 
    startAngle  = tmp.heading(); //
  }
  
  // rotate the point around the anchor
  void rotate()
  {
    offsetAngle = quad.anchorLine.heading() - startOffsetAngle; // rotate offset made beginning with 0 (mousePressed), ending with final mouseDragged
    angle = startAngle + offsetAngle; // final rotation amount
    tmp = PVector.sub(beginPosition, quad.lockAnchor); // create temporary (absolute position) vector from anchor to point A
    tmp.rotate(-tmp.heading()); // back to initial position
    tmp.rotate(angle); // add your desired rotation amount
    tmp.add(quad.lockAnchor); // position vector back to it's place on the screen
    position.set(tmp); // update original vector based on transformed temporary vector
  }

  // drag the point with amount of offsetP
  void drag()
  {
    if (sticked) 
    {
      position = PVector.add(beginPosition, quad.offsetP); // reposition point based the offset made by P
    }
  }
}

