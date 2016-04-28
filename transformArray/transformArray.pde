/**
 *
 * Creaty array of FreeTransform objects and transform them separately
 *
 * @author Bartosh Polonski
 * @version 0.1.0
 * @since 2016-04-11
 * 
 */

void draw()
{
  background(100); //
  // imageMode(CORNER); //
  // image(bg, 0, 0); //
  //drawTexture(); // use with OPENGL mode
  transform.draw();
  
  P.set(mouseX, mouseY);
  displayCursors();

}

PVector P; // user input vector
PVector beginP; // inial P position (before making offset)
PVector offsetP; // offset made by moving P from initial position
FreeTransform transform; // array of quads to transform (main object)

void setup()
{
  img = loadImage("cat.jpg"); // load texture to be transformed
  bg = loadImage("bg.jpg");
  loadCursors(); // load cursor png files
  frameRate(59); // set the frameRate of the app
  //size(600, 600); // window size 
  //size(640,353, P3D); // uncomment if using with drawTexture()
  size(600, 600, P3D);
  noSmooth(); // 
  
  // init user input vector and its flavours
  P = new PVector(); // 
  beginP = new PVector();
  offsetP = new PVector();
  
  transform = new FreeTransform();
}