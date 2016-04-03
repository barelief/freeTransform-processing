PVector anchor, position, beginPosition, P;
PVector tmp = new PVector(); // sukurk laikina vektoriu tranformacijom
PVector anchorLine; // vektorius nuo anchor pount iki P

float angle=0;
float startAngle=0;
float offsetAngle=0;
float startOffsetAngle=0;

boolean lockdrag = false;
int radius =50;

void draw()
{
  render();
  P.set(mouseX, mouseY);
  anchorLine = PVector.sub(P, anchor);
  text((int)degrees(offsetAngle),20,20);
}

void render()
{
  background(200);

  //anchor
  stroke(255, 0, 0);
  noFill();
  rect(anchor.x, anchor.y, 5, 5);
  text("anchor", anchor.x+10, anchor.y+10);


  fill(255, 0, 0, 10);
  noStroke();
  ellipse(anchor.x, anchor.y, radius, radius);
  
  // A point
  stroke(0);
  rect(position.x, position.y, 5, 5);
  fill(255);
  text("A", position.x+10, position.y+10);
  
  
  stroke(0, 255, 0);
  noFill();
  rect(anchorLine.x, anchorLine.y, 7, 7);
  fill(255);
  text("anchorLine", anchorLine.x+10, anchorLine.y+10);
}

void setup()
{
  size(600, 600);
  anchor = new PVector(width/2, height/3);
  position = new PVector(100, 200);
  anchorLine = new PVector();
  P = new PVector();
  beginPosition= new PVector();
  rectMode(CENTER);
  P = new PVector();
}

