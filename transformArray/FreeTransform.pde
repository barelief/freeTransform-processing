class FreeTransform
{
  ArrayList <Polygon> quads;
  int quadAmount;
  int selectedQuad;
  boolean helpMode = false; // 

  FreeTransform()
  {
    quadAmount = 7;
    quads = new ArrayList<Polygon>();

    for (int i = 0; i < quadAmount; i++) 
    {
      System.out.println("added ball: " + i);
      quads.add(new Polygon(i));
    }
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

  // 
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
    /*
    for (int i=0; i<quad.amount; i++)
    {
      JSONObject pointToSave = new JSONObject();
      pointToSave.setInt("x", (int)quad.point[i].position.x);
      pointToSave.setInt("y", (int)quad.point[i].position.y);
      quad.values.setJSONObject(i, pointToSave);
    }

    saveJSONArray(quad.values, "data/data.json");
    println("---> Values saved to disk...");
    */
  }  
}