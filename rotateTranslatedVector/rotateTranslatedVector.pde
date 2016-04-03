PVector anchor, startAnchor, A, startA, lockedA, P, lockedP;
PVector offset, offsetStart;
PVector tmpA = new PVector(); // sukurk laikina vektoriu tranformacijom
PVector diff; // 

//
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

  diff = PVector.sub(P, anchor);
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
  rect(A.x, A.y, 5, 5);
  fill(255);
  text("A", A.x+10, A.y+10);
  
  
  stroke(0, 255, 0);
  noFill();
  rect(diff.x, diff.y, 7, 7);
  fill(255);
  text("diff", diff.x+10, diff.y+10);
}

void setup()
{
  size(600, 600);
  anchor = new PVector(width/2, height/3);
  A = new PVector(100, 200);
  diff = new PVector();
  P = new PVector();
  lockedA= new PVector();
  rectMode(CENTER);

  offset = new PVector();
  offsetStart = new PVector();
  P = new PVector();
  startAnchor = new PVector();

  startA = new PVector();
}

