/**
 *
 * Mouse and keyboard interaction routines
 *
 * @author Bartosh Polonski
 * @version 0.3
 * @since 2016-04-28
 * 
 */

// what happens when you release mouse button
void mouseReleased()
{
  if (mouseButton == LEFT)
  {
    releaseQuad();
  }
}
t
void releaseQuad()
{
  int selected = transform.selectedQuadId();
  Polygon quad = transform.quads.get(selected); 
  quad.release(); // release all locks
  //
  transform.savePoints(); // save current polygon points to external file
}

// what happens when you release keyboard button
void keyReleased()
{
  int selected = transform.selectedQuadId();
  Polygon quad = transform.quads.get(selected); 

  if (!quad.dragLock)
  {
    quad.pointMode = 0; // if no key is selected then return to deafault mode (SCALE_FREE_POINT)
    quad.lineMode = 0; // return to dafault mode SCALE_PROPORTIONALLY_LINE
    quad.rotateMode = 0;
    transform.savePoints(); // save current polygon points to external file
  }
}

// what happens once you press the mouse 
void mousePressed()
{
  if (mouseButton == LEFT)
  {
    // isSelected
    int focused = transform.focusedQuadId();
    Polygon quad = transform.quads.get(focused); 
    println ("[notice ] state: "+quad.state);

    switch (quad.state)
    {

    case DRAG_FREE_LINE:
      quad.setupDragLines();
      quad.dragLock = true;
      break;

    case SCALE_PROPORTIONALLY_LINE:

      quad.setupLineScaleProportional();
      quad.dragLock = true;
      break;

    case ROTATE:
      //quad.setupPolygonRotate();
      //quad.dragLock = true;
      int selected = transform.selectedQuadId();
      Polygon rotatingQuad = transform.quads.get(selected); 
      rotatingQuad.setupPolygonRotate();
      rotatingQuad.dragLock = true;
      break;

    case DRAG_AREA:
      quad.setupPolygonDrag();
      quad.dragLock = true;
      break;

    case DRAG_FREE_POINT:
      quad.setupDragPoint();
      quad.dragLock = true;
      break;

    case SCALE_PORPORTIONALLY_POINT:
      quad.setupScalePointProportionally();
      quad.dragLock = true;
      break;

    case SCALE_FREE_POINT:
      quad.setupPointScaleFree();
      quad.dragLock = true;
      break;
    }
  }
}

// what happens when you drag the mouse
void mouseDragged()
{
  int selected = transform.selectedQuadId();
  Polygon quad = transform.quads.get(selected); 

  if (mouseButton == LEFT)
  {
    switch (quad.state)
    {
    case DRAG_FREE_LINE:
      quad.dragLines();
      // quad.lineScaleProportional();
      break;

    case SCALE_PROPORTIONALLY_LINE:
      quad.lineScaleProportional();
      break;

    case ROTATE:
      quad.rotatePolygon();
      break;

    case DRAG_AREA:
      quad.dragPolygon();
      break;

    case DRAG_FREE_POINT:
      quad.dragPoint();
      break;

    case SCALE_PORPORTIONALLY_POINT:
      quad.scalePointProportionally();
      break;

    case SCALE_FREE_POINT:
      quad.pointScaleFree();
      break;
    }
  }
}

// key bindings
void keyPressed()
{

}

// mouse scroll functionality (zoom in / out)
float scalingSensitivity = .05;

void mouseWheel(MouseEvent event) {
  // If SHIFT is pressed
  int selected = transform.selectedQuadId();
  Polygon quad = transform.quads.get(selected); 

  if (quad.pointMode == 2) 
    scalingSensitivity = .01;
  else scalingSensitivity = .05;
  float e = event.getCount();
  // println(e);
  if (e < 0) quad.scaleArea(1-scalingSensitivity);
  else quad.scaleArea(1+scalingSensitivity);

  // update points after scaling area for next interactions
  // for (int i=0; i<amount; i++)
  // quad.updateGlobalPoints(i);

  // reset locks and initial positions	
  quad.release();
}