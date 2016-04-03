void draw()
{
  background(100);
  quad.draw();
  P.set(mouseX, mouseY);
}

PVector P, beginP, offsetP; // user input vector
Polygon quad; // the polygon
int amount = 4; // amount of points ant lines in a quad is 4

void setup()
{
  frameRate(60);
  size(600, 600);
  noSmooth();
  quad = new Polygon(); // init quad object 
  P = new PVector(); // 
  beginP = new PVector();
  offsetP = new PVector();
}