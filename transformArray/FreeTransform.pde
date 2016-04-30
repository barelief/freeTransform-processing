/**
 *
 * FreeTransform class contains quad objects
 * distinguishes quads between selected and/or focused for interaction routines
 * saves/loads coordinates to/from external json file 
 * 
 * @author Bartosh Polonski
 * @version 0.3.0
 * @since 2016-04-30
 * 
 */

class FreeTransform
{
  ArrayList <Polygon> quads;
  int quadAmount;
  int selectedQuad;
  boolean helpMode = false; // 
  JSONArray coordinateValues;

  FreeTransform()
  {
    quadAmount = 7;
    quads = new ArrayList<Polygon>();
    loadValues(); // load cooradinates for all quads points from external JSON file
  }

  void draw()
  {
    update(); //
  }

  void update()
  {
    for (int i = 0; i < quadAmount; i++) 
    {
      Polygon quad = quads.get(i); //
      quad.draw(); //
    }
  }

  // return the currently mouse selected quad
  int selectedQuadId()
  {

    for (int i = 0; i < quadAmount; i++) 
    {
      Polygon quad = quads.get(i); //
      if (quad.dragLock) 
      {
        selectedQuad = quad.id;
        quad.isSelected = true; //
      } else quad.isSelected = false;
    }
    return selectedQuad;
  }

  // return the currently mouse focused quad
  int focusedQuadId()
  {

    for (int i = 0; i < quadAmount; i++) 
    {
      Polygon quad = quads.get(i); //
      if (quad.isFocused()) 
      {
        selectedQuad = quad.id;
      }
    }
    return selectedQuad;
  }

  // display useful help and debug info
  void showDebugInfo()
  {
    Polygon quad = quads.get(selectedQuadId()); //
    stroke(255);
    if (!helpMode)
      text("press H for help", 40, 40); 
    else 
    text("mode: "+quad.state+
      "\nMOUSESCROLL or +/- keyboard to zoom in/out\n"+
      "hold CTRL to free transform\n"+
      "hold SHIFT to scale proportionally transform\n"+
      "↑ ↓ ← → to update selected mode with keyboard\n"+
      "press H to hide this help info"+
      "\npress D for debug\n"+
      "press R to reset\n"+
      "frame rate: "+(int)frameRate
      , 40, 40);
  }

  // saves current points coordinates to disk
  void savePoints()
  {
    for (int i=0; i<quadAmount; i++)
    {
      JSONObject pointToSave = new JSONObject();

      pointToSave.setInt("id", i); // set the id of the quad
      Polygon quad = quads.get(i); // load particular quad

      for (int j=0; j<quad.amount; j++)
      {
        pointToSave.setInt("x"+j, (int)quad.point[j].position.x);
        pointToSave.setInt("y"+j, (int)quad.point[j].position.y);
      }
      coordinateValues.setJSONObject(i, pointToSave);
    }

    saveJSONArray(coordinateValues, "data/data.json");
    println("[notice ] Values saved to disk...");
  }

  void loadPoints()
  {
    for (int i=0; i<quadAmount; i++)
    {

      Polygon quad = quads.get(i); // load particular quad

      for (int j=0; j<quad.amount; j++)
      {
      }
    }

    println("---> Values loaded from disk...");
  }


  // load polygon points previously saved to disk
  void loadValues()
  {
    coordinateValues = new JSONArray();

    // try loading coordinates of polygon points from an external file
    try {
      coordinateValues = loadJSONArray("data.json");
    } 
    catch (Exception e) {
      e.printStackTrace();
      println("data file not found.. but dont worry, we'll create that later..");

      // if external file does not exist, make a default poin arrangement as in resetPosition();
      // resetPosition();
    };

    // assign loaded values to polygon variables
    setupValues(coordinateValues);
  }

  // remove selected quad
  void removeQuad(int quadId)
  {
  }

  // add new Quad to the array
  void addQuad()
  {
  }

  // reset all quads to their default positions
  void resetAllQuads()
  {
  }

  // reset quadId quad to its default position
  void resetQuad(int quadId)
  {
  }

  /*
  // reset the position of all points and position them around the screen center
   void resetPosition(int quadId)
   {
   println ("resetting position of quad no. "+quadId);
   Polygon quad = quads.get(i); // load particular quad
   // reset all points so they are drawn in the center with equal distance between each other
   for (int i=0; i<quad.amount; i++)
   {
   JSONObject pointsToSave = new JSONObject();
   int radius=width/4;
   float angle = map(i, 0, amount, PI, -PI); // position points evenly from -PI to +PI
   PVector shift = new PVector(sin(angle)*radius+width/2, cos(angle)*radius+height/2); //  on the circumference of a circle of "radius" in the center (w/2, h/2)
   point[i] = new Point(shift.x, shift.y, i, this);
   
   pointsToSave.setInt("x", (int)shift.x);
   pointsToSave.setInt("y", (int)shift.y);
   values.setJSONObject(i, pointsToSave);
   }
   selectedLine = -1;
   updateGlobalLines();
   }
   */

  // get loaded values from disk 
  // and assign them to the polygon class points
  void setupValues(JSONArray values)
  {
    println("--> setting up values..");
    // load points form external file

    for (int i = 0; i < values.size(); i++) 
    {
      quads.add(new Polygon(i)); // create new qud object, set its ID to i
      Polygon quad = quads.get(i); // load particular quad

      // i - quad id, j - no. of point of this quad
      for (int j=0; j<quad.amount; j++)
      {
        quad.point[j] = new Point (values.getJSONObject(i).getInt("x"+j), values.getJSONObject(i).getInt("y"+j), j, quad);
        // for example  "y0": 266, "x0": 422... etc.
      }
    }
  }
}