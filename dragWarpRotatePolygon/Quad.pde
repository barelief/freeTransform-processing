class Quad
{
  Point A, B, C, D;
  PVector X, Y, Z, Q;

  Line XZ;
  Line QY;
  PVector anchor;
  PVector lockAnchor;

  boolean pointLockedToMouse = false;
  boolean polygonLockedToMouse = false;
  boolean rotationLockedToMouse = false;

  boolean stateLocked = false;

  State state = State.NONE;

  PVector offset;
  PVector beginOffset;


  PVector anchorLine; // need for rotation

  Quad(JSONArray values)
  {
    // load points form external file
    A = new Point (values.getJSONObject(0).getInt("x"), values.getJSONObject(0).getInt("y"));
    B = new Point (values.getJSONObject(1).getInt("x"), values.getJSONObject(1).getInt("y"));
    C = new Point (values.getJSONObject(2).getInt("x"), values.getJSONObject(2).getInt("y"));
    D = new Point (values.getJSONObject(3).getInt("x"), values.getJSONObject(3).getInt("y"));

    offset = new PVector();
    beginOffset = new PVector();
    anchorLine = new PVector();
    lockAnchor = new PVector();
    // centroid
    setupLineIntersections();
    println(state);
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
    //noStroke();

    // check if mouse is inside polygon
    if (!stateLocked)
    {
      if (checkPointInsidePolygon (points, P)) 
      {
        polygonLockedToMouse = true;
        state = State.AREA;
      } else {
        //noFill();
        state = State.ROTATE;
        polygonLockedToMouse = false;
      }
    }

    if (state==State.AREA)
      stroke(255, 0, 0); 
    else 
    {
      stroke(0);
    }


    for (int i=0; i < 4; i++)
      vertex(points[i].x, points[i].y);
    endShape(CLOSE);
  }

  void setupLineIntersections()
  {
    XZ  = new Line( new PVector(), new PVector() );
    QY  = new Line( new PVector(), new PVector() );
    anchor = new PVector();
  }

  void updateLineInterseqtions()
  {
    XZ.set(X, Z);
    QY.set(Q, Y);
    if (XZ.intersects_at(QY) != null) // if two points are on each other
      anchor = XZ.intersects_at(QY);
  }


  void draw()
  {
    //if (!pointLockedToMouse && !rotationLockedToMouse)

    polygonCheck();


    A.draw();
    B.draw();
    C.draw();
    D.draw();

    fill(127);
    text("A", A.x+10, A.y+5);
    text("B", B.x+10, B.y+5);
    text("C", C.x+10, C.y+5);
    text("D", D.x+10, D.y+5);

    /*
    // polygon ( 4 kampai)
     stroke(100);
     line (A.x, A.y, B.x, B.y); 
     line (B.x, B.y, C.x, C.y); 
     line (C.x, C.y, D.x, D.y); 
     line (D.x, D.y, A.x, A.y); 
     */
    // lineCenters
    X = lineCenter(A, B);
    Y = lineCenter(B, C);
    Z = lineCenter(C, D);
    Q = lineCenter(D, A);

    text("X", X.x+10, X.y+5);
    text("Y", Y.x+10, Y.y+5);
    text("Z", Z.x+10, Z.y+5);
    text("Q", Q.x+10, Q.y+5);

    noFill();
    stroke(150);
    rectMode(CENTER);
    rect(X.x, X.y, 5, 5);
    rect(Y.x, Y.y, 5, 5);
    rect(Z.x, Z.y, 5, 5);
    rect(Q.x, Q.y, 5, 5);

    rect(anchor.x, anchor.y, 5, 5);
    updateLineInterseqtions();


    anchorLine = PVector.sub(P, anchor); // check rotation routines
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
    rotationLockedToMouse = false;
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

  // check Edit transform for more options like "warp"

  void dragEdge(Point start, Point end, boolean mirror, boolean lockAspect)
  {
  }

  void scale(Point scalingPoint, boolean constainProportions, boolean mirror)
  {
    // when i drag the partiular point it resizes  all points proportionally to my x and y offset, 
    // except the opposite point
  }

  void movePoint(Point point)
  {
    // pabandyk irasyti funckija, kuri detectintu 
    // kolizija su tashku outside  Point class, 
    // kad butu veliau lengviau extendinti FReeTransforma
  }

  void setupPolygonRotate()
  {
    rotationLockedToMouse = true;
    //polygonLockedToMouse = true; 
    lockAnchor.set(anchor);
    A.startRotating();
    B.startRotating();
    C.startRotating();
    D.startRotating();
  }

  void rotatePolygon()
  {
    A.rotate(); 
    B.rotate();
    C.rotate();
    D.rotate();
    ellipse(anchor.x, anchor.y, 15, 15);
  }

  // based on http://www.ecse.rpi.edu/Homepages/wrf/Research/Short_Notes/pnpoly.html
  // check if points is inside polygon

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

