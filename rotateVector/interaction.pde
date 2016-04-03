
void mousePressed()
{
  // rotate
  startOffsetAngle = anchorLine.heading(); // OK

  beginPosition.set(position); // uzlockink A pozicija ir uzseivinka ja i beginPosition vektoriu
  tmp = PVector.sub(beginPosition, anchor);
  startAngle  = tmp.heading();
}

void mouseDragged()
{

  offsetAngle = anchorLine.heading() - startOffsetAngle; // OK kiek isviso rotate offsetas buvo atliktas pradedant nuo 0 (mousePressed) baigiant iki paskutinio moueDragged
  angle = startAngle + offsetAngle; // final rotation amount

  tmp = PVector.sub(beginPosition, anchor); // sukurk laikina (absolute position) vektoriu nuo anchoro iki A tashko 
  tmp.rotate(-tmp.heading()); // grazink i nuline pozicija
  tmp.rotate(angle); // ir dadek savo norima rorate amount
  tmp.add(anchor); // padek vektoriu atgal i vieta ekrane
  position.set(tmp); // updeiting originalu vektoriu pagal transformuota laikin
}

