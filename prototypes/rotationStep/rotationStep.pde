void setup()
{
  size(400, 400);
}

float angle;

void draw()
{
  background(100);
  float step = 24;
  angle = mouseX;
  float finale;
  if (angle/step >= 1)
  {
    finale = ((angle/step)) * step  ;
  } else finale = 0;

  float rotStep = HALF_PI;
  float rotation = map(mouseX, 0 , width, -PI, PI);
  rotation = ( (rotation/rotStep)-(rotation % rotStep) ) * rotStep;
  PVector rad = new PVector();
  rad.set(cos(rotation)*100+width/2, sin(rotation)*100+height/2);
  
  line(width/2, height/2, rad.x, rad.y);
  
  
  
    ellipse(finale, 50, 20, 20);
  text(finale, finale, 20);
  text(mouseX, mouseX+20, mouseY);
  text(mouseX/step, mouseX+20, mouseY+20);
  text(mouseX%step, mouseX+20, mouseY+40);
  text(rotation, mouseX+20, mouseY+60);
}