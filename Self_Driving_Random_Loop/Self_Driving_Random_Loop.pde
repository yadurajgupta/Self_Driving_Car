//CAR VARIABLES
ArrayList<Car> cars=new ArrayList<Car>();              //LIST OF CARS
float VIS=100;                                         //VISION OF CAR HOW FAR CAN IT SEE
float carsize;                                         //SIZE OF CAR
float carang;                                          //SHAPE OF CAR
color carcol;                                          //COLOR OF CAR
color carcoldemo;                                      //COLOR OF CAR IN DEMO MODE
float speed=1;                                         //SPEED OF THE CAR
PVector start;                                         //STARTING POINT OF THE CARS
float angofvision=0.6*PI;                              //ANGEL OF VISION OF DRIVER


//NEURAL NETWORK VARIABLES
int inputs=5;                                          //INPUT TO THE NETWORK
int carnum=50;                                         //GENERATION SIZE

int[] networkSize={6, 6, 1};                           //NETWORK STRUCTURE

float forcemag=0.1;                                    //LIKE LEARNING CONSTANT
float mutation=0.01;                                   //NUMBER OF RANDOM CARS IN NEW GENERATION
float mutationStrength=0.1;
float mutationNew=0.3;
int step=1;                                            //TIME STEP IN SIMULATION
int LIFESPAN=70;                                      //AMOUNT OF TIME THE CAR CAN LIVE
boolean demo=false;                                    //ONLY SHOWING THE BEST CAR IN THE GENERATION
boolean showrays=false;                                //SHOW RAYS
boolean showCheckpoints=true;                          //SHOW CHECKPOINTS
boolean atleastonefinished=false;                      
int Generation=1;
int stepLowerLimit=1;
int stepUpperLimit=200;
//UP ARROW TO INCREASE SPEED
//DOWN ARROW TO DECREASE SPEED
//N TO CHANGE TRACK
//R RESET CARS
//F FAST FORWARD
//D DEMO MODE
//T TOGGLE RAYS
//S PROCEDD GENERATION

void setup()
{
  //size(800, 800);
  fullScreen();
  acc_radius=height*(0.7);
  strokeWeight(1);
  stroke(255);
  carsize=15;
  carang=PI/8;
  carcol=color(29, 255, 255, 150);
  carcoldemo=color(29, 255, 255);
  make_track();
  initcars();
}
void draw() {
  background(0);
  translate(width/2, height/2);
  end.checkpointshow(true);
  boolean nextgen=true;
  atleastonefinished=false;
  for (int i=0; i<step; i++)
  {
    for (Car c : cars)
    {
      c.update();
      if (c.collided==false && c.finished==false)
      {
        nextgen=false;
      }
      if (c.finished)
      {
        atleastonefinished=true;
      }
    }
  }
  if (!demo)
  {
    if (showrays)
    {
      for (Car c : cars)
      {
        c.showRays();
      }
    }
    for (Car c : cars)
    {
      c.show();
    }
  } else
  {
    int maxindex=-1;
    Car best=cars.get(0);
    for (Car c : cars)
    {
      if (!c.finished && !c.collided)
      {
        if (c.checkpointindex<=checkpoints.size())
        {
          if (c.checkpointindex>maxindex)
          {
            best=c;
            maxindex=c.checkpointindex;
          } else if (c.checkpointindex==maxindex)
          {
            if (c.checkpoint.per_dist(c.pos)<best.checkpoint.per_dist(best.pos))
            {
              best=c;
            }
          }
        }
      }
    }
    best.show();
    if (showrays)
      best.showRays();
    if (atleastonefinished)
    {
      nextGen();
      atleastonefinished=false;
    }
  }
  for (Boundary B : bounds)
  {
    B.show();
  }
  if (nextgen)
  {
    single_parent_next_generation();
    Generation++;
  }
  showStats();
}

void keyPressed()
{
  if (keyCode==UP)
  {
    step+=1;
  } else if (keyCode==DOWN)
  {
    step-=1;
  } else if (keyCode==LEFT)
  {
    step-=5;
  } else if (keyCode==RIGHT)
  {
    step+=5;
  } else if (key=='n' || key=='N')
  {
    make_track();
    resetcars();
  } else if (key=='r' || key=='R')
  {
    initcars();
  } else if (key=='f' || key=='F')
  {
    if (step!=stepUpperLimit)
      step=stepUpperLimit;
    else
      step=stepLowerLimit;
  } else if (key=='D' || key=='d')
  {
    demo=!(demo);
    if (demo)
    {
      showrays=true;
      step=stepLowerLimit;
      showCheckpoints=true;
    } else
    {
      showrays=false;
    }
  } else if (key=='t' || key=='T')
  {
    showrays=(!showrays);
  } else if (key=='s' || key=='S')
  {
    nextGen();
  } else if (key=='c' || key=='C')
  {
    showCheckpoints=!showCheckpoints;
  }
  constrainStep();
}
void resetcars()
{
  ArrayList<Car> next=new ArrayList<Car>();
  for (int i=0; i<cars.size(); i++)
  {
    Car c=new Car(start, mutation);
    c.net=cars.get(i).net.give_copy();
    next.add(c);
  }
  cars=next;
}
void nextGen()
{
  while (true)
  {
    boolean nextgen=true;
    for (Car c : cars)
    {
      c.update();
      if (c.collided==false && c.finished==false)
      {
        nextgen=false;
      }
    }
    if (nextgen)
    {
      break;
    }
  }
}
void initcars()
{
  Generation=1;
  cars.clear();
  for (int i=0; i<carnum; i++)
  {
    Car c=new Car(start, mutation);
    cars.add(c);
  }
}



void showStats()
{
  int stillalive=0;
  for (Car c : cars)
  {
    if (!c.finished && !c.collided)
      stillalive++;
  }
  pushMatrix();
  float textSize=20;
  textSize(textSize);
  fill(255);
  textAlign(LEFT, TOP);
  text("Generation "+Generation, -width/2, -height/2);
  String NetworkStructure="Network Structure "+inputs+"->";
  for (int i=0; i<networkSize.length; i++)
  {
    if (i!=networkSize.length-1)
      NetworkStructure+=networkSize[i]+"->";
    else
      NetworkStructure+=networkSize[i];
  }
  text(NetworkStructure, -width/2, -height/2+textSize);
  text("Speed " +step+"x", -width/2, -height/2+2*textSize);
  text("Inputs " +inputs, -width/2, -height/2+3*textSize);
  text("Still Alive "+stillalive+"/"+cars.size(), -width/2, -height/2+4*textSize);
  popMatrix();
}

void constrainStep()
{
  if (step>stepUpperLimit)
  {
    step=stepUpperLimit;
  }
  if (step<stepLowerLimit)
  {
    step=stepLowerLimit;
  }
}
