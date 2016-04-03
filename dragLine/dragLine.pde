// dragScaleLine.pde //<>//
// http://forum.processing.org/two/discussion/comment/45987/

// basic vars
PVector A, B, P, X;
float dot;
int lineColor = 0;
boolean debugMode = false;
int sensitivity = 25;

// offset / lock vars
PVector offsetP; // offset made by moving user point P (aka mouse)
PVector offsetX; // X offset
PVector beginP; // offset is being calculated starting from the position when mouse was pressed

PVector beginA; // lock the initial A point position, from which transformatin is made
PVector beginB; // lock the initial B point position, from which transformatin is made
PVector beginX; // lock the initial X point position, from which transformatin is made

// interaction / lock vars
boolean mouseLockedToLine = false;
boolean mouseLockedToA = false;
boolean mouseLockedToB = false;
boolean scaleMode = false; 
boolean freeMode = false;

void draw()
{
  background(100);

  if (!mouseLockedToLine) // if we didn't start dragging yet
  {
    if (pointCloseToLine() && !pointCloseToA() && !pointCloseToB()) // if mouse is close enough
      lineColor = color(255, 255, 0); // then draw yellow 
    else lineColor = 0; // else draw black (if mouse is far from line)
  }

  stroke(lineColor);

  line(A.x, A.y, B.x, B.y);

  PVector AP = PVector.sub(P, beginA);
  PVector AB = PVector.sub(beginB, beginA);

  dot = PVector.dot(AB, AP);
  dot /= (AB.mag() * AB.mag()); // magic!

  P.set(mouseX, mouseY, 0);

  // X is partway along AB

  X.set(AB.x, AB.y, 0);
  X.mult(dot);
  X.add(beginA);

  // rendering part
  debugPointColors();
  showInfo();
  if (debugMode) debug();
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

void showInfo()
{
  text("* drag points or line \n* press and hold CTRL then drag a point to scale the line \n* press 'd' for debug", 40, height-100);
}

void debugPointColors()
{
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

void setup()
{
  size(600, 600);
  // main vars
  P = new PVector();
  X = new PVector();
  A = new PVector(300, 200);
  B = new PVector(400, 300);

  // init offset vars
  offsetP = new PVector();
  offsetX = new PVector();
  beginP = new PVector();
  beginA = new PVector();
  beginB = new PVector();
  beginX = new PVector();

  beginA.set(A); 
  beginB.set(B);
  beginX.set(X);

  noSmooth();
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

    if (pointCloseToLine())
    {
      mouseLockedToLine = true;
    }
}

void mousePressed()
{
  checkInteraction();
}

void mouseDragged()
{
  offsetP = PVector.sub(P, beginP); // calculate the offset made by P
  offsetX = PVector.sub(X, beginX); // calculate the offset made by X

  if (mouseLockedToLine)
  {
    lineColor = color(0, 255, 0);
    A = PVector.add(beginA, offsetP); // reposition point A based the offset made by P
    B = PVector.add(beginB, offsetP); // reposition point B based the offset made by P
  }
}

// release all locks
void release()
{
  mouseLockedToLine = false;
  mouseLockedToA = false;
  mouseLockedToB = false;
  freeMode = false;
  resetLockPoints();
}

void mouseReleased()
{
  release();
}

void keyReleased()
{
  //release();
  freeMode = false;
}

void keyPressed()
{
  if (key == 'd')
    debugMode=!debugMode;

  if (key == CODED) {
    if (keyCode == CONTROL) {
      //if (!mouseLockedToB && !mouseLockedToA)
      freeMode = true;
    }
  }
}