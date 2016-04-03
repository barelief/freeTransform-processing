
void mousePressed()
{
  beginOffsetAngle = diff.heading();
  boxStartAngle = boxAngle;
}

void mouseDragged()
{
  offsetAngle = diff.heading() - beginOffsetAngle;
  boxAngle = boxStartAngle + offsetAngle;
}

void keyPressed()
{
  if (key == 'm')
    anchorPoint.set(mouseX, mouseY);
}

