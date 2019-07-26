class Car
{
  PVector pos=new PVector();
  PVector vel=new PVector();
  PVector acc=new PVector();
  float carVision=VIS;
  Network net;
  boolean collided=false;
  boolean finished=false;
  float score=0;
  float mutation;
  Boundary checkpoint=checkpoints.get(0);
  int checkpointindex=0;
  int lifespan=LIFESPAN;
  int lifetime=0;
  ArrayList<Ray> rays=new ArrayList<Ray>();
  Car(PVector P, float mut)//START POS AND MUTATION RATE
  {
    mutation=mut;
    pos.set(P.x, P.y);
    vel.set(0, 0);
    acc.set(0, 0);
    net =new Network(networkSize, inputs, mutation);
    for (int i=0; i<inputs; i++)
    {
      float ang=map(i, 0, inputs-1, -PI/2, PI/2);
      rays.add(new Ray(pos, ang));
    }
  }
  void show()
  {
    //if (lifespan!=0)
    //{
      pushMatrix();
      translate(pos.x, pos.y);
      rotate(atan2(vel.y, vel.x));
      noStroke();
      fill(carcol);
      beginShape();
      vertex(0, 0);
      vertex(-carsize*cos(carang), carsize*sin(carang));
      vertex(-carsize*cos(carang), -carsize*sin(carang));
      endShape();
      popMatrix();
      if (!collided && !finished && checkpoint!=null)
      {
        //checkpoint.checkpointshow();
      }
    //}
  }
  void update()
  {
    if (!collided && !finished)
    {
      find_rays(bounds);
      vel.add(acc);
      pos.add(vel);
      acc.set(0, 0);
      if (checkpoint!=null)
      {
        if (checkpoint.per_dist(pos)<2)
        {
          if (checkpointindex<checkpoints.size())
          {
            checkpoint=checkpoints.get(checkpointindex++);
            lifespan=LIFESPAN;
          } else
          {
            checkpoint=null;
            finished=true;
            lifetime*=20;
          }
        }
      }
      lifespan--;
      lifetime++;
      if (lifespan==0)
      {
        collided=true;
      }
    }
  }
  void find_rays(ArrayList<Boundary> B)
  {
    float []inp=new float[rays.size()];
    int count=0;
    for (Ray r : rays)
    {
      r.dir.rotate(atan2(vel.y, vel.x));
      PVector end=r.give_Closest_intersection(B);
      r.dir.rotate(-atan2(vel.y, vel.x));
      if (end!=null)
      {
        float dist=end.dist(pos);
        if (dist<2)
        {
          collided=true;
        }
        float in=map(dist, 0, VIS/2.0, 1, 0);
        inp[count++]=in;
        //stroke(255);
        //strokeWeight(1);
        //line(pos.x, pos.y, end.x, end.y);
      } else
      {
        inp[count++]=0;
      }
    }
    float []output=net.output(inp);
    float ang=map(output[0], 0, 1, -PI, PI);
    ang+=atan2(vel.y, vel.x);
    PVector force=PVector.fromAngle(ang);
    force.setMag(speed);
    force.sub(vel);
    acc.set(force);
  }
}
