void draw()
{
  background(200);
  quad.draw();
  P.set(mouseX, mouseY);
}

PVector P;
Quad quad;

void setup()
{
  size(600, 600);
  noSmooth();
  quad = new Quad();
  P = new PVector();
}

