PVector P; //<>//
PVector offsetP; // offset made by moving user point P (aka mouse)
PVector beginP; // offset is being calculated starting from the position when mouse was pressed
boolean topLock = false; // if one of the lines was already locked, make a global lock, so otherr lines wont interact

void draw()
{
  background(100);
  for (int i=0; i<line.length; i++) 
    line[i].draw();
  update();
  showInfo();
}

void update()
{
  P.set(mouseX, mouseY, 0);
}

void showInfo()
{
  text("* drag points or line \n* press and hold CTRL then drag a point to scale the line \n* press 'd' for debug", 40, height-100);
}

Line[] line = new Line [4];

void setup()
{
  size(600, 600);
  // main vars
  P = new PVector();
  offsetP = new PVector();
  beginP = new PVector();

  for (int i=0; i<line.length; i++) 
    line[i] = new Line();

  noSmooth();
}


void mousePressed()
{
  for (int i=0; i<line.length; i++) 
    line[i].checkInteraction();
}

void mouseDragged()
{
  offsetP = PVector.sub(P, beginP); // calculate the offset made by P
  for (int i=0; i<line.length; i++) 
    line[i].drag();
}

void mouseReleased()
{
  for (int i=0; i<line.length; i++) 
    line[i].release();
}

void keyReleased()
{
  for (int i=0; i<line.length; i++) 
    line[i].freeMode = true;
}

void keyPressed()
{
  if (key == 'd')
    for (int i=0; i<line.length; i++)
      line[i].debugMode=!line[i].debugMode;

  if (key == CODED) {
    if (keyCode == CONTROL) {
      //if (!mouseLockedToB && !mouseLockedToA)
      for (int i=0; i<line.length; i++) 
        line[i].freeMode = false;
    }
  }
}