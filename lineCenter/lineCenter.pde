Point A, B, C, D;
PVector X, Y, Z, Q;
PVector P;
boolean lockedToMouse = false;

void setup()
{
  noSmooth();
  size(600, 500);
  A = new Point (20,20);
  B = new Point (400, 30);
  C = new Point (400, 400);
  D = new Point (30, 400);

  P = new PVector ();

  // centroid
  setupLineIntersections();
}

void draw()
{

  background(255);

  A.draw();
  B.draw();
  C.draw();
  D.draw();


  // polygon ( 4 kampai)
  stroke(100);
  line (A.x, A.y, B.x, B.y); 
  line (B.x, B.y, C.x, C.y); 
  line (C.x, C.y, D.x, D.y); 
  line (D.x, D.y, A.x, A.y); 

  // lineCenters
  X = lineCenter(A, B);
  Y = lineCenter(B, C);
  Z = lineCenter(C, D);
  Q = lineCenter(D, A);

  noFill();
  stroke(150);
  rectMode(CENTER);
  rect(X.x, X.y, 5, 5);
  rect(Y.x, Y.y, 5, 5);
  rect(Z.x, Z.y, 5, 5);
  rect(Q.x, Q.y, 5, 5);

  rect(centroid.x, centroid.y, 5, 5);
  update();
  updateLineInterseqtions();
}

void update()
{
  P.set(mouseX, mouseY);
}

PVector lineCenter(Point A, Point B)
{
  PVector C;
  C = PVector.sub(B.position, A.position);
  C.div(2);
  C.add(A.position);
  return C;
  // update();
}

