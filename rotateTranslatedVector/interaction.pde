
void mousePressed()
{
  //  drag
  if (anchor.dist(P) < radius/2)
  {
    offsetStart.set(mouseX, mouseY);
    startAnchor.set(anchor);
    startA.set(A);
    lockdrag = true;
  } else {
    // rotate
    lockedA.set(A); // uzlockink A pozicija ir uzseivinka ja i lockedA vektoriu
    startOffsetAngle = diff.heading(); // OK
    tmpA = PVector.sub(lockedA, anchor);
    startAngle  = tmpA.heading();
  }
}

void mouseReleased()
{
  // A.set(diff);
  // diff.rotate(0);
  // angle=0;
  // diff.set(A);
  lockdrag = false;
}

void keyPressed()
{
  if (key == 'm')
    A.set(mouseX, mouseY);

  if (key == 'a')
    anchor.set(mouseX, mouseY);
}


void mouseDragged()
{
  if (lockdrag)
  {
    // drag
    offset = PVector.sub(P, offsetStart);
    anchor = PVector.add (startAnchor, offset);
    A = PVector.add(startA, offset);
  } else {
    //rotate
    offsetAngle = diff.heading() - startOffsetAngle; // OK kiek isviso rotate offsetas buvo atliktas pradedant nuo 0 (mousePressed) baigiant iki paskutinio moueDragged
    angle = startAngle + offsetAngle; // final rotation amount

    tmpA = PVector.sub(lockedA, anchor); // sukurk laikina (absolute position) vektoriu nuo anchoro iki A tashko 


    tmpA.rotate(- tmpA.heading()); // grazink i nuline pozicija
    tmpA.rotate(angle); // ir dadek savo norima rorate amount

    stroke(0);
    rect(tmpA.x, tmpA.y, 5, 5);
    text("tmpA", tmpA.x+10, tmpA.y+10); // debug

    tmpA.add(anchor); // padek vektoriu atgal i vieta ekrane

    A.set(tmpA); // updeiting originalu vektoriu pagal transformuota laikina
  }
}

