import java.awt.event.*;

void setupMouseWheel() {
  addMouseWheelListener(new MouseWheelListener() { 
    public void mouseWheelMoved(MouseWheelEvent mwe) { 
      mouseWheel(mwe.getWheelRotation());
    }
  }
  );
}

void mouseWheel(int delta) {
  println("mouse has moved by " + delta + " units."); 

  for (int i = transform.balls.size()-1; i >= 0; i--) { 
    Ball ball = (Ball) transform.balls.get(i);
    if (ball.isOver) 
    {
       println(delta);
      ball.size=constrain(ball.size+delta*10, 50, 300);
    }
  }
}

void mousePressed()
{
  boolean ballDetected=false;
  for (int i = transform.balls.size()-1; i >= 0; i--) { 
    Ball ball = (Ball) transform.balls.get(i);
    if (ball.isOver) 
    {
      ballDetected=true;
      ball.isLockedToMouse=true;
      break; // this isvengia selecting two overlapping
    }
  }
  if (!ballDetected)
    transform.balls.add(new Ball(60, mouse));
}

void mouseDragged()
{  
  for (int i = transform.balls.size()-1; i >= 0; i--) { 
    Ball ball = (Ball) transform.balls.get(i);
    if (ball.isLockedToMouse) ball.position.set(mouse); 
    else ball.isLockedToMouse=false;
  }
}

void mouseReleased()
{
  for (int i = transform.balls.size()-1; i >= 0; i--) 
  { 
    Ball ball = (Ball) transform.balls.get(i);
    ball.isLockedToMouse=false;
  }
}
