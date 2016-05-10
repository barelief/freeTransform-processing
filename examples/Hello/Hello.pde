import bare.utils.*;
FreeTransform hello;
PImage img, bgImg, img2, img3;
PGraphics offscreen;

void setup() {
  size(777, 500, P3D);
  noSmooth(); 
  hello = new FreeTransform(this);
  img = loadImage("moon.png");
  img2 = loadImage("stones.png");
  img3 = loadImage("cat.png");
  bgImg = loadImage("bg.jpg");
  offscreen = createGraphics(200, 200);
}

void draw() 
{
  background(100);
  // render images loaded from within sketch
  hello.render();
  
  // render images from code
  hello.render(0, bgImg);
  hello.render(1, img);
  hello.render(2, img2);
  hello.render(3, img3);
  hello.render(4, offscreen);
  
  // draw transform lines and points and debug info
  hello.draw();
  
  // update offscreen drawing 
  updateOffscreen();
  
  if (!hello.isEnabled)
    text("Press t to transform", 
  20, 20);
}

void updateOffscreen()
{
  offscreen.beginDraw();
  offscreen.clear();
  offscreen.fill(255, 50);
  offscreen.ellipse(60, 80, sin(frameCount*0.01)*50, sin(frameCount*0.01)*50);
  offscreen.ellipse(120, 80, cos(frameCount*0.01)*50, cos(frameCount*0.01)*50);
  offscreen.fill(0);
  offscreen.text("offscreen object", 50, 50);
  offscreen.stroke(255);
  offscreen.endDraw();
}