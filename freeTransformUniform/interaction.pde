void savePoints()
{
  for (int i=0; i<amount; i++)
  {
    JSONObject pointToSave = new JSONObject();
    pointToSave.setInt("x", (int)quad.point[i].position.x);
    pointToSave.setInt("y", (int)quad.point[i].position.y);
    quad.values.setJSONObject(i, pointToSave);
  }

  saveJSONArray(quad.values, "data/data.json");
  println("---> Values saved to disk...");
}

void mouseReleased()
{
  if (mouseButton == LEFT)
  {
    quad.release(); // release all locks
    savePoints(); // save current polygon points to external file
  }
}

void keyReleased()
{
  if (!quad.dragLock)
  {
    quad.pointMode = 0; // if no key is selected then return to deafault mode (POINT_SCALE_FREE
    savePoints(); // save current polygon points to external file
  }
}

void mousePressed()
{
  if (mouseButton == LEFT)
  {
    println ("---> state: "+quad.state);
    switch (quad.state)
    {

    case EDGE:
      quad.setupDragEdges();
      quad.dragLock = true;
      break;

    case ROTATE:
      quad.setupPolygonRotate();
      quad.dragLock = true;
      break;

    case AREA:
      quad.setupPolygonDrag();
      quad.dragLock = true;
      break;

    case POINT:
      quad.setupPointDrag();
      quad.dragLock = true;
      break;

    case POINT_SCALE_PROPORTIONAL:
      quad.setupPointScaleProportional();
      quad.dragLock = true;
      break;

    case POINT_SCALE_FREE:
      quad.setupPointScaleFree();
      quad.dragLock = true;
      break;
    }
  }
}

void mouseDragged()
{
  if (mouseButton == LEFT)
  {
    switch (quad.state)
    {
    case EDGE:
      quad.dragEdges();
      break;

    case ROTATE:
      quad.rotatePolygon();
      break;

    case AREA:
      quad.dragPolygon();
      break;

    case POINT:
      quad.updatePointPosition();
      break;

    case POINT_SCALE_PROPORTIONAL:
      quad.pointScaleProportional();
      break;

    case POINT_SCALE_FREE:
      quad.pointScaleFree();
      break;
    }
  }
}

void keyPressed()
{
  quad.selectedLine=key-49;

  switch(key)
  {
  case 'r':
    quad.resetPosition(); // reset 
    quad.setupValues(quad.values); // load resetted values
    break;

  case 'd':
    quad.debugMode=!quad.debugMode;
    break;

  case 'h':
    quad.helpMode=!quad.helpMode;
    break;

  case CODED:
    switch (keyCode)
    {
    case CONTROL: // state = POINT
      quad.pointMode = 1;
      break;

    case SHIFT: // state = POINT_SCALE_PROPORTIONAL
      quad.pointMode = 2;
      break;
    }
    break;
  case '+': 
    quad.scaleArea(1+scalingSensitivity);
    break;
  case '-': 
    quad.scaleArea(1-scalingSensitivity);
    break;
  }
}


float scalingSensitivity = .05;

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  println(e);
  if (e < 0) quad.scaleArea(1-scalingSensitivity);
  else quad.scaleArea(1+scalingSensitivity);
}