
void mousePressed()
{
  beginOffsetAngle = diff.heading();
  boxStartAngle = boxAngle;
}

void mouseDragged()
{
  offsetAngle = diff.heading() - beginOffsetAngle;
  //offsetAngle = (offsetAngle);
  boxAngle = boxStartAngle + offsetAngle;
 // boxAngle = snapAngle(boxAngle%PI);
  //println("box: "+boxAngle);
}

void keyPressed()
{
  if (key == 'm')
    anchorPoint.set(mouseX, mouseY);
}