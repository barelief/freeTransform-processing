import bare.utils.*;
FreeTransform hello;
PImage img, bgImg, img2, img3;

void setup() {
  size(777, 500, P3D);
  noSmooth(); 
  hello = new FreeTransform(this);
  img = loadImage("moon.png");
  img2 = loadImage("stones.png");
  img3 = loadImage("cat.png");
  bgImg = loadImage("bg.jpg");
}

void draw() 
{
  background(100);
  hello.render(0, bgImg);
  hello.render(1, img);
  hello.render(2, img2);
  hello.render(3, img3);
  hello.draw();
  
  if (!hello.isEnabled)
    text("Press t to transform", 20, 20);
}