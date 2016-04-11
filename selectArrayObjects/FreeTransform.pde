class FreeTransform
{
  ArrayList <Ball> balls;
  int amount;
  
  FreeTransform(int amount_)
  {
    amount = amount_;
    balls = new ArrayList<Ball>();

    for (int i=0; i<amount; i++)
    {
      balls.add(new Ball( random(50, 100), new PVector (random(width), random(height))));
    }
  }

  void draw()
  {
    for (int i=0; i<amount; i++)
    {
      Ball ball = balls.get(i);
      ball.draw();
    }
  }
  

}

