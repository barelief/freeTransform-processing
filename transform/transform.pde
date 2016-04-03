/**
*
* FreeTransform main draw and setup
*
* @author Bartosh Polonski
* @version 0.prototype
* @since 2015-09-13
* 
*/

void draw()
{
  background(100);
  drawTexture(); // use with OPENGL mode
  quad.draw();
  P.set(mouseX, mouseY);
  displayCursors();
  
  /*
  // save running sketch into images (for gif)
  if (quad.state == State.DRAG_FREE_POINT && quad.dragLock)
  saveFrame("pointScaleFree####.jpg");
  */
}

PVector P; // user input vector
PVector beginP; // inial P position (before making offset)
PVector offsetP; // offset made by moving P from initial position
Polygon quad; // the polygon
int amount = 4; // amount of points ant lines in a quad is 4

void setup()
{
  img = loadImage("cat.jpg"); // load texture to be transformed
  loadCursors(); // load cursor png files
  frameRate(60); // set the frameRate of the app
  //size(600, 600); // window size 
   size(600, 600, P3D); // uncomment if using with drawTexture()
  noSmooth(); // 
  
  // init quad object 
  quad = new Polygon(); 
  
  // init user input vector and its flavours
  P = new PVector(); // 
  beginP = new PVector();
  offsetP = new PVector();
}