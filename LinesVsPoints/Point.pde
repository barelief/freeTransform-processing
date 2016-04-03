class Point 
{
  PVector position;
  Point (PVector position_)
  {
    position = new PVector(position_.x, position_.y);
  }
}

void reset()
{
  // reset all points so they are drawn in the center with equal distance between each other
  
  for (int i=0; i<amount; i++)
  {
    int radius=width/4;
    float angle = map(i, 0, amount, PI, -PI); // position points evenly from -PI to +PI
    PVector shift = new PVector(sin(angle)*radius+width/2, cos(angle)*radius+height/2); //  on the circumference of a circle of "radius" in the center (w/2, h/2)
    point[i] = new Point(new PVector(shift.x, shift.y));
    ellipse(shift.x, shift.y, 5, 5);
  }

  selectedLine = -1;
}
