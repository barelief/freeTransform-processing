void mousePressed()
{
  centroidBegin = centroid.get();
}

void mouseReleased()
{
  lockedToMouse = false; 
  A.sticked = false;
  B.sticked = false;
  C.sticked = false;
  D.sticked = false;
}

void mouseDragged()
{
  A.updatePosition();
  B.updatePosition();
  C.updatePosition();
  D.updatePosition();
}

void keyPressed()
{

}

void keyReleased()
{

}

