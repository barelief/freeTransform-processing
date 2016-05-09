ArrayList values;

void setup()
{
  size(200, 200);
  values = new ArrayList();
  restart();
}

void draw()
{
  background(0);
  text("size: "+values.size(), 20, 20);
  for ( int i=0; i<values.size(); i++)
  {
    text((int)values.get(i), 20, 40+20*i);
  }
}

void restart()
{
  values.add(0);
  values.add(1);
  values.add(2);
  values.add(3);
  values.add(4);
}

void keyPressed()
{
  if (values.size() > 0)
    values.remove(values.size()-1);
  else restart();
}