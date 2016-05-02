/**
*
* Set the boundaries of input texture interactively
* http://i.imgur.com/VpIgdaZ.gif
*
* @author Bartosh Polonski
* @version 0.prototype
* @since 2015-09-18
* 
*/


PVector A, B, a, b;
PImage img;

void setup()
{
  size(700,300, P3D);
  a = new PVector(20, 20);
  b = new PVector(200, 200);
  
  A = new PVector(0, 0);
  B = new PVector(270, 200);
  img = loadImage("cat.jpg"); // http://i.imgur.com/wRxABau.jpg
  img.resize((int)B.x, (int)B.y);
  frameRate(10);
}

void draw()
{
  background(127);
  noFill();
  stroke(255);
  rect(a.x, a.y, b.x - a.x, b.y);
  image(img, a.x,a.y);
  pushMatrix();
  translate(400,20);
  drawTexture();
  popMatrix();
}

void drawTexture()
{
  noStroke();
  beginShape(); //
  texture(img); //
  vertex(A.x, A.y, a.x, a.y); //
  vertex(B.x, A.y, b.x, a.y); //
  vertex(B.x, B.y, b.x, b.y); //
  vertex(A.x, B.y, a.x, b.y); //
  endShape(); //
}

void mouseDragged()
{
  if (abs(b.x-mouseX) < 20)
  b.x = mouseX;
  
  //saveFrame("input####.jpg");
}

void mouseReleased()
{
 //exit(); 
}