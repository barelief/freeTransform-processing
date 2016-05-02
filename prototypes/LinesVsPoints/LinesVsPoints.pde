/** 
 Sketch description:
 when dragging one line of a quad/polygon, I update points from other lines
 **/

// interaction variables
PVector offset; // offset to move line by moving user point P
PVector beginOffset; // offset is being calculated starting from the position when mouse was pressed
PVector P; // user mouse point
boolean dragging = false;

// points and lines variables
int amount = 4; // amount of points ant lines in a quad is 4
Point[] point = new Point[amount]; // init points
Line[] line = new Line[amount];
int selectedLine = -1; // selected lines only work if  // init points

void setup()
{
  size(600, 600);
  reset(); // show polygon/quad in the center. Make sure it's before updateGlobalLines();
  updateGlobalLines();

  // interaction vars
  beginOffset = new PVector();
  offset = new PVector();
  P = new PVector();

  // visual
  rectMode(CENTER);
  noSmooth();
}

void draw()
{
  background(200);
  for (int i=0; i<amount; i++)
  {

    rect(point[i].position.x, point[i].position.y, 5, 5);
    line[i].render();
  }

  updateGlobalLines();
  P.set(mouseX, mouseY);
  debug();
}

void debug()
{
  text("r to reset\n+/- to add edges\npress 0.."+amount+" to drag edge\n"+"number of edges: "+amount, 20, 20);
}

// INTERACTION

void keyPressed()
{
  if (!dragging) // lock dragging to one line per drag
  {
    selectedLine=key-49;
    println("Current selected Line: "+selectedLine);

    switch(key)
    {
    case 'r':
      reset();
      break;
    case '+':
      if (amount<9)
        amount++;
      point = new Point[amount]; // init points
      line = new Line[amount];
      reset();
      updateGlobalLines();
      break;
    case '-':
      if (amount>3)
        amount--;
      point = new Point[amount]; // init points
      line = new Line[amount];
      reset();
      updateGlobalLines();
      break;
    }
  }
}

void mousePressed()
{
  beginOffset.set(P); // lock the beginning position of the offset vector
  if  (selectedLine>-1 &&  selectedLine < amount) {
    // lock the beginning of the vector to be transformed
    line[selectedLine].beginStart.set(line[selectedLine].start.position); // begin point of line
    line[selectedLine].beginEnd.set(line[selectedLine].end.position); // begin point of line
  }
}

void mouseReleased()
{
  dragging = false;
}

void mouseDragged()
{

  offset = PVector.sub(P, beginOffset); // calculate the offset made by mouseDrag -- subtract beginOffset from P
  if  (selectedLine>-1 &&  selectedLine < amount)
  {
    line[selectedLine].start.position = PVector.add(line[selectedLine].beginStart, offset); // reposition point A based the offset made
    line[selectedLine].end.position = PVector.add(line[selectedLine].beginEnd, offset); // reposition point A based the offset made
    line[selectedLine].updateGlobalPoints();
  }
  dragging = true;
}
