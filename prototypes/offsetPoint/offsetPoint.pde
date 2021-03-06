void draw()
{
  background(200);
  rect(offsetP.x, offsetP.y, 5, 5); // display point
  text("offsetP", offsetP.x+10, offsetP.y+5);
  text("P",P.x+10,P.y);
  P.set(mouseX, mouseY); // update usr point
}

PVector offsetP; // point to be transoformed
PVector offset; // offset to move point A made by moving user point P
PVector P; // user mouse point
PVector beginOffsetP; // lock the initial A point position, from which transformatin is made
PVector beginOffset; // offset is being calculated starting from the position when mouse was pressed

void setup()
{
  size(400, 400);
  offset = new PVector();
  beginOffset = new PVector();
  P = new PVector();
  beginOffsetP = new PVector();
  offsetP = new PVector (width/2, height/2);
}

void mousePressed()
{
  beginOffset.set(mouseX, mouseY); // lock the beginning position of the offset vector
  beginOffsetP.set(offsetP); // lock the beginning of the vector to be transformed
}

void mouseReleased()
{
}

void mouseDragged()
{
  offset = PVector.sub(P, beginOffset); // calculate the offset made by mouseDrag -- subtract beginOffset from P
  offsetP = PVector.add(beginOffsetP, offset); // reposition point A based the offset made
}