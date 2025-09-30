class Bird
{
  PVector pos,vel, acc;
  int size = 75;
  Integer maxVelocity = 20;
  PVector jumpAcc = new PVector(0,-maxVelocity);  
  boolean alive;
  int birthFrameCount;
  int deathFrameCount = -1;
  Network net;
  Bird(PVector pos_,PVector vel_,PVector acc_)
  {
    pos = pos_;
    vel = vel_;
    acc = acc_;
    alive = true;
    birthFrameCount = frameCount;
    net = new Network(networkSize, inputs, mutation);
  }
  void show()
  {
    stroke(0);
    if(!alive)
      fill(255, 0, 0);
    else
      fill(0, 255, 255,125);
    circle(pos.x,pos.y,size);
    //PVector heading = new PVector(vel.x,vel.y);
    //heading.setMag(size);
    strokeWeight(0);
    //line(pos.x,pos.y,pos.x+heading.x,pos.y+heading.y);
  }
  boolean shouldJump()
  {
    float[] inputsArr = new float[inputs];
    for(int i=0;i<inputs;i++)
    {
      inputsArr[i] = 0;
    }
    int closest = getClosestPillar(PILARS);
    int idx = 0;
    inputsArr[idx++] = map(pos.y, 0 , height , 0 ,1);
    inputsArr[idx++] = map(vel.x, -maxVelocity , +maxVelocity , 0 ,1);
    inputsArr[idx++] = map(vel.y, -maxVelocity , +maxVelocity , 0 ,1);
    
    {
      Pillar p = PILARS.get(closest);
      inputsArr[idx++] = map(p.x + p.pillarWidth - pos.x , 0 , width , 0 ,1);
      inputsArr[idx++] = map(p.x - pos.x , - p.pillarWidth , width , 0 ,1);
      inputsArr[idx++] = map(p.topHeight - pos.y, -height , height , 0 ,1);
      inputsArr[idx++] = map(p.bottomHeight - pos.y , -height , height , 0 ,1);
    }
    //if(closest + 1 < PILARS.size())
    //{
    //  Pillar p = PILARS.get(closest +1);
    //  inputsArr[idx++] = map(p.x + p.pillarWidth - pos.x , 0 , width , 0 ,1);
    //  inputsArr[idx++] = map(p.x - pos.x , - p.pillarWidth , width , 0 ,1);
    //  inputsArr[idx++] = map(p.topHeight - pos.y, -height , height , 0 ,1);
    //  inputsArr[idx++] = map(p.bottomHeight - pos.y , -height , height , 0 ,1);
    //}
    float[] outputs=net.output(inputsArr);
    return outputs[0] > 0.5;
  }
  
  float getScore() {
     return deathFrameCount - birthFrameCount;
  }
  void update()
  {
    
    if(!alive)
      return;
    if(shouldJump())
      jump();
    //if(vel.mag() > maxVelocity)
    //{
    //  vel.setMag(maxVelocity);
    //}
    pos.add(vel);
    vel.add(acc);
    
    if(!isOnScreen(new PVector(pos.x + size,pos.y)) &&
     !isOnScreen(new PVector(pos.x - size,pos.y)) &&
     !isOnScreen(new PVector(pos.x ,pos.y+ size)) &&
     !isOnScreen(new PVector(pos.x ,pos.y- size)) 
    )
    {
      setDead();
    }
    
    if(isHittingPillar()) 
    {
      setDead();
    }
  }
  
  boolean isHittingPillar()
  {
      for(Pillar p:PILARS)
      {
        if(p.hits(pos,size/2))
          return true;
      }
      return false;
  }
  
  void setDead()
  {
    alive = false;
    deathFrameCount = frameCount;
  }
  
  void jump()
  {
    vel.add(jumpAcc);
  }
  
  int getClosestPillar(ArrayList<Pillar> pillars)
  {
    float minD = width * 1000;
    int closestPillar = 0;
    int idx = -1;
    for(Pillar p:pillars)
    {
      idx++;
      float d = p.x + p.pillarWidth - pos.x;
      if(d>0 && minD > d)
      {
        minD = d;
        closestPillar = idx;
      }
    }
    return closestPillar;
  }

}
