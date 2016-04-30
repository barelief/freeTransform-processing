/**
 *
 * Polygon class contains all information about polygon points and contains
 * all interaction, point and line update routines (formerly known as Quad, now Polygon class)
 * note: most methods are suitable for quad only, so creating more 
 * than 4 point polygon will be of no use, as some interactions will go wrong
 *
 * @author Bartosh Polonski
 * @version 0.3
 * @since 2016-04-30
 * 
 */

public class Polygon
{
  private int amount = 4; // how many edges in polygon
  int selectedPoint = -1; // currently mouse selected point http://i.imgur.com/Iq2ZZhT.jpg
  int selectedLine = -1; // currently mouse selected line

  Point[] point; // array of objects to contain point information
  Line[] line; // array of objects to contain line information

  PVector X, Y, Z, Q; // lines, made of line centre points, intersection points, aka lines which create PVector anchor (http://i.imgur.com/Vw7ZXAf.png)
  Line XZ, QY; // intersection Lines http://i.imgur.com/Vw7ZXAf.png

  Line diagonal; // line connecting current selected/focused point with opposite point -- used for SCALE_PORPORTIONALLY_POINT state
  Line leftOppositeLine, rightOppositeLine; // used for POINTS_SCALE_FREE to find offsetX on those lines (?)
  Line leftNeighborLine, rightNeighborLine, oppositeLine; // http://i.imgur.com/SsgvhtU.jpg
  float diagonalScaleFactor; // how's diagonal line being resized (proportion)

  // Variables needed for ROTATE state
  // http://i.imgur.com/uoUt5Lp.jpg
  PVector anchor; // the point arout which the rotations is being made
  PVector lockAnchor; // lock the anchor point (not sure if I need this var)
  PVector anchorLine; // the line which finds a rotation angle

  PVector center; // point where point lines intersect; http://i.imgur.com/uoUt5Lp.jpg

  // interaction vars
  PVector offsetP; // offset made with P
  PVector beginOffsetP; // initial P position to calculate offestP from it
  PVector offset;  // offset to move point offsetP made by moving user point P (check offsetPooint.pde)
  PVector beginOffset; // check check offsetPooint.pde NEED MORE explanation

  // boolean pointLockedToMouse = false; // if one of four points is dragged, then ignore other points by locking the selected one

  boolean polygonLockedToMouse = false;
  boolean rotationLockedToMouse = false;
  boolean mouseLockedToLine = false;
  boolean isOnThisSideOfLine = true; // on which line side is the mouse pointer (needed for mirror )

  boolean dragLock = false; // locks all detections when started dragging any object

  State state = State.NONE; // mouse interaction states, check State.java

  int pointMode = 0; // 0 - POINT, 1 - SCALE_FREE_POINT, 2 - SCALE_PORPORTIONALLY_POINT

  int lineMode = 0; //  0 - SCALE_PROPORTIONALLY_LINE, 1 - DRAG_FREE_LINE

  int rotateMode = 0; // 1 - rotate with 45degr step

  JSONArray values; // coordinates for polygons points loaded from external file

  boolean debugMode = false; // display / hide additional info (labels etc.)


  int id; // id of this Quad oobject
  boolean isSelected; // quad isSelected when we do any transformations to it

  Polygon(int id_)
  {
    id = id_;

    // interaction vars
    offsetP = new PVector();
    beginOffsetP = new PVector();
    beginOffset = new PVector(); 
    offset= new PVector();
    anchorLine = new PVector();
    lockAnchor = new PVector();

    center = new PVector();

    println("state: "+state);

    setupPoints(); //
    setupLines(); //

    createPoints(); // moved to parent class FreeTransform
    updateGlobalLines(); // aka init line objects
  }
  
  // create point objects
  void createPoints()
  {
      for (int j=0; j<amount; j++)
      {
        point[j] = new Point (0, 0, j, this);
        //println(i+": "+values.getJSONObject(i).getInt("x")+","+values.getJSONObject(i).getInt("y"));
      }
  }

