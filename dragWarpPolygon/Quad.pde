class Quad
{
  Point A, B, C, D;
  PVector X, Y, Z, Q;

  Line XZ;
  Line QY;
  PVector centroid, centroidBegin;

  boolean pointLockedToMouse = false;
  boolean polygonLockedToMouse = false;

  PVector offset;
  PVector beginOffset;

  Quad()
  {
    A = new Point (20, 20);
    B = new Point (400, 30);
    C = new Point (400, 400);
    D = new Point (30, 400);

    offset = new PVector();
    beginOffset = new PVector();
    // centroid
    setupLineIntersections();
  }

  void polygonCheck()
  {
    PVector[] points = new PVector[4];
    points[0] = new PVector ();
    points[1] = new PVector ();
    points[2] = new PVector ();
    points[3] = new PVector ();

    points[0].set(A.position);
    points[1].set(B.position);
    points[2].set(C.position);
    points[3].set(D.position);

    beginShape();
    noStroke();

    // check if mouse is inside polygon

    if (checkPointInsidePolygon (points, P)) 
    {
      polygonLockedToMouse = true;
      fill (255, 0, 0, 20);
    } else {
      noFill();
      polygonLockedToMouse =false;
    }

    for (int i=0; i < 4; i++)
      vertex(points[i].x, points[i].y);
    endShape(CLOSE);
  }

  void setupLineIntersections()
  {
    XZ  = new Line( new PVector(), new PVector() );
    QY  = new Line( new PVector(), new PVector() );
    centroid = new PVector();
    centroidBegin = centroid.get();
  }

  void updateLineInterseqtions()
  {
    XZ.set(X, Z);
    QY.set(Q, Y);
    if (XZ.intersects_at(QY) != null) // if two points are on each other
      centroid = XZ.intersects_at(QY);
  }


  void draw()
  {
    A.draw();
    B.draw();
    C.draw();
    D.draw();

    fill(255);
    text("A", A.x+10, A.y+5);
    text("B", B.x+10, B.y+5);
    text("C", C.x+10, C.y+5);
    text("D", D.x+10, D.y+5);

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
    updateLineInterseqtions();
    if (!pointLockedToMouse)
      polygonCheck();
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

  void release()
  {
    A.sticked = false;
    B.sticked = false;
    C.sticked = false;
    D.sticked = false;
    polygonLockedToMouse = false;
    pointLockedToMouse = false;
  }

  void updatePointPosition()
  {
    A.updatePosition();
    B.updatePosition();
    C.updatePosition();
    D.updatePosition();
  }

  void setupPolygonDrag()
  {
    beginOffset.set(P);
    A.beginPosition.set(A.position); 
    B.beginPosition.set(B.position);
    C.beginPosition.set(C.position);
    D.beginPosition.set(D.position);
  }

  void dragPolygon()
  {
    offset = PVector.sub(P, beginOffset); // calculate the offset made by mouseDrag -- subtract beginOffset from P
    A.position = PVector.add(A.beginPosition, offset); 
    B.position = PVector.add(B.beginPosition, offset); 
    C.position = PVector.add(C.beginPosition, offset); 
    D.position = PVector.add(D.beginPosition, offset);
  }

  void rotatePolygon()
  {
  }

  // http://www.ecse.rpi.edu/Homepages/wrf/Research/Short_Notes/pnpoly.html
  boolean checkPointInsidePolygon(PVector[] points, PVector P)
  {
    int i, j;
    boolean c = false;
    for (i = 0, j = points.length-1; i < points.length; j = i++) {
      if ( ((points[i].y>P.y) != (points[j].y>P.y)) &&
        (P.x < (points[j].x-points[i].x) * (P.y-points[i].y) / (points[j].y-points[i].y) + points[i].x) )
        c = !c;
    }
    return c;
  }
}

