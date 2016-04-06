/**
*
* Line class used to display and update all lines based on all points coordinates.
* If lines are being updated interactively, points update respectively
*
* @author Bartosh Polonski
* @version 0.prototype
* @since 2015-09-13
* 
*/

public class Line
{
  PVector start; // begin point of the line
  PVector end; // end point of the line
  PVector X; // mouse-line projection (perpendicular) point (http://i.imgur.com/IAnNlaH.jpg)
  PVector offsetX, beginOffsetX; // how much X offset was made while dragging mouse
  float dot; // dot producs to be calculated
  int lineColor = 0; 
  int sensitivity = 20; // how close the mouse should be to the line
  PVector beginStart, beginEnd, beginX; // saving the position of start and end line points before dragging the mouse
  int id; // id of a line on a quad, see drawing to understand the id in an array of four lines: http://i.imgur.com/iyZVj78.jpg
  boolean isOnThisSideOfLine = false; // check on which side of line is mouse

  // constructor 1
  Line(PVector _start, PVector _end, int id_) 
  {
    start = _start;
    end   = _end;
    beginStart = new PVector();
    beginEnd = new PVector();
    id=id_;
    setup();
  }

   // constructor 2 (simplified (temp) lines)
  Line(PVector _start, PVector _end) {
    start = _start;
    end   = _end;
    setup();
  }

  // Set-up init vars
  void setup()
  {
    X = new PVector();

    // init offset vars
    offsetX = new PVector();

    beginStart = new PVector();
    beginEnd = new PVector();
    beginX = new PVector();
    beginOffsetX = new PVector();

    beginStart.set(start); 
    beginEnd.set(end);
    beginX.set(X);
  }

  // find dot product - this one is very important, does all the tricks :)
  void detectX(PVector P_) 
  {
    PVector AP = PVector.sub(P_, beginStart); // 
    PVector AB = PVector.sub(beginEnd, beginStart); // 

    // find dot product:
    // http://forum.processing.org/two/discussion/11420/#Comment_45987

    dot = PVector.dot(AB, AP);
    dot /= (AB.mag() * AB.mag()); // magic!

    // X is partway along AB

    X.set(AB.x, AB.y, 0);
    X.mult(dot);
    X.add(beginStart);

    offsetX = PVector.sub(X, beginX); // calculate the offset made by X
  }

  // check if mouse is close to the line
  boolean pointCloseToLine()
  {
    if (dot>0 && dot<1 && P.dist(X) < sensitivity) 
    return true;
    else return false;
  }

  void debugPointColors()
  {
    if (pointCloseToLine() && !quad.dragLock && quad.state != State.DRAG_FREE_POINT) // if mouse is close enough
    {
      lineColor = color(255, 255, 0); // then draw yellow 
      quad.selectedLine = id; // if this line is being selected make global selectedLine from this id
    } else lineColor = 0; // else draw black (if mouse is far from line)

    if (quad.selectedLine == id && quad.dragLock && quad.state == State.DRAG_FREE_LINE) // darw green line when dragging and while State.EDGE
    lineColor = color(0, 255, 0);

    stroke(lineColor);
  }

  void resetLockPoints(PVector P_)
  {
    // make lock points (beginStart,beginEnd,beginX,beginP) same as original (A,B,X,P)
    // beginP.set(P); // lock the beginning position of the offset vector
    beginStart.set(start); // lock the beginning of the vector A to be transformed
    beginEnd.set(end); // lock the beginning of the vector B to be transformed

    detectX(P_); // find X, otherwise beginX will be (0,0) ;)
    beginX.set(X); // lock the beginning of the vector X to be transformed
  }

  void drag()
  {
    // offsetX = PVector.sub(X, beginX); // calculate the offset made by X

    // detect which line in lines array will be updated
    if (quad.selectedLine == id)
    {
      quad.updateGlobalPoints(id);
      lineColor = color(0, 255, 0);
      start = PVector.add(beginStart, quad.offsetP); // reposition point A based the offset made by P
      end = PVector.add(beginEnd, quad.offsetP); // reposition point B based the offset made by P
    }
  }

  void render()
  {
    debugPointColors();
    // checkInteraction();
    // drag();
    line(start.x, start.y, end.x, end.y);
    if (quad.debugMode)
    {
      text("X", X.x, X.y);
      text("beginX", beginX.x, beginX.y);
    }
  }

  void draw() 
  {
    detectX(P);
    // update();
    render();
    // displayDebugInformation();
  }

  void set(PVector _start, PVector _end)
  {
    start = _start;
    end   = _end;
  }

  void set_start(PVector _start) {
    start = _start;
  }

  void set_end(PVector _end) {
    end = _end;
  }

  PVector get_start() {
    return start;
  }

  PVector get_end() {
    return end;
  }
  
  // display debug information
  void displayDebugInformation()
  {
    text("dot(AB, AP): "+dot, 40, 40);
    text("ab dist: "+(int)start.dist(end), 40, 60);
    text("sensitivity: "+sensitivity, 40, 80);
    text("offsetX: "+(int)offsetX.mag(), 40, 120);

    text("begin", start.x, start.y+20);
    text("end", end.x, end.y+20);
    text("P", P.x, P.y-10);
    text("X", X.x+10, X.y+10);

    text("beginStart", beginStart.x+10, beginStart.y);
    text("beginEnd", beginEnd.x+10, beginEnd.y);
    // text("beginX", beginX.x+10, beginX.y);
    // text("beginP", beginP.x+10, beginP.y);

    stroke(255);
    rectMode(CENTER);

    rect(beginStart.x, beginStart.y, 5, 5);
    rect(beginEnd.x, beginEnd.y, 5, 5);
    rect(beginX.x, beginX.y, 5, 5);


    // draw normal
    if (pointCloseToLine())
    line(X.x, X.y, P.x, P.y);

    // draw X point

    stroke(255);
    rect(X.x, X.y, 5, 5);
  }

  // line_itersection function is neede to find a center of the polygon
  // http://www.openprocessing.org/sketch/135314

  PVector line_itersection(Line one, Line two)
  {
    float x1 = one.get_start().x;
    float y1 = one.get_start().y;
    float x2 = one.get_end().x;
    float y2 = one.get_end().y;

    float x3 = two.get_start().x;
    float y3 = two.get_start().y;
    float x4 = two.get_end().x;
    float y4 = two.get_end().y;

    float bx = x2 - x1;
    float by = y2 - y1;
    float dx = x4 - x3;
    float dy = y4 - y3;

    float b_dot_d_perp = bx * dy - by * dx;

    if (b_dot_d_perp == 0) return null;

    float cx = x3 - x1;
    float cy = y3 - y1;

    float t = (cx * dy - cy * dx) / b_dot_d_perp;
    if (t < 0 || t > 1) return null;

    float u = (cx * by - cy * bx) / b_dot_d_perp;
    if (u < 0 || u > 1) return null;

    return new PVector(x1+t*bx, y1+t*by);
  }

  PVector intersects_at(Line other)
  {
    return line_itersection(this, other);
  }
  
    // check on which side of line is the mouse (P)ointer
  boolean checkLineSide(PVector P)
  {
    boolean oneSide = true;
    PVector v1 = new PVector(end.x-start.x, end.y-start.y); 
    PVector v2 = new PVector(end.x-P.x, end.y-P.y);

    float xp = v1.x*v2.y - v1.y*v2.x;

    if (xp > 0)
    {
      text( "on one side", 20, 20);
      oneSide = true;
    } else if (xp < 0)
    {
      text( "on the other", 20, 20);
      oneSide = false;
    }
    return oneSide;
  }
}