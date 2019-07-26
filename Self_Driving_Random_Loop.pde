//CAR VARIABLES
ArrayList<Car> cars=new ArrayList<Car>();               //LIST OF CARS
float VIS=100;                                          //VISION OF CAR HOW FAR CAN IT SEE
float carsize;                                          //SIZE OF CAR
float carang;                                           //SHAPE OF CAR
color carcol;                                           //COLOR OF CAR
float speed=1;                                          //SPEED OF THE CAR
PVector start;                                          //STARTING POINT OF THE CARS
Boundary end;


//NEURAL NETWORK VARIABLES
int inputs=5;                                          //INPUT TO THE NETWORK
int carnum=100;                                        //GENERATION SIZE
int[] networkSize={10, 1};                             //NETWORK STRUCTURE
float forcemag=0.1;                                    //LIKE LEARNING CONSTANT
float mutation=0.01;                                   //NUMBER OF RANDOM CARS IN NEW GENERATION
int step=1;                                            //TIME STEP IN SIMULATION
int LIFESPAN=50;                                       //AMOUNT OF TIME THE CAR CAN LIVE



void setup()
{
  //size(800, 800);
  fullScreen();
  acc_radius=height*(0.7);
  strokeWeight(2);
  stroke(255);
  carsize=15;
  carang=PI/8;
  carcol=color(29, 255, 255, 150);
  make_track();
  initcars();
}
void draw() {
  background(0);
  translate(width/2, height/2);
  end.goalshow();

  boolean nextgen=true;
  for (int i=0; i<step; i++)
  {
    for (Car c : cars)
    {
      c.update();
      if (c.collided==false && c.finished==false)
      {
        nextgen=false;
      }
      //c.show();
    }
  }

  for (Car c : cars)
  {
    c.show();
  }

  for (Boundary B : bounds)
  {
    B.show();
  }
  if (nextgen)
  {
    single_parent_next_generation();
  }
}









void initcars()
{
  for (int i=0; i<carnum; i++)
  {
    Car c=new Car(start, mutation);
    cars.add(c);
  }
}


Car pickpairandmate(float[] cumuscore)
{
  float pick;
  int i, j;
  i=-1;
  while (i<0 || i>=cars.size())
  {
    pick=(random(cumuscore[cumuscore.length-1]));
    for (i=0; i<cumuscore.length; i++)
    {
      if (floor(pick)<floor(cumuscore[i]))
      {
        break;
      }
    }
  }
  j=-1;
  while ( j<0 || j>=cars.size())
  {
    pick=random(cumuscore[cars.size()-1]);
    for (j=0; j<cars.size(); j++)
    {
      if (floor(pick)<floor(cumuscore[j]))
      {
        break;
      }
    }
  }
  return mate(cars.get(i), cars.get(j));
}
Car mate(Car Parent1, Car Parent2)
{
  Car child=new Car(start, mutation);
  child.net.Mate(Parent1.net, Parent2.net);
  return child;
}
void Mate_next_generation()
{
  float cumuscore[]=new float[cars.size()];
  int curr_score=0;
  int j=0;
  for (Car c : cars)
  {
    curr_score+=c.lifetime;
    cumuscore[j++]=curr_score;
  }
  ArrayList<Car> next=new ArrayList<Car>();
  for (int i=0; i<cars.size(); i++)
  {
    next.add(pickpairandmate(cumuscore));
  }
  cars=next;
}
void single_parent_next_generation()
{
  float cumuscore[]=new float[cars.size()];
  int curr_score=0;
  int j=0;
  for (Car c : cars)
  {
    curr_score+=c.lifetime;
    cumuscore[j++]=curr_score;
  }
  ArrayList<Car> next=new ArrayList<Car>();
  for (int i=0; i<cars.size(); i++)
  {
    next.add(pickparent(cumuscore));
  }
  cars=next;
}
Car pickparent(float []cumuscore)
{
  float tot=cumuscore[cars.size()-1];
  float ran=random(tot);
  for (int i=0; i<cars.size(); i++)
  {
    if (ran<cumuscore[i])
    {
      //println(i);
      Car c=new Car(start, mutation);
      c.net=cars.get(i).net.give_mutated();
      return c;
    }
  } 
  return cars.get(cars.size()-1);
}
void keyPressed()
{
  if (keyCode==UP)
  {
    if (step<100)
    {
      step+=1;
    }
  } else if (keyCode==DOWN)
  {
    if (step>1)
    {
      step-=1;
    }
  } else if (key=='n' || key=='N')
  {
    make_track();
    resetcars();
  }
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
