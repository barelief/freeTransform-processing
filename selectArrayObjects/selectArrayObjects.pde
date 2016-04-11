// select with mouse separate obects from ArrayList
// to do: 
// 1. make a test lib
// 2. save coords to json

void draw()
{
  background(49);
  mouse.set(mouseX, mouseY);
  transform.draw();
}

FreeTransform transform;
PVector mouse;

void setup()
{
  size(600,600);
  mouse = new PVector();
  transform = new FreeTransform(7);
  setupMouseWheel();
}
