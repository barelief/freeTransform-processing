 class Line
{
  // basic vars
  PVector A, B, X;
  float dot;
  int lineColor = 0;
  boolean debugMode = false;
  int sensitivity = 5;

  int id; // # of line A is 0, B is 1, C is 2, D is 3

  // offset / lock vars

  PVector offsetX; // X offset


  PVector beginA; // lock the initial A point position, from which transformatin is made
  PVector beginB; // lock the initial B point position, from which transformatin is made
  PVector beginX; // lock the initial X point position, from which transformatin is made

  // interaction / lock vars
  boolean mouseLockedToLine = false;
  boolean mouseLockedToA = false;
  boolean mouseLockedToB = false;
  boolean scaleMode = false; 
  boolean freeMode = true;

  Line()
  {
    A = new PVector(random(width), random(height));
    B = new PVector(random(width), random(height));
    setup();
  }

  Line(PVector A_, PVector B_)
  {
    A = new PVector(A_.x, A_.y);
    B = new PVector(B_.x, B_.y);
    setup();
  }

  void draw() {


    update();
    render();
  }

  void update() 
  {
    PVector AP = PVector.sub(P, beginA);
    PVector AB = PVector.sub(beginB, beginA);

    dot = PVector.dot(AB, AP);
    dot /= (AB.mag() * AB.mag()); // magic!

    // X is partway along AB

    X.set(AB.x, AB.y, 0);
    X.mult(dot);
    X.add(beginA);
  }

  void render() 
  {
    
    // rendering part
    //if (!topLock)
    debugPointColors();

    if (debugMode) debug();
  }

  void setup()
  {
    X = new PVector();

    // init offset vars
    offsetX = new PVector();
  
    beginA = new PVector();
    beginB = new PVector();
    beginX = new PVector();
    
    beginA.set(A); 
    beginB.set(B);
    beginX.set(X);
  }

  void debugPointColors()
  {

    if (!mouseLockedToLine) // if we didn't start dragging yet
    {
      if (pointCloseToLine() && !pointCloseToA() && !pointCloseToB()) // if mouse is close enough
        lineColor = color(255, 255, 0); // then draw yellow 
      else lineColor = 0; // else draw black (if mouse is far from line)
    }

    stroke(lineColor);

    line(A.x, A.y, B.x, B.y);

    noFill();
    rectMode(CENTER);

    // A coloring
    if (mouseLockedToA) // if I am already dragging point A
    {
      stroke(0, 255, 0);
    } else  
    if (pointCloseToA()) // if mouse is over point A (but not dragging yet)
      stroke(255, 255, 0); 
    else stroke(0); // if no interaction
    rect(A.x, A.y, 5, 5);

    // B coloring

    if (mouseLockedToB) // if I am already dragging point B
    {
      stroke(0, 255, 0);
    } else  
    if (pointCloseToB()) // if mouse is over point B (but not dragging yet)
      stroke(255, 255, 0); 
    else stroke(0); // if no interaction
    rect(B.x, B.y, 5, 5);
  }

  // check if mouse is close to the line
  boolean pointCloseToLine()
  {
    if (dot>0 && dot<1 && P.dist(X) < sensitivity) 
      return true;
    else return false;
  }

  // check if mouse is close to the point A
  boolean pointCloseToA()
  {
    if (P.dist(A) < sensitivity)
      return true;
    else return false;
  }

  // check if mouse is close to the point B
  boolean pointCloseToB()
  {
    if (P.dist(B) < sensitivity)
      return true;
    else return false;
  }

  void resetLockPoints()
  {
    // make lock points (beginA,beginB,beginX,beginP) same as original (A,B,X,P)
    beginP.set(P); // lock the beginning position of the offset vector
    beginA.set(A); // lock the beginning of the vector A to be transformed
    beginB.set(B); // lock the beginning of the vector B to be transformed
    beginX.set(X); // lock the beginning of the vector X to be transformed
  }

  void checkInteraction()
  {
    resetLockPoints();  

    if (!topLock)
    {
      if (pointCloseToA())
      {
        mouseLockedToA = true;
      } else if (pointCloseToB())
      {
        mouseLockedToB = true;
      } else
        if (pointCloseToLine())
        {
          mouseLockedToLine = true;
        }
    }
    if (mouseLockedToA || mouseLockedToB || mouseLockedToLine) topLock = true;
  }

  // release all locks
  void release()
  {
    mouseLockedToLine = false;
    mouseLockedToA = false;
    mouseLockedToB = false;
    freeMode = true;
    topLock = false;
    resetLockPoints();
  }

  void drag()
  {
    offsetX = PVector.sub(X, beginX); // calculate the offset made by X

    if (mouseLockedToLine)
    {
      lineColor = color(0, 255, 0);
      A = PVector.add(beginA, offsetP); // reposition point A based the offset made by P
      B = PVector.add(beginB, offsetP); // reposition point B based the offset made by P
    }

    if (mouseLockedToA)
    {
      if (freeMode)
        A = PVector.add(beginA, offsetP); // reposition point A based the offset made P
      else 
      A = PVector.add(beginA, offsetX); // reposition point A based the offset made by X
    }

    if (mouseLockedToB)
    {
      if (freeMode)
      {

        B = PVector.add(beginB, offsetP); // reposition point B based the offset made by P
      } else

        B = PVector.add(beginB, offsetX); // reposition point B based the offset made by X
    }
  }

  void debug()
  {
    text("dot(AB, AP): "+dot, 40, 40);
    text("ab dist: "+(int)A.dist(B), 40, 60);
    text("sensitivity: "+sensitivity, 40, 80);
    text("offsetP: "+(int)offsetP.mag(), 40, 100);
    text("offsetX: "+(int)offsetX.mag(), 40, 120);

    text("A", A.x, A.y+20);
    text("B", B.x, B.y+20);
    text("P", P.x, P.y-10);
    text("X", X.x+10, X.y+10);

    text("beginA", beginA.x+10, beginA.y);
    text("beginB", beginB.x+10, beginB.y);
    // text("beginX", beginX.x+10, beginX.y);
    // text("beginP", beginP.x+10, beginP.y);

    stroke(255);
    rectMode(CENTER);
    rect(beginA.x, beginA.y, 5, 5);
    rect(beginB.x, beginB.y, 5, 5);
    rect(beginX.x, beginX.y, 5, 5);
    rect(beginP.x, beginP.y, 5, 5);

    // draw normal
    if (pointCloseToLine())
      line(X.x, X.y, P.x, P.y);

    // draw X point
    if (!pointCloseToLine() && !pointCloseToB() && !pointCloseToA() && !mouseLockedToB && !mouseLockedToA)
    {
      stroke(255);
      rect(X.x, X.y, 5, 5);
    }
  }
}