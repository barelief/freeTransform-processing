void mouseReleased()
{
  quad.release();
}

void mousePressed()
{
  if (quad.polygonLockedToMouse)
  {
    quad.setupPolygonDrag();
  }
}

void mouseDragged()
{
  if (quad.pointLockedToMouse)
    quad.updatePointPosition();
  
  // dragging
  if (quad.polygonLockedToMouse)
    quad.dragPolygon();
}