  // this function sets the interaction state based on mouse position
  // listed by focus priority, i.e. first focus on point, then on line, then on area, then on rotate
  void fucusLocks()
  {
    // check if mouse is inside the polygon
    if (checkPointInsidePolygon (point, P) )
    {
      state = state.DRAG_AREA;
    } else 
    state = state.ROTATE;

    // check if mouse is close to the line
    for (int i=0; i<amount; i++)
    {
      if (line[i].pointCloseToLine() && !mouseLockedToLine)
      {
        selectedLine = i;
        switch(lineMode)
        {
        case 0:
          state = state.SCALE_PROPORTIONALLY_LINE;
          break;
        case 1:
          state = state.DRAG_FREE_LINE;
          break;
        }
      }
    }

    // check if mouse is close to the point
    for (int i=0; i<amount; i++)
    {
      if (point[i].isFocusedOnThePoint())
        switch (pointMode)
      {
      case 0:
        state = state.SCALE_FREE_POINT;
        break;
      case 1:
        state = state.DRAG_FREE_POINT;
        break;
      case 2:
        state = state.SCALE_PORPORTIONALLY_POINT;
        break;
      }
    }
  }

  // detects if we are focused on this quad (except the rotation)
  boolean isFocused()
  {
    if (state != state.ROTATE)
      return true;
    else return false;
  }

