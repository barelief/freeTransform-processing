/*
* class to contain all information about polygon and contains all interaction routines 
 * formerly known as Quad class
 * note: most methods are suitable for quad only, so probably creating more that 4 point polygon will be of no use
 */

class Polygon
{
  Point[] point;

  PVector X, Y, Z, Q; // lines, made of line center points, intersection points, aka lines which create PVector anchor 
  int selectedLine = -1;
  int selectedPoint = -1; // http://i.imgur.com/Iq2ZZhT.jpg
  Line[] line;

  Line XZ, QY; // intersection Lines 

  Line diagonal; // line connecting current selected/focused point with opposite point -- user for POINT_SCALE_PROPORTIONAL state
  Line leftOppositeLine, rightOppositeLine; // used for POINTS_SCALE_FREE to find offsetX on those lines (?)
  Line leftNeighborLine, rightNeighborLine; // http://i.imgur.com/Iq2ZZhT.jpg
  float diagonalScaleFactor;

  // rotation vars?
  PVector anchor;
  PVector lockAnchor;
  PVector anchorLine; // need for rotation

  PVector center; // point where corner point lines intersect;


  // interaction vars
  PVector offset;
  PVector beginOffset;

  // boolean pointLockedToMouse = false; // if one of four points is dragged, then ignore other points by locking the selected one
  boolean polygonLockedToMouse = false;
  boolean rotationLockedToMouse = false;
  boolean mouseLockedToLine = false;

  boolean dragLock = false; // locks all detections when started dragging any object

  State state = State.NONE;

  int pointMode = 0; // 0 - POINT, 1 - POINT_SCALE_FREE, 2 - POINT_SCALE_PROPORTIONAL

  JSONArray values; // coordinates for polygons points loaded from external file

  boolean debugMode = false; // display / hide additional info (labels etc.)
  boolean helpMode = false; // 

  Polygon()
  {
    // interaction vars
    offset = new PVector();
    beginOffset = new PVector();
    anchorLine = new PVector();
    lockAnchor = new PVector();

    center = new PVector();

    println("state: "+state);

    setupPoints(); //
    setupLines(); //

    loadValues(); //
    updateGlobalLines(); // aka init line objects
  }

  void fucusLocks()
  {

    // listed by focus priority, i.e. first focus on point, then on edge then on area, then on rotate
    if (checkPointInsidePolygon (point, P) )
    {
      state = state.AREA;
    } else 
      state = state.ROTATE;

    for (int i=0; i<amount; i++)
    {
      if (line[i].pointCloseToLine() && !mouseLockedToLine)
      {
        selectedLine = i;
        state = state.EDGE;
      }
    }

    for (int i=0; i<amount; i++)
    {
      if (point[i].isFocusedOnThePoint())
        switch (pointMode)
        {
        case 0:
          state = state.POINT_SCALE_FREE;
          break;
        case 1:
          state = state.POINT;
          break;
        case 2:
          state = state.POINT_SCALE_PROPORTIONAL;
          break;
        }
    }
  }

  void setupLines()
  {
    // init vector to find line intersections and centroid
    line = new Line[amount];
    setupLineIntersections(); // XZ QY
    diagonal = new Line(new PVector(), new PVector());
    leftOppositeLine = new Line(new PVector(), new PVector());
    rightOppositeLine = new Line(new PVector(), new PVector());
    leftNeighborLine = new Line(new PVector(), new PVector());
    rightNeighborLine = new Line(new PVector(), new PVector());
  }

  void setupPoints()
  {
    // init polygon points vars
    point = new Point[amount];
  }

  void loadValues()
  {
    values = new JSONArray();

    // try loading coordinates of polygon points from an external file
    try {
      values = loadJSONArray("data.json");
    } 
    catch (Exception e) {
      e.printStackTrace();
      println("data file not found.. but dont worry, we'll create that later..");

      // if external file does not exist, make a default poin arrangement as in resetPosition();
      resetPosition();
    };

    setupValues(values);
  }

  void setupValues(JSONArray values)
  {
    println("--> setting up values..");
    // load points form external file

    for (int i=0; i<amount; i++)
    {
      point[i] = new Point (values.getJSONObject(i).getInt("x"), values.getJSONObject(i).getInt("y"), i);
      println(i+": "+values.getJSONObject(i).getInt("x")+","+values.getJSONObject(i).getInt("y"));
    }
  }

  void resetPosition()
  {
    println ("resetting position...");

    // reset all points so they are drawn in the center with equal distance between each other
    for (int i=0; i<amount; i++)
    {
      JSONObject pointsToSave = new JSONObject();
      int radius=width/4;
      float angle = map(i, 0, amount, PI, -PI); // position points evenly from -PI to +PI
      PVector shift = new PVector(sin(angle)*radius+width/2, cos(angle)*radius+height/2); //  on the circumference of a circle of "radius" in the center (w/2, h/2)
      point[i] = new Point(shift.x, shift.y, i);

      pointsToSave.setInt("x", (int)shift.x);
      pointsToSave.setInt("y", (int)shift.y);
      values.setJSONObject(i, pointsToSave);
    }
    selectedLine = -1;
    updateGlobalLines();
  }

  void updateGlobalLines()
  {
    for (int i=0; i<amount; i++)
    {
      if (i != selectedLine) // do not update Line if it is being dragged (because dragging method already updates it
      {
        line[i] = new Line(point[neighborPointsFromLine(i)[1]].position, point[neighborPointsFromLine(i)[0]].position, i);
      }
    }
  }

  // find neighbor points based on a source line id, check drawing: http://i.imgur.com/iyZVj78.jpg
  // here we assume the line always begins from right to left
  int[] neighborPointsFromLine(int sourceLineId)
  {
    // http://i.imgur.com/3nWXfwA.jpg
    int neighborLeft; 
    if (sourceLineId == amount-1) 
      neighborLeft = 0; // amount - 1 in quad means line[3] aka the last line in quad/polygon
    else 
      neighborLeft = sourceLineId+1; // otherwise left neigbor is always id+1; i.e. if line[2] then left neigbor is point[3], see drawing: http://i.imgur.com/iyZVj78.jpg

    int neighborRight = sourceLineId; // right neighbor id is alwas the same as line id, check drawing: http://i.imgur.com/iyZVj78.jpg
    int[] neighbors = {
      neighborLeft, neighborRight
    };
    return neighbors;
  }

  int[] neighborPointsFromPoint(int sourcePointId)
  {

    // check shiftPoints.pde
    int opposite = ((sourcePointId+2)>amount-1) ? (sourcePointId+2)-amount : sourcePointId+2; // needed for 2 ir 3 array points
    int neighborLeft = ((sourcePointId+1)>amount-1) ? (sourcePointId+1)-amount : sourcePointId+1; // neede only for 3 array point
    int neighborRight = ((sourcePointId-1)<0) ? amount+(sourcePointId-1) : sourcePointId-1; // neede only  for 0 array pointer 
    int[] neighbors = { 
      neighborLeft, neighborRight, opposite // 0, 1, 2
    };
    return neighbors;
  }

  // useful for POINT_SCALE_FREE (?)
  Line[] neighborOppositeLinesFromPoint(int sourcePointId)
  {
    PVector leftNeighbor = new PVector(); 
    PVector rightNeighbor = new PVector(); 
    PVector opposite = new PVector(); 

    leftNeighbor.set(point[neighborPointsFromPoint(sourcePointId)[0]].beginPosition);
    rightNeighbor.set(point[neighborPointsFromPoint(sourcePointId)[1]].beginPosition);
    opposite.set(point[neighborPointsFromPoint(sourcePointId)[2]].beginPosition);

    // create teporary lines from neighbor points
    Line leftOppositeLine = new Line(leftNeighbor, opposite);
    Line rightOppositeLine = new Line(rightNeighbor, opposite);

    Line[] lines = 
    { 
      leftOppositeLine, rightOppositeLine // 0,1
    };
    return lines;
  }

  void setupLineIntersections()
  {
    XZ  = new Line( new PVector(), new PVector() );
    QY  = new Line( new PVector(), new PVector() );
    anchor = new PVector();
  }

  void updateLineIntersections()
  {
    XZ.set(X, Z);
    QY.set(Q, Y);
    if (XZ.intersects_at(QY) != null) // if two points are on each other
      anchor = XZ.intersects_at(QY);

    setCenter();
  }

  void draw()
  {
    //if (!pointLockedToMouse && !rotationLockedToMouse)

    //polygonCheck();
    if (!dragLock)
      fucusLocks();

    for (int i=0; i<amount; i++)
    {
      point[i].draw();

      if (state==State.AREA)
        stroke(255, 255, 0); 

      line[i].draw();
    }

    if (state == State.ROTATE)
    {
      noFill();
      if (!dragLock)
        stroke(255, 255, 0); 
      else stroke(0, 255, 0);
      ellipse(anchor.x, anchor.y, 15, 15);
    }

    if (state == State.AREA)
    {
      noFill();
      if (!dragLock)
        stroke(255, 255, 0); 
      else stroke(0, 255, 0);
      rect(anchor.x, anchor.y, 15, 15);
    }

    // lines
    //for (int i=0; i<amount; i++)
    //line[i].render(); // displayLines and their colors

    updateGlobalLines(); // update line positions based on global polygon points 

      X = lineCenter(point[0], point[1]); // AB
    Y = lineCenter(point[1], point[2]); // BC 
    Z = lineCenter(point[2], point[3]); // CD
    Q = lineCenter(point[3], point[0]); // DA


    stroke(255);
    if (!helpMode)
      text("press H for help", 40, 40); 
    else 
      text("mode: "+quad.state+
      "\npress D for debug\n"+
      "press R to reset\n"+
      "MOUSESCROLL or +/- keyboard to zoom in/out\n"+
      "hold CTRL to free transform\n"+
      "hold SHIFT to scale proportionally transform\n"+
      "↑ ↓ ← → to update selected mode with keyboard\n"+
      "press H to hide this help info"
      , 40, 40);
    if (debugMode)
      debug(); 


    noFill();
    stroke(150);
    rectMode(CENTER);
    rect(X.x, X.y, 5, 5);
    rect(Y.x, Y.y, 5, 5);
    rect(Z.x, Z.y, 5, 5);
    rect(Q.x, Q.y, 5, 5);

    rect(anchor.x, anchor.y, 5, 5);
    updateLineIntersections();
    anchorLine = PVector.sub(P, anchor); // check rotation routines
  }

  void debug()
  {
    text("X", X.x+10, X.y+5);
    text("Y", Y.x+10, Y.y+5);
    text("Z", Z.x+10, Z.y+5);
    text("Q", Q.x+10, Q.y+5);
    fill(255);

    String pointFocuses = "";
    String stickedPoints = "";
    for (int i=0; i<amount; i++)
    {
      pointFocuses+= point[i].isFocusedOnThePoint() + " ";
      stickedPoints+= point[i].sticked + " ";

      //fill(200);
      text(i, point[i].x+10, point[i].y+5);
    }

    text("state: "+state+
      "\nfocused on line: "+selectedLine+
      "\nfocused on point: "+selectedPoint+
      "\nmouseLockedToLine: "+mouseLockedToLine+
      "\npointFocuses: "+pointFocuses+
      "\nstickedPoints: "+stickedPoints+
      "\ndragLock: "+dragLock+
      "\ndiagonal scale factor: "+diagonalScaleFactor+
      "\npress D to hide debug", 40, height-160);

    diplayNeighborPoints();
  }

  void diplayNeighborPoints()
  {
    for (int i=0; i<amount; i++)
    {
      if (point[i].position.dist(P) < 10)
      {
        pushStyle();
        fill(255, 255, 0);
        text(i, point[i].x+10, point[i].y+5); // draw selected point
        text("left neighbor", point[neighborPointsFromPoint(i)[0]].x, point[neighborPointsFromPoint(i)[0]].y);
        text("right neighbor", point[neighborPointsFromPoint(i)[1]].x, point[neighborPointsFromPoint(i)[1]].y);
        text("opposite", point[neighborPointsFromPoint(i)[2]].x, point[neighborPointsFromPoint(i)[2]].y);
        // neighborPointsFromPoint(int sourcePointId)
        noFill();
        popStyle();
      }
    }

    if (state==State.POINT_SCALE_PROPORTIONAL || state==State.POINT_SCALE_FREE)
      displayLineBetweenCurrentAndOppositePoints();
  }

  void displayLineBetweenCurrentAndOppositePoints()
  {
    pushStyle();
    stroke(255, 255, 0);
    line(diagonal.start.x, diagonal.start.y, diagonal.end.x, diagonal.end.y);
    text("X", diagonal.X.x, diagonal.X.y);
    // line(0, 0, diagonal.offsetX.x, diagonal.offsetX.y);
    text("beginX", diagonal.beginX.x, diagonal.beginX.y);
    // text("start", diagonal.start.x, diagonal.start.y);
    // text("end", diagonal.end.x, diagonal.end.y);
    popStyle();
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

    println("---> releasing... ");
    for (int i=0; i<amount; i++)
    {
      point[i].sticked = false;
      point[i].beginPosition.set(point[i].position);
    }

    dragLock = false; // 
    mouseLockedToLine = false;
    polygonLockedToMouse = false;
    // pointLockedToMouse = false;
    rotationLockedToMouse = false;
    selectedLine=-1;

    // pointMode = 0; // switch to deafult point mode

    // TODO: release all lines in this class
  }

  void updatePointPosition()
  {
    offset = PVector.sub(P, beginOffset); // calculate the offset made by mouseDrag -- subtract beginOffset from P
    for (int i=0; i<amount; i++)
      point[i].drag();
  }

  void setupPointDrag()
  {
    beginOffset.set(P);  
    for (int i=0; i<amount; i++) 
      if (point[i].isFocusedOnThePoint()) 
      {
        point[i].sticked =true;
        point[i].reset();
        break; // breaks the loop, so only one point is selected
      }
    // updateGlobalLines() updates all but selectedLine, thats why when dragging points selectedLine none of existing lines
    selectedLine = -1;
  }

  void setupPolygonDrag()
  {
    selectedLine=-1;
    beginOffset.set(P);  
    for (int i=0; i<amount; i++)
      point[i].beginPosition.set(point[i].position);
  }

  void dragPolygon()
  {
    offset = PVector.sub(P, beginOffset); // calculate the offset made by mouseDrag -- subtract beginOffset from P
    for (int i=0; i<amount; i++)
      point[i].position = PVector.add(point[i].beginPosition, offset);
  }

  // void dragEdge(Point start, Point end, boolean mirror, boolean lockAspect)

  // check Edit transform for more options like "warp"
  void setupDragEdges()
  {
    mouseLockedToLine = true;
    beginOffset.set(P); // lock the beginning position of the offset vector
    for (int i=0; i<amount; i++) 
      line[i].checkInteraction(); // check
  }

  void dragEdges()
  {
    offset = PVector.sub(P, beginOffset); // calculate the offset made by mouseDrag -- subtract beginOffset from P

    for (int i=0; i<amount; i++) 
      line[i].drag();
  }

  void setupPointScaleProportional()
  {
    diagonal = new Line (point[neighborPointsFromPoint(selectedPoint)[2]].position, point[selectedPoint].position);
    diagonal.resetLockPoints();
  }

  void setupPointScaleFree()
  {
    leftOppositeLine = neighborOppositeLinesFromPoint(selectedPoint)[0];
    rightOppositeLine = neighborOppositeLinesFromPoint(selectedPoint)[1];
    leftOppositeLine.resetLockPoints();
    rightOppositeLine.resetLockPoints();
  }

  // aka when dragging the point, it "scales" the whole corner proportionally
  void pointScaleProportional()
  {
    // offsetP = PVector.sub(P, beginP); // calculate the offset made by P
    diagonal.detectX(); // aka find X
    // diagonal.offsetX = PVector.sub(diagonal.X, diagonal.beginX); // calculate the offset made by X
    diagonal.end = PVector.add(diagonal.beginEnd, diagonal.offsetX);
    diagonalScaleFactor = diagonal.start.dist(diagonal.X) / diagonal.start.dist(diagonal.beginX);
    point[selectedPoint].position.set(diagonal.end);

    // scale neighbors
    PVector leftNeighbor = new PVector(); 
    PVector rightNeighbor = new PVector(); 
    PVector opposite = new PVector(); 
    leftNeighbor.set(point[neighborPointsFromPoint(selectedPoint)[0]].beginPosition);
    rightNeighbor.set(point[neighborPointsFromPoint(selectedPoint)[1]].beginPosition);
    opposite.set(point[neighborPointsFromPoint(selectedPoint)[2]].beginPosition);

    leftNeighbor.sub(opposite);
    leftNeighbor.mult(diagonalScaleFactor);
    leftNeighbor.add(opposite);
    point[neighborPointsFromPoint(selectedPoint)[0]].position.set(leftNeighbor);

    rightNeighbor.sub(opposite);
    rightNeighbor.mult(diagonalScaleFactor);
    rightNeighbor.add(opposite);
    point[neighborPointsFromPoint(selectedPoint)[1]].position.set(rightNeighbor);
  }

  void pointScaleFree()
  {
    leftOppositeLine.detectX(); // update X (dot product magic) constantly
    rightOppositeLine.detectX(); // update X (dot product magic) constantly
    point[neighborPointsFromPoint(selectedPoint)[0]].position = PVector.add(point[neighborPointsFromPoint(selectedPoint)[0]].beginPosition, leftOppositeLine.offsetX);
    point[neighborPointsFromPoint(selectedPoint)[1]].position = PVector.add(point[neighborPointsFromPoint(selectedPoint)[1]].beginPosition, rightOppositeLine.offsetX);
    point[selectedPoint].position.set(P);
    selectedLine = -1; // disable line focus
    updateGlobalLines();
  }

  void setCenter()
  {
    Line line02 = new Line( new PVector(), new PVector() );
    Line line13 = new Line( new PVector(), new PVector() );
    line02.set(point[0].position, point[2].position);
    line13.set(point[1].position, point[3].position);
    if (line02.intersects_at(line13) != null) // if two points are on each other
      center.set( line02.intersects_at(line13) );
  }

  void scaleArea(float scaleFactor)
  {
    // for more advanced (more than 4 points), use this algorithm: 
    // http://stackoverflow.com/questions/1109536/an-algorithm-for-inflating-deflating-offsetting-buffering-polygons
    for (int i=0; i<amount; i++)
    {
      PVector tmp = PVector.sub(point[i].position, anchor);
      tmp.mult(scaleFactor); 
      point[i].position.set(PVector.add(anchor, tmp));
    }
  }


  void setupPolygonRotate()
  {
    rotationLockedToMouse = true;
    //polygonLockedToMouse = true; 
    lockAnchor.set(anchor);
    for (int i=0; i<amount; i++)
      point[i].startRotating();
  }

  void rotatePolygon()
  {
    // rotates polygon (aka all points) around anchor point, check rotate() inside Point class
    for (int i=0; i<amount; i++)
      point[i].rotate();
  }

  // based on http://www.ecse.rpi.edu/Homepages/wrf/Research/Short_Notes/pnpoly.html
  // check if input is inside polygon
  // points is an array of polygon points; input is point to check if its iside polygon
  boolean checkPointInsidePolygon(Point[] points, PVector input)
  {
    int i, j;
    boolean c = false;
    for (i = 0, j = points.length-1; i < points.length; j = i++) {
      if ( ((points[i].y>input.y) != (points[j].y>input.y)) &&
        (input.x < (points[j].x-points[i].x) * (input.y-points[i].y) / (points[j].y-points[i].y) + points[i].x) )
        c = !c;
    }
    return c;
  }
}

