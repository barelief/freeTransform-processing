PVector[] points = new PVector[4];
PVector P;

void draw()
{
  background(200);
  beginShape();
  
  if (checkPointInsidePolygon (points, P)) 
    fill (255, 0, 0,20); 
  else noFill();

  for (int i=0; i < 4; i++)
    vertex(points[i].x, points[i].y);

  endShape(CLOSE);
  
  rectMode(CENTER);
  noFill();
  for (int i=0; i < 4; i++)
  {
   rect( points[i].x, points[i].y,5,5);
  }
  
  update();
}


void update()
{
  P.set(mouseX, mouseY);
}

void setup()
{

  size(600, 500);
  points[0] = new PVector (20, 50);
  points[1] = new PVector (100, 200);
  points[2] = new PVector (400, 400);
  points[3] = new PVector (30, 400);

  P = new PVector();
  
  noSmooth();
}


// http://www.ecse.rpi.edu/Homepages/wrf/Research/Short_Notes/pnpoly.html
boolean checkPointInsidePolygon(PVector[] points, PVector P)
{
  int i, j;
  boolean c = false;
  for (i = 0, j = points.length-1; i < points.length; j = i++) {
    if ( ((points[i].y>P.y) != (points[j].y>P.y)) &&
      (P.x < (points[j].x-points[i].x) * (P.y-points[i].y) / (points[j].y-points[i].y) + points[i].x) )
      c = !c;
  }
  return c;
}