  // set-up line variables
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
    oppositeLine = new Line(new PVector(), new PVector());
  }

  // set-up point variables
  void setupPoints()
  {
    point = new Point[amount];
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

  // update line objects positions according to point positions
  void updateGlobalLines()
  {
    for (int i=0; i<amount; i++)
    {
      if (i != selectedLine) // do not update Line if it is being dragged (because dragging method already updates it
      {
        line[i] = new Line(point[neighborPointsFromLine(i)[1]].position, point[neighborPointsFromLine(i)[0]].position, i, this);
      }
    }
  }

  // update two global points based on currently dragged line (by using global var - selectedLine)
  void updateGlobalPoints(int id)
  {
    // update global points while dragging the line or it's separate points  
    point[neighborPointsFromLine(id)[1]].position.set(line[id].start); // right neighbor [1]
    point[neighborPointsFromLine(id)[0]].position.set(line[id].end); // left neighbor [0]
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

  // find neighbor id in array of objects
  int[] neighbor(int sourceId)
  {
    int opposite = ((sourceId+2)>amount-1) ? (sourceId+2)-amount : sourceId+2; // needed for 2 ir 3 array points
    int neighborLeft = ((sourceId+1)>amount-1) ? (sourceId+1)-amount : sourceId+1; // neede only for 3 array point
    int neighborRight = ((sourceId-1)<0) ? amount+(sourceId-1) : sourceId-1; // neede only  for 0 array pointer 
    int[] neighbors = { 
      neighborLeft, neighborRight, opposite // 0, 1, 2
    };
    return neighbors;
  }

  // useful for SCALE_FREE_POINT (?)
  Line[] neighborOppositeLinesFromPoint(int sourcePointId)
  {
    PVector leftNeighbor = new PVector(); 
    PVector rightNeighbor = new PVector(); 
    PVector opposite = new PVector(); 

    leftNeighbor.set(point[neighbor(sourcePointId)[0]].beginPosition);
    rightNeighbor.set(point[neighbor(sourcePointId)[1]].beginPosition);
    opposite.set(point[neighbor(sourcePointId)[2]].beginPosition);

    // create teporary lines from neighbor points
    Line leftOppositeLine = new Line(leftNeighbor, opposite);
    Line rightOppositeLine = new Line(rightNeighbor, opposite);

    Line[] lines = 
      { 
      leftOppositeLine, rightOppositeLine // 0,1
    };
    return lines;
  }

  // rendering, detecting, update functions
  void draw()
  {
    // detect which state is being selected with mouse
    if (!dragLock)
      fucusLocks(); 

    // display points and lines with their colourings
    for (int i=0; i<amount; i++)
    {
      point[i].draw();

      if (state==State.DRAG_AREA)
        stroke(255, 255, 0); 

      line[i].draw();
    }

    // display rotation ellipse in anchor position
    if (state == State.ROTATE && isSelected)
    {
      noFill();
      if (!dragLock)
        stroke(255, 255, 0); 
      else stroke(0, 255, 0);
      ellipse(anchor.x, anchor.y, 15, 15);
    }

    // display drag area rectangle in anchor position
    if (state == State.DRAG_AREA)
    {
      noFill();
      if (!dragLock)
        stroke(255, 255, 0); 
      else stroke(0, 255, 0);
      rect(anchor.x, anchor.y, 15, 15);
    }

    // update line positions based on global polygon points
    updateGlobalLines();  

    // display help information
    
    String selected = isSelected?" [selected]":"";
    text(id+selected, anchor.x+10, anchor.y);
    
    //display debug information
    if (debugMode)
      displayDebugInformation(); 

    // find line centres
    X = getLineCenter(point[0], point[1]); // AB
    Y = getLineCenter(point[1], point[2]); // BC
    Z = getLineCenter(point[2], point[3]); // CD
    Q = getLineCenter(point[3], point[0]); // DA

    // display line centres
    noFill();
    stroke(150);
    rectMode(CENTER);
    rect(X.x, X.y, 5, 5);
    rect(Y.x, Y.y, 5, 5);
    rect(Z.x, Z.y, 5, 5);
    rect(Q.x, Q.y, 5, 5);

    // find anchor point (aka intersection of lines from the centres of main lines)
    updateLineIntersections();

    // display anchor point
    rect(anchor.x, anchor.y, 5, 5);

    // check rotation routines (Point -> rotate())
    anchorLine = PVector.sub(P, anchor); 

    // display opposite objects
    // displayOppositeObject();
  }

  void displayOppositeObject()
  {
    // left neighbor - 0, right neigbor - 1, opposite - 2
    if (selectedLine >=0 || selectedPoint >= 0) // avoid out of bounds when slected object is none
    {
      stroke(255, 0, 0);
      switch(state) 
      {
      case DRAG_FREE_LINE:
        line(
          line[neighbor(selectedLine)[2]].start.x, 
          line[neighbor(selectedLine)[2]].start.y, 
          line[neighbor(selectedLine)[2]].end.x, 
          line[neighbor(selectedLine)[2]].end.y
          );
        break;

      case SCALE_FREE_POINT:

        ellipse(
          point[neighbor(selectedPoint)[2]].x, 
          point[neighbor(selectedPoint)[2]].y, 30, 30
          );
        break;
      }
    }
  }

  // Displays debug information
  // like invisible dot product X point, neighbors, intersections, states, point focus etc press D to see
  void displayDebugInformation()
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

    // diplayNeighborPoints();
  }

  // shows neighbors and opposite points to currently selected point (debug purpose)
  void diplayNeighborPoints()
  {
    for (int i=0; i<amount; i++)
    {
      if (point[i].position.dist(P) < 10)
      {
        pushStyle();
        fill(255, 255, 0);
        text(i, point[i].x+10, point[i].y+5); // draw selected point
        text("left neighbor", point[neighbor(i)[0]].x, point[neighbor(i)[0]].y);
        text("right neighbor", point[neighbor(i)[1]].x, point[neighbor(i)[1]].y);
        text("opposite", point[neighbor(i)[2]].x, point[neighbor(i)[2]].y);
        // neighbor(int sourcePointId)
        noFill();
        popStyle();
      }
    }

    if (state == State.SCALE_PORPORTIONALLY_POINT || state==State.SCALE_FREE_POINT)
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

  PVector getLineCenter(Point A, Point B)
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
    
    //isSelected = 
    // pointMode = 0; // switch to deafult point mode

    // TODO: release all lines in this class
  }

  // Drags the selected point while mouse is being dragged and state is DRAG_FREE_POINT
  void dragPoint()
  {
    offsetP = PVector.sub(P, beginOffsetP); // calculate the offset made by mouseDrag -- subtract beginOffsetP from P
    for (int i=0; i<amount; i++)
      point[i].drag();
  }

  // Setup the dragging of the selected point
  // function is called once mouse was pressed in DRAG_FREE_POINT state
  // initial offset vector positions (beginOffsetP, resetLockPoints()) are set
  void setupDragPoint()
  {
    beginOffsetP.set(P);
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

  // Setup the dragging of all points at the same time aka drag the polygon
  // function is called once mouse was pressed in DRAG_AREA state
  // sets initial offsetP vector positions
  void setupPolygonDrag()
  {
    selectedLine=-1;
    beginOffsetP.set(P);  
    for (int i=0; i<amount; i++)
      point[i].beginPosition.set(point[i].position);
  }

  // drag all points at the same time
  //  while mouse is being dragged and state is DRAG_AREA
  void dragPolygon()
  {
    offsetP = PVector.sub(P, beginOffsetP); // calculate the offsetP made by mouseDrag -- subtract beginOffsetP from P
    for (int i=0; i<amount; i++)
      point[i].position = PVector.add(point[i].beginPosition, offsetP);
  }

  // void dragEdge(Point start, Point end, boolean mirror, boolean lockAspect)

  // Setup the dragging of the selected line
  // this function is executed once when mouse was pressed in the DRAG_FREE_LINE state 
  // initial offset vector positions (beginOffsetP, resetLockPoints()) are set
  void setupDragLines()
  {
    mouseLockedToLine = true;
    beginOffsetP.set(P); // lock the beginning position of the offset vector
    for (int i=0; i<amount; i++) 
      line[i].resetLockPoints(P); // check
  }

  // Drag the selected line
  // this function is executed while mouse is being dragged and the state is DRAG_FREE_LINE
  void dragLines()
  {
    offsetP = PVector.sub(P, beginOffsetP); // calculate the offset made by mouseDrag -- subtract beginOffsetP from P

    for (int i=0; i<amount; i++) 
      line[i].drag();
  }

  // dragging the line scales polygon proportionally 
  // http://i.imgur.com/VnX6EWr.gif
  void setupLineScaleProportional()
  {
    // init start position of neighbor lines
    leftNeighborLine = line[neighbor(selectedLine)[0]];
    rightNeighborLine = line[neighbor(selectedLine)[1]];
    oppositeLine = line[neighbor(selectedLine)[2]];

    // reset their start values
    leftNeighborLine.resetLockPoints(P);
    rightNeighborLine.resetLockPoints(P);
    oppositeLine.resetLockPoints(P);

    beginP.set(P);

    oppositeLine.isOnThisSideOfLine = oppositeLine.checkLineSide(P); // check on which side of the mirror we are
  }

  // http://i.imgur.com/VnX6EWr.gif TODO: remove bounce effect
  void lineScaleProportional()
  {
    oppositeLine.detectX(P);
    float scaleFactor;
    scaleFactor = oppositeLine.X.dist(P) / oppositeLine.beginX.dist(beginP);

    PVector XP = new PVector(); // temporary vector XP http://i.imgur.com/bKosZNr.jpg

    PVector xpDirection = new PVector();
    // Scaling right neighbor:

    if (oppositeLine.checkLineSide(P) == oppositeLine.isOnThisSideOfLine)
      XP = PVector.sub(rightNeighborLine.beginEnd, rightNeighborLine.beginStart);
    else
      XP = PVector.sub(rightNeighborLine.beginStart, rightNeighborLine.beginEnd);
    XP.mult(scaleFactor);
    XP.add(rightNeighborLine.start);

    // right point neighbor id is alwas the same as line id, check drawing: http://i.imgur.com/iyZVj78.jpg
    // check int[] neighborPointsFromLine(int sourceLineId)
    point[neighborPointsFromLine(selectedLine)[1]].position.set(XP); // right neighbor point from selected line

    // Scaling left neighbor:
    if (oppositeLine.checkLineSide(P) == oppositeLine.isOnThisSideOfLine)
      XP = PVector.sub(leftNeighborLine.beginStart, leftNeighborLine.beginEnd);
    else
      XP = PVector.sub(leftNeighborLine.beginEnd, leftNeighborLine.beginStart);
    XP.mult(scaleFactor);
    XP.add(leftNeighborLine.end);

    point[neighborPointsFromLine(selectedLine)[0]].position.set(XP); // left neighbor point from selected line
  }

  // when draggin one the points, you freele scale the polygon
  // http://i.imgur.com/qXuA8Pa.gif
  void setupPointScaleFree()
  {
    beginOffsetP.set(P);

    leftOppositeLine = neighborOppositeLinesFromPoint(selectedPoint)[0];
    rightOppositeLine = neighborOppositeLinesFromPoint(selectedPoint)[1];
    leftOppositeLine.resetLockPoints(P);
    rightOppositeLine.resetLockPoints(P);
    beginP.set(P);
    beginOffsetP.set(P);

    beginOffset.set(mouseX, mouseY); // lock the beginning position of the offset vector
    beginOffsetP.set(point[selectedPoint].position); // lock the beginning of the vector to be transformed

    leftOppositeLine.isOnThisSideOfLine = leftOppositeLine.checkLineSide(P); // check on which side of the mirror we are
    rightOppositeLine.isOnThisSideOfLine = rightOppositeLine.checkLineSide(P);
  }

  // when draggin one the points, you freely scale the polygon
  // http://i.imgur.com/qXuA8Pa.gif
  void pointScaleFree()
  {
    //offsetP = PVector.sub(P, beginOffsetP); // get the offset (because mouse isnt' exatly at the pressed point, there a little offset)
    offset = PVector.sub(P, beginOffset); // calculate the offset made by mouseDrag -- subtract beginOffset from P
    offsetP = PVector.add(beginOffsetP, offset); // reposition point A based the offset made

    leftOppositeLine.detectX(offsetP); // update X (dot product magic) constantly
    rightOppositeLine.detectX(offsetP); // update X (dot product magic) constantly

    float scaleFactorRight, scaleFactorLeft;
    scaleFactorRight = rightOppositeLine.X.dist(offsetP) / rightOppositeLine.beginX.dist(beginOffsetP);
    scaleFactorLeft = leftOppositeLine.X.dist(offsetP) / leftOppositeLine.beginX.dist(beginOffsetP);

    // needs exaplainin drawing
    PVector tmpR = new PVector();
    PVector tmpL = new PVector();

    if (rightOppositeLine.isOnThisSideOfLine == rightOppositeLine.checkLineSide(offsetP))
    { 
      if (leftOppositeLine.isOnThisSideOfLine == leftOppositeLine.checkLineSide(offsetP))
      {
        tmpR = PVector.sub(rightOppositeLine.beginStart, rightOppositeLine.beginEnd);
        tmpL = PVector.sub(leftOppositeLine.beginStart, leftOppositeLine.beginEnd);
      } else 
      {
        tmpR = PVector.sub(rightOppositeLine.beginEnd, rightOppositeLine.beginStart);
        tmpL = PVector.sub(leftOppositeLine.beginStart, leftOppositeLine.beginEnd);
      }
    } else 
    { 
      if (leftOppositeLine.isOnThisSideOfLine == leftOppositeLine.checkLineSide(offsetP))
      {
        tmpR = PVector.sub(rightOppositeLine.beginStart, rightOppositeLine.beginEnd);
        tmpL = PVector.sub(leftOppositeLine.beginEnd, leftOppositeLine.beginStart);
      } else 
      {
        tmpR = PVector.sub(rightOppositeLine.beginEnd, rightOppositeLine.beginStart);
        tmpL = PVector.sub(leftOppositeLine.beginEnd, leftOppositeLine.beginStart);
      }
    }

    // needs exaplainin drawing

    tmpL.mult(scaleFactorRight);
    tmpL.add(leftOppositeLine.end);

    tmpR.mult(scaleFactorLeft);
    tmpR.add(rightOppositeLine.end);


    // set left neigbor point 
    point[neighbor(selectedPoint)[0]].position.set(tmpL);

    // set right neighbor point
    point[neighbor(selectedPoint)[1]].position.set(tmpR);
    point[selectedPoint].position.set(offsetP);
    selectedLine = -1; // disable line focus
    updateGlobalLines();
  }

  void setupScalePointProportionally()
  {

    beginOffset.set(mouseX, mouseY); // lock the beginning position of the offset vector
    beginOffsetP.set(point[selectedPoint].position); // lock the beginning of the vector to be transformed

    leftOppositeLine = neighborOppositeLinesFromPoint(selectedPoint)[0];
    rightOppositeLine = neighborOppositeLinesFromPoint(selectedPoint)[1];
    leftOppositeLine.resetLockPoints(P);
    rightOppositeLine.resetLockPoints(P);

    leftOppositeLine.isOnThisSideOfLine = leftOppositeLine.checkLineSide(P); // check on which side of the mirror we are
    rightOppositeLine.isOnThisSideOfLine = rightOppositeLine.checkLineSide(P);

    diagonal = new Line (point[neighbor(selectedPoint)[2]].position, point[selectedPoint].position);
    diagonal.resetLockPoints(P);
    diagonal.beginOffsetX.set(point[selectedPoint].position); // lock the beginning of the vector to be transformed
    diagonal.beginStart.set(diagonal.X); // lock the beginning position of the offset vector
  }

  void scalePointProportionally()
  {
    offset = PVector.sub(P, beginOffset); // calculate the offset made by mouseDrag -- subtract beginOffset from P
    offsetP = PVector.add(beginOffsetP, offset); // reposition point A based the offset made

    // PROPORTIONAL MODE
    diagonal.detectX(P); // aka find X
    // diagonal.offsetX = PVector.sub(diagonal.X, diagonal.beginX); // calculate the offset made by X
    diagonal.end = PVector.add(diagonal.beginEnd, diagonal.offsetX);

    point[selectedPoint].position.set(diagonal.end);

    // offsetP = PVector.sub(P, beginOffsetP); // get the offset (because mouse isnt' exatly at the pressed point, there a little offset)
    offset = PVector.sub(diagonal.X, diagonal.beginStart); // calculate the offset made by mouseDrag -- subtract beginOffset from P
    diagonal.offsetX = PVector.add(diagonal.beginOffsetX, offset); // reposition point A based the offset made

    diagonalScaleFactor = diagonal.start.dist(diagonal.offsetX) / diagonal.start.dist(diagonal.beginOffsetX);

    // needs exaplainin drawing
    PVector tmpR = new PVector();
    PVector tmpL = new PVector();


    if (rightOppositeLine.isOnThisSideOfLine == rightOppositeLine.checkLineSide(diagonal.offsetX))
    { 
      if (leftOppositeLine.isOnThisSideOfLine == leftOppositeLine.checkLineSide(diagonal.offsetX))
      {
        tmpR = PVector.sub(rightOppositeLine.beginStart, rightOppositeLine.beginEnd);
        tmpL = PVector.sub(leftOppositeLine.beginStart, leftOppositeLine.beginEnd);
      } else 
      {
        tmpR = PVector.sub(rightOppositeLine.beginStart, rightOppositeLine.beginEnd);
        tmpL = PVector.sub(leftOppositeLine.beginStart, leftOppositeLine.beginEnd);
      }
    } else 
    { 
      if (leftOppositeLine.isOnThisSideOfLine == leftOppositeLine.checkLineSide(diagonal.offsetX))
      {
        tmpR = PVector.sub(rightOppositeLine.beginStart, rightOppositeLine.beginEnd);
        tmpL = PVector.sub(leftOppositeLine.beginStart, leftOppositeLine.beginEnd);
      } else 
      {
        tmpR = PVector.sub(rightOppositeLine.beginEnd, rightOppositeLine.beginStart);
        tmpL = PVector.sub(leftOppositeLine.beginEnd, leftOppositeLine.beginStart);
      }
    }

    // needs exaplainin drawing

    tmpL.mult(diagonalScaleFactor);
    tmpL.add(leftOppositeLine.end);

    tmpR.mult(diagonalScaleFactor);
    tmpR.add(rightOppositeLine.end);


    // set left neigbor point 
    point[neighbor(selectedPoint)[0]].position.set(tmpL);

    // set right neighbor point
    point[neighbor(selectedPoint)[1]].position.set(tmpR);

    selectedLine = -1; // disable line focus
    updateGlobalLines();
  }

  // Set-up proportional scaling. 
  // This function is triggered once the mouse is pressed and focused on point while holding SHIFT)
  void setupScalePointProportionally2()
  {

    diagonal = new Line (point[neighbor(selectedPoint)[2]].position, point[selectedPoint].position);
    diagonal.resetLockPoints(P);
  }

  // This function is called whie dragging the selected point at SCALE_PORPORTIONALLY_POINT state,  
  // it "scales" the whole corner proportionally (aka according to aspect of the polygon)

  void scalePointProportionally2()
  {
    fill(255, 0, 0);
    ellipse(point[neighbor(selectedPoint)[2]].position.x, point[neighbor(selectedPoint)[2]].position.y, 30, 30);
    ellipse(point[neighbor(selectedPoint)[1]].position.x, point[neighbor(selectedPoint)[1]].position.y, 20, 20);
    ellipse(point[neighbor(selectedPoint)[0]].position.x, point[neighbor(selectedPoint)[0]].position.y, 10, 10);
    // offsetP = PVector.sub(P, beginP); // calculate the offset made by P
    diagonal.detectX(P); // aka find X
    // diagonal.offsetX = PVector.sub(diagonal.X, diagonal.beginX); // calculate the offset made by X
    diagonal.end = PVector.add(diagonal.beginEnd, diagonal.offsetX);
    diagonalScaleFactor = diagonal.start.dist(diagonal.X) / diagonal.start.dist(diagonal.beginX);
    point[selectedPoint].position.set(diagonal.end);

    // scale neighbors
    PVector leftNeighbor = new PVector(); 
    PVector rightNeighbor = new PVector(); 
    PVector opposite = new PVector(); 
    leftNeighbor.set(point[neighbor(selectedPoint)[0]].beginPosition);
    rightNeighbor.set(point[neighbor(selectedPoint)[1]].beginPosition);
    opposite.set(point[neighbor(selectedPoint)[2]].beginPosition);

    leftNeighbor.sub(opposite);
    leftNeighbor.mult(diagonalScaleFactor);
    leftNeighbor.add(opposite);
    point[neighbor(selectedPoint)[0]].position.set(leftNeighbor);

    rightNeighbor.sub(opposite);
    rightNeighbor.mult(diagonalScaleFactor);
    rightNeighbor.add(opposite);
    point[neighbor(selectedPoint)[1]].position.set(rightNeighbor);
  }

  // set center based on interesections of lines made of corners 
  // updates PVector center (http://i.imgur.com/MGpMI2E.png)
  void setCenter()
  {
    Line line02 = new Line( new PVector(), new PVector() );
    Line line13 = new Line( new PVector(), new PVector() );
    line02.set(point[0].position, point[2].position);
    line13.set(point[1].position, point[3].position);
    if (line02.intersects_at(line13) != null) // if two points are on each other
      center.set( line02.intersects_at(line13) );
  }

  // This function is runnig while mouseWheel is triggered or +/- keys are pressed
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

  // Set-up rotation of the polygon
  void setupPolygonRotate()
  {
    rotationLockedToMouse = true;
    //polygonLockedToMouse = true; 
    lockAnchor.set(anchor);
    for (int i=0; i<amount; i++)
      point[i].startRotating();
  }

  // This function rotates polygon (aka all points) around anchor point, check rotate() inside Point class
  // called while mouse is being dragged in ROTATE state 
  void rotatePolygon()
  {
    for (int i=0; i<amount; i++)
      point[i].rotate();
  }

  // this function checks if input is inside polygon
  // based on http://www.ecse.rpi.edu/Homepages/wrf/Research/Short_Notes/pnpoly.html
  // points is an array of polygon points; input is point to check if its iside polygon (aka mouse)
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