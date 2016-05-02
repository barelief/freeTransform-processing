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
  
  updateOffscreen();
  imageMode(CORNER); //
   image(bg, 0, 0); //
  //drawTexture(); // use with OPENGL mode
     
  transform.render(0, img);
  transform.render(2, img2);
  transform.render(3, offscreen);
  transform.render(1, earth);
  
  transform.draw();
  P.set(mouseX, mouseY);
  displayCursors();
  
  if (!transform.isEnabled)
  text("press [t] to enable transform", 20,20);
}

PVector P; // user input vector
PVector beginP; // inial P position (before making offset)
PVector offsetP; // offset made by moving P from initial position
FreeTransform transform; // array of quads to transform (main object)

void setup()
{
  img = loadImage("cat.png"); // load texture to be transformed
 img2 = loadImage("stones.png"); // load texture to be transformed
  bg = loadImage("bg.jpg");
  earth = loadImage("moon.png");

  offscreen = createGraphics(200, 200);

  loadCursors(); // load cursor png files
  frameRate(59); // set the frameRate of the app
  // size(600, 600); // window size 
  // size(640,353, P3D); // uncomment if using with drawTexture()
  
  size(777, 510, P3D);
  noSmooth(); // 
  
  // init user input vector and its flavours

  P = new PVector(); // 
  beginP = new PVector();
  offsetP = new PVector();
  
  transform = new FreeTransform();
}