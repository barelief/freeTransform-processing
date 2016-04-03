/* 
This sketch finds neighbor and opposite of the selcted point in four-point polygon
no trig or stuff, just calc
*/

int amountOfPoints = 4;
PVector[] X = new PVector[amountOfPoints];
PVector P;
int sensitivity = 10;

void setup()
{
  size(400, 400);
  reset();
  P = new PVector(0, 0);
  noSmooth();
}

void reset()
{
  X[0] = new PVector(random(width/2), random(height/2));
  X[1] = new PVector(random(width/2, width), random(height/2));
  X[2] = new PVector(random(width/2, width), random(height/2, height));
  X[3] = new PVector(random(width/2), random(height/2, height));
  
  //for (int i=0; i<X.length; i++)
  //X[i] = new PVector(random(width), random(height));
}

void update()
{
  P.set(mouseX, mouseY);
}

void renderNames()
{
  fill(0);
  for (int i=0; i<X.length; i++)
    text(i, X[i].x+10, X[i].y+10);
}

void renderSelectedPoint()
{
  for (int i=0; i<X.length; i++)
  {
    if (X[i].dist(P) < sensitivity)
    {
      fill(255, 0, 0);
      text(i, X[i].x+10, X[i].y+10); // draw selected point
      noFill();
      rectMode(CENTER);
      rect(X[i].x, X[i].y, 5, 5);

      fill(255, 0, 0);

      int opposite = ((i+2)>X.length-1) ? (i+2)-X.length : i+2; // aktualu 2 ir 3 array points

      text("opposite", X[opposite].x+20, X[opposite].y+10); // draw opposite point

      line(X[i].x, X[i].y, X[opposite].x, X[opposite].y);

      int neighborLeft = ((i+1)>X.length-1) ? (i+1)-X.length : i+1; // aktualu tik 3 array point

      text("neighborLeft", X[neighborLeft].x+20, X[neighborLeft].y+10); // draw left neighbor point

      int neighborRight = ((i-1)<0) ? X.length+(i-1) : i-1; // aktualu tik 0 array pointer

      text("neighborRight", X[neighborRight].x+20, X[neighborRight].y+10); // draw right neighbor point
    }
  }
}

void draw()
{
  background(200);
  fill(255);
  beginShape();
  for (int i=0; i<X.length; i++)
    vertex(X[i].x, X[i].y);
  endShape(CLOSE);
  renderNames();
  renderSelectedPoint();
  update();
  text("press space to reset poly",20,20);
}

void keyPressed()
{
  reset();
}