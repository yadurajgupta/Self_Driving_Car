class Boundary
{
  PVector A, B;
  Boundary(PVector A_, PVector B_)
  {
    A=A_;
    B=B_;
  }
  float per_dist(PVector point)
  {
    float x1=A.x;
    float x2=B.x;
    float x0=point.x;
    float y1=A.y;
    float y2=B.y;
    float y0=point.y;
    float dist=(y2-y1)*x0-(x2-x1)*y0+x2*y1-y2*x1;
    dist/=(sqrt(pow(y1-y2, 2)+pow(x1-x2, 2)));
    return dist;
  }
  void show()
  {
    stroke(255);
    strokeWeight(2);
    line(A.x, A.y, B.x, B.y);
  }
  void checkpointshow()
  {
    colorMode(HSB);
    stroke(70, 255, 255);
    strokeWeight(2);
    line(A.x, A.y, B.x, B.y);
  }
  void goalshow()
  {
    colorMode(HSB);
    stroke(70, 255, 255);
    strokeWeight(4);
    line(A.x, A.y, B.x, B.y);
  }
}
