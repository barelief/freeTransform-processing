
// update all lines based on all points
void updateGlobalLines()
{
  for (int i=0; i<amount; i++)
  {
    if (i!=selectedLine) // do not update Line if it is being dragged (because dragging method already updates it
    {
      line[i] = new Line(point[neighbors(i)[1]].position, point[neighbors(i)[0]].position, i); //<>//
    }
  }
}

// find neighbor points based on a source line id, check drawing: http://i.imgur.com/iyZVj78.jpg
// here we assume the line always begins from right to left
int[] neighbors(int sourceLineId)
{
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

// clas to draw a line
class Line
{
  Point start, end; // start and end of a line
  PVector beginStart, beginEnd; // saving the position of start and end line points before dragging the mouse
  int id; // id of a line on a quad, see drawing to understand the id in an array of four lines: http://i.imgur.com/iyZVj78.jpg
  Line (PVector start_, PVector end_, int id_)
  {
    start = new Point(start_);
    end = new Point(end_);
    beginStart = new PVector();
    beginEnd = new PVector();
    id = id_;
  }

  void render()
  {
    if (selectedLine==id) stroke(255, 0, 0); 
    else stroke(0);
    line(start.position.x, start.position.y, end.position.x, end.position.y);
  }

  // update two global points based on currently dragged line (by using global var - selectedLine)
  void updateGlobalPoints()
  {
    if (selectedLine == id) // detect which line in lines array will be updated
    {
      // update global points while dragging the line or it's separate points  
      point[neighbors(id)[1]].position.set(start.position); // right neighbor [1]
      point[neighbors(id)[0]].position.set(end.position); // left neighbor [0]
    }
  }
}
