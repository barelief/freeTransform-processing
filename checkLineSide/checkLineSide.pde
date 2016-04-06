//http://stackoverflow.com/questions/3838319/how-can-i-check-if-a-point-is-below-a-line-or-not/3838398#3838398

PVector A, B;
PVector P;

void setup()
{
  A = new PVector(random(width), random(height));
  B = new PVector(random(width), random(height));
  P = new PVector();

  size(500, 500);
}

void draw()
{
  background(0);
  P.set(mouseX, mouseY);

  stroke(255);
  line (A.x, A.y, B.x, B.y);
  checkLineSide(A, B, P);
}

boolean checkLineSide(PVector A, PVector B, PVector P)
{
  boolean oneSide = true;
  PVector v1 = new PVector(B.x-A.x, B.y-A.y); 
  PVector v2 = new PVector(B.x-P.x, B.y-P.y);

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