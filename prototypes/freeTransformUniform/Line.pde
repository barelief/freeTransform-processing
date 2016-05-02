class Line 
{

  // update all lines based on all points

  PVector start, end, X, offsetX; 
  float dot; // dot producs
  int lineColor = 0;
  int sensitivity = 20; // how close the mouse shold be to the line
  PVector beginStart, beginEnd, beginX; // saving the position of start and end line points before dragging the mouse
  int id; // id of a line on a quad, see drawing to understand the id in an array of four lines: http://i.imgur.com/iyZVj78.jpg

  Line(PVector _start, PVector _end, int id_) 
  {
    start = _start;
    end   = _end;
    beginStart = new PVector();
    beginEnd = new PVector();
    id=id_;
    setup();
  }

  Line(PVector _start, PVector _end) {
    start = _start;
    end   = _end;
    setup();
  }

  void setup()
  {
    X = new PVector();

    // init offset vars
    offsetX = new PVector();

    beginStart = new PVector();
    beginEnd = new PVector();
    beginX = new PVector();

    beginStart.set(start); 
    beginEnd.set(end);
    beginX.set(X);
  }

  // find dot product - this one is very important :)
  void detectX() 
  {
    PVector AP = PVector.sub(P, beginStart);
    PVector AB = PVector.sub(beginEnd, beginStart);

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
    if (pointCloseToLine() && !quad.dragLock && quad.state != State.POINT) // if mouse is close enough
    {
      lineColor = color(255, 255, 0); // then draw yellow 
      quad.selectedLine = id; // if this line is being selected make global selectedLine from this id
    } else lineColor = 0; // else draw black (if mouse is far from line)

    if (quad.selectedLine == id && quad.dragLock && quad.state == State.EDGE) // darw green line when dragging and while State.EDGE
        lineColor = color(0, 255, 0);

    stroke(lineColor);
  }

  void resetLockPoints()
  {
    // make lock points (beginStart,beginEnd,beginX,beginP) same as original (A,B,X,P)
    // beginP.set(P); // lock the beginning position of the offset vector
    beginStart.set(start); // lock the beginning of the vector A to be transformed
    beginEnd.set(end); // lock the beginning of the vector B to be transformed

      detectX(); // find X, otherwise beginX will be (0,0) ;)
    beginX.set(X); // lock the beginning of the vector X to be transformed
  }


  //  ko gero sito net nereikia, cia is raw prototipo

  void checkInteraction()
  {
    resetLockPoints();  
    if (pointCloseToLine())
    {
      // quad.mouseLockedToLine = true;
      print("YES..");
    } else print("NO..");
    // if (mouseLockedToLine) topLock = true;
  }

  void drag()
  {
    // offsetX = PVector.sub(X, beginX); // calculate the offset made by X

    if (quad.selectedLine == id)
    {
      updateGlobalPoints();
      lineColor = color(0, 255, 0);
      start = PVector.add(beginStart, quad.offset); // reposition point A based the offset made by P
      end = PVector.add(beginEnd, quad.offset); // reposition point B based the offset made by P
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
      text("beginX",beginX.x, beginX.y);
    }
  }

  // update two global points based on currently dragged line (by using global var - selectedLine)
  void updateGlobalPoints()
  {
    if (quad.selectedLine == id) // detect which line in lines array will be updated
    {
      // update global points while dragging the line or it's separate points  
      quad.point[quad.neighborPointsFromLine(id)[1]].position.set(start); // right neighbor [1]
      quad.point[quad.neighborPointsFromLine(id)[0]].position.set(end); // left neighbor [0]
    }
  }

  void draw() 
  {
    detectX();
    // update();
    render();
    // debug();
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

  void debug()
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
}

