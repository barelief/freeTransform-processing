void draw()
{
  background(255);
  quad.draw();
  P.set(mouseX, mouseY); 
}

PVector P; // user input vector
Quad quad; // the polygon
JSONArray values;

void setup()
{
  frameRate(60);
  size(600, 600);
  noSmooth();
  values = loadJSONArray("data.json");
  quad = new Quad(values);
  P = new PVector();
  
}

