void draw()
{
  background(200);
  rect(A.x, A.y, 5, 5); // display point
  text("A", A.x+10, A.y+5);
  text("P",P.x+10,P.y);
  P.set(mouseX, mouseY); // update usr point
}

PVector A; // point to be transoformed
PVector offset; // offset to move point A made by moving user point P
PVector P; // user mouse point
PVector beginA; // lock the initial A point position, from which transformatin is made
PVector beginOffset; // offset is being calculated starting from the position when mouse was pressed

void setup()
{
  size(400, 400);
  offset = new PVector();
  beginOffset = new PVector();
  P = new PVector();
  beginA = new PVector();
  A = new PVector (width/2, height/2);
}

void mousePressed()
{
  beginOffset.set(mouseX, mouseY); // lock the beginning position of the offset vector
  beginA.set(A); // lock the beginning of the vector to be transformed
}

void mouseReleased()
{
}

void mouseDragged()
{
  offset = PVector.sub(P, beginOffset); // calculate the offset made by mouseDrag -- subtract beginOffset from P
  A = PVector.add(beginA, offset); // reposition point A based the offset made
}

