/**
 *
 * External images code
 *
 * @author Bartosh Polonski
 * @version 0.prototype
 * @since 2015-09-13
 * 
 */

PImage img; // load random image to be transformed

// display image as a texture
void drawTexture()
{
  beginShape();
  texture(img);
  vertex(quad.point[0].x, quad.point[0].y, 0, 0);
  vertex(quad.point[1].x, quad.point[1].y, img.width, 0);
  vertex(quad.point[2].x, quad.point[2].y, img.width, img.height);
  vertex(quad.point[3].x, quad.point[3].y, 0, img.height);
  endShape();
}

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
  switch (quad.state)
  {
  case DRAG_FREE_LINE:
    noCursor();
    image(cursor[0], P.x, P.y);
    break;

  case SCALE_PROPORTIONALLY_LINE:
    noCursor();
    image(cursor[3], P.x, P.y);
    break;

  case ROTATE:
    noCursor();
    PVector diff = PVector.sub(P, quad.anchor);
    pushMatrix();
    translate(P.x, P.y);
    rotate(angleCorners(diff));
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
    image(cursor[3], P.x, P.y);
    break;

  case SCALE_FREE_POINT:
    noCursor();
    image(cursor[3], P.x, P.y);
    break;
  case NONE:
    cursor();
  }
}
// display rotate cursor according to cursor-anchor angle
float angleCorners(PVector diff)
{
  float angle = 0;
  
  if (HALF_PI>diff.heading() && diff.heading()>0)
    angle = 0;
  if (PI>diff.heading()&& diff.heading() >HALF_PI)
    angle = HALF_PI;
  if (-PI<diff.heading()&& diff.heading()<-HALF_PI)
    angle = PI;
  if (0>diff.heading()&& diff.heading()>-HALF_PI)
    angle = -HALF_PI;
  
  return angle;
}