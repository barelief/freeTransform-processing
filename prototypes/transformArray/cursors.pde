PImage[] cursor = new PImage[4]; // create array of images used as cursors

// load cursor image files into the app
void loadCursors()
{
  for (int i=0; i<4; i++)
    cursor[i] = loadImage("cursors/"+i+".png");
}

// display cursors based on current inteactive state
void displayCursors()
{
  int selected = transform.focusedQuadId();
  Polygon quad = transform.quads.get(selected); 

  PVector diff = new PVector();
  diff = PVector.sub(P, quad.anchor);
  imageMode(CENTER);

  switch (quad.state)
  {
  case DRAG_FREE_LINE:
    noCursor();
    image(cursor[0], P.x, P.y);
    break;

  case SCALE_PROPORTIONALLY_LINE:
    noCursor();
    pushMatrix();
    translate(P.x, P.y);
    rotate(cursorAngle(diff));
    image(cursor[3], 0, 0);
    popMatrix();
    break;

  case ROTATE:
    noCursor();
    diff = PVector.sub(P, quad.anchor);
    pushMatrix();
    translate(P.x, P.y);
    rotate(rotateCursorAngle(diff));
    image(cursor[2], 0, 0);
    popMatrix();
    break;

  case DRAG_AREA:
    noCursor();
    image(cursor[1], P.x, P.y);
    break;

  case DRAG_FREE_POINT:
    noCursor();
    image(cursor[0], P.x, P.y);
    break;

  case SCALE_PORPORTIONALLY_POINT:
    noCursor();
    diff = PVector.sub(P, quad.anchor);
    pushMatrix();
    translate(P.x, P.y);
    rotate(cursorAngle(diff));
    image(cursor[3], 0, 0);
    popMatrix();
    break;

  case SCALE_FREE_POINT:
    noCursor();
    diff = PVector.sub(P, quad.anchor);
    pushMatrix();
    translate(P.x, P.y);
    rotate(cursorAngle(diff));
    image(cursor[3], 0, 0);
    popMatrix();
    break;
  case NONE:
    cursor();
  }
}

// display rotate cursor according to cursor-anchor angle http://i.imgur.com/NG5pNH9.jpg
// http://i.imgur.com/NG5pNH9.jpg

float cursorAngle(PVector diff)
{
  float angle = 0;
  float[] angles = {-PI, -(HALF_PI+HALF_PI/2), -HALF_PI, -HALF_PI/2, 0, HALF_PI/2, HALF_PI, HALF_PI+HALF_PI/2, PI};

  for (int i=0; i<angles.length; i++)
  {
    if (diff.heading()>angles[i] && diff.heading()<angles[i+1])
      angle = angles[i];
  }

  return angle;
}

// rotate cursor angle method to reduce angle to four simplified states
float rotateCursorAngle(PVector diff)
{
  float angle = 0;
  float[] angles = {-PI, -HALF_PI, 0, HALF_PI, PI};

  for (int i=0; i<angles.length; i++)
  {
    if (diff.heading()>angles[i] && diff.heading()<angles[i+1])
      angle = angles[i];
  }

  return angle;
}