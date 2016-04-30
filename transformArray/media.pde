/**
 *
 * Solves rendering textures and images (PGraphics, PImage) - buggy, WIP
 *
 * @author Bartosh Polonski
 * @version 0.prototype
 * @since 2016-04-30
 * 
 */

PImage img; // load random image to be transformed
PImage bg;
PImage earth;
PGraphics offscreen;



void updateOffscreen()
{
  offscreen.beginDraw();
  //offscreen.background(127,20);
  //offscreen.pushStyle();
  offscreen.clear();
  offscreen.fill(255,50);
  offscreen.ellipse(60,80, sin(frameCount*0.01)*50,sin(frameCount*0.01)*50);
  offscreen.fill(255);
  offscreen.text("offscreen object", 50,50);
  offscreen.stroke(255);
  offscreen.line(0, 0, 200, 200);
  //offscreen.popStyle();
  offscreen.endDraw();
  
}