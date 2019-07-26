//RAY TRACING 
class Ray
{
  PVector start;
  PVector dir;
  float ans=0;
  Ray(PVector P, float ang_)
  {
    start=P;
    dir=PVector.fromAngle(ang_);
  }
  void rotate(float ang)
  {
    dir.rotate(ang);
  }
  PVector give_intersection(Boundary B)
  {
    float x1=B.A.x;
    float y1=B.A.y;
    float x2=B.B.x;
    float y2=B.B.y;

    float x3=start.x;
    float y3=start.y;
    float x4=start.x+dir.x;
    float y4=start.y+dir.y;

    float den=(x1-x2)*(y3-y4)-(y1-y2)*(x3-x4);
    if (den==0)
    {
      return null;
    } else 
    {
      float t=((x1-x3)*(y3-y4)-(y1-y3)*(x3-x4))/den;
      float u=-((x1-x2)*(y1-y3)-(y1-y2)*(x1-x3))/den;
      if (t>0 && t<1 && u>0)
      {
        return new PVector(x1+t*(x2-x1), y1+t*(y2-y1));
      } else
      {
        return null;
      }
    }
  }
  PVector give_Closest_intersection(ArrayList<Boundary> arr)
  {
    float Record=width*2;
    PVector closest=null;
    for (Boundary B : arr)
    {
      PVector intr=give_intersection(B);
      if (intr !=null)
      {
        float dist=intr.dist(start);
        if (dist<Record && closest==null)
        {
          closest=new PVector();
          closest.set(intr);
          Record=dist;
        } else if (dist<Record && closest!=null)
        {
          closest.set(intr);
          Record=dist;
        }
      }
    }
    if (closest!=null)
    {
      if (closest.dist(start)>VIS/2.0)
      {
        closest.x=start.x+(VIS/2.0)*dir.x;
        closest.y=start.y+(VIS/2.0)*dir.y;
      }
    }
    return closest;
  }
  void update(PVector p)
  {
    start.set(p);
  }
}
