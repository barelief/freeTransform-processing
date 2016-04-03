void mouseReleased()
{
  quad.release();
  quad.stateLocked = false;
  savePoints("A", quad.A,0);
  savePoints("B", quad.B,1);
  savePoints("C", quad.C,2);
  savePoints("D", quad.D,3);
}

void savePoints(String name, Point P, int id)
{
  JSONObject point = new JSONObject();
  point.setInt("x", (int)P.x);
  point.setInt("y", (int)P.y);
  point.setString("name", name);
  values.setJSONObject(id, point);
  saveJSONArray(values, "data/data.json");
}

void mousePressed()
{
  switch (quad.state)
  {

  case ROTATE:
    quad.setupPolygonRotate();
    quad.stateLocked = true;
    break;

  case AREA:
    quad.setupPolygonDrag();
    quad.stateLocked = true;
    break;

  case POINT:
    quad.stateLocked = true;
    break;
  }
}

void mouseDragged()
{
  switch (quad.state)
  {

  case ROTATE:
    quad.rotatePolygon();
    break;

  case AREA:
    quad.dragPolygon();
    break;

  case POINT:
    quad.updatePointPosition();
    break;
  }
}

