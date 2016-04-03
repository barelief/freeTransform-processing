class Line {
  // http://www.openprocessing.org/sketch/135314
  PVector start, end;

  Line(PVector _start, PVector _end) {
    start = _start;
    end   = _end;
  }

  void set(PVector _start, PVector _end)
  {
    start = _start;
    end   = _end;
  }

  void set_start(PVector _start) {
    start = _start;
  }

  void set_end(PVector _end) {
    end = _end;
  }

  PVector get_start() {
    return start;
  }

  PVector get_end() {
    return end;
  }

  void draw() {
    line(start.x, start.y, end.x, end.y);
  }

  PVector line_itersection(Line one, Line two)
  {
    float x1 = one.get_start().x;
    float y1 = one.get_start().y;
    float x2 = one.get_end().x;
    float y2 = one.get_end().y;

    float x3 = two.get_start().x;
    float y3 = two.get_start().y;
    float x4 = two.get_end().x;
    float y4 = two.get_end().y;

    float bx = x2 - x1;
    float by = y2 - y1;
    float dx = x4 - x3;
    float dy = y4 - y3;

    float b_dot_d_perp = bx * dy - by * dx;

    if (b_dot_d_perp == 0) return null;

    float cx = x3 - x1;
    float cy = y3 - y1;

    float t = (cx * dy - cy * dx) / b_dot_d_perp;
    if (t < 0 || t > 1) return null;

    float u = (cx * by - cy * bx) / b_dot_d_perp;
    if (u < 0 || u > 1) return null;

    return new PVector(x1+t*bx, y1+t*by);
  }

  PVector intersects_at(Line other)
  {
    return line_itersection(this, other);
  }
}

