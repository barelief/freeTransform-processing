//

PVector anchorPoint;
PVector P; 
PVector diff;

// box
float boxAngle=0;
float boxStartAngle=0;
float offsetAngle=0;
float beginOffsetAngle=0;

void setup()
{
  size(600, 600);
  anchorPoint = new PVector(width/2, height/2);
  P= new PVector (0, 0);
  noSmooth();
}

void draw()
{
  //translate(width/3, height/3);
  background(255);
  rectPoint(anchorPoint, 5); 
  rectPoint(P, 5);
  stroke(0);
  //strokeWeight(3);

  line(anchorPoint.x, anchorPoint.y, P.x, P.y);
  diff = PVector.sub(P, anchorPoint);
  debug();
  update();
  // showGuides();
  theBox();
}

void update()
{
  P.set(mouseX, mouseY);
  //offsetAngle =  diff.heading();
}

void debug()
{
  fill(0);
  pushMatrix();
  translate(40, 20);
  text("∠ betw anch / P: " + decimalPoint( PVector.angleBetween(anchorPoint, P) ) + " (" + (int)degrees(PVector.angleBetween(anchorPoint, P))+  ")", 0, 20);
  text("∠ heading P: " + decimalPoint( P.heading() )+ " (" +(int)degrees(P.heading())+  ")", 0, 40);
  text("final ∠: " + decimalPoint( diff.heading() )+ " (" + (int)degrees(diff.heading())+  ")", 0, 60);
  text("box ∠: " + degrees(boxAngle), 0, 80);
  popMatrix();
  println(HALF_PI);
  angleCorners(diff);
}

void showGuides()
{
  // strokeWeight(3);
  stroke(150);
  line(0, 0, anchorPoint.x, anchorPoint.y);
  line(0, 0, P.x, P.y);

  // -- // 

  pushMatrix();
  translate(anchorPoint.x, anchorPoint.y);
  strokeWeight(1);
  line(0, 0, diff.x, diff.y);
  popMatrix();
}

void theBox()
{
  pushStyle();
  pushMatrix();
  //fill(255, 50);
  noFill();
  translate(anchorPoint.x, anchorPoint.y);
  rotate(boxAngle);
  rectMode(CENTER);
  rect(0, 0, 150, 150); 
  //ellipse(60,60,10,10);
  rect(60, 60, 5, 5);
  popMatrix();
  popStyle();
}

void rectPoint(PVector position, int size)
{
  pushStyle();
  noFill();
  stroke(0);
  rectMode(CENTER);
  rect(position.x, position.y, size, size);
  popStyle();
}

float decimalPoint(float input)
{
  // return ( round(input * 100) ) ;
  return (float )round(input*100) / 100 ;
  // return input;
}

void  angleCorners(PVector diff, int offset)
{
  //loat angle = 0;
  float[] angles = {-PI, -(HALF_PI+HALF_PI/2), -HALF_PI, -HALF_PI/2, 0, HALF_PI/2, HALF_PI, HALF_PI+HALF_PI/2, PI};
  
  for (int i=0; i<angles.length; i+=offset)
  {
    if (diff.heading()>angles[i] && diff.heading()<angles[i+1])
    {
      //angle = angles[i];
      text(i+": "+diff.heading(), 20, 200);
    }
  }

  //return angle;
}