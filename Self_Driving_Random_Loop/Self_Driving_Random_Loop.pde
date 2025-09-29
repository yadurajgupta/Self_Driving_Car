////CAR VARIABLES
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
int inputs=7;                                          //INPUT TO THE NETWORK
int carnum=50;                                         //GENERATION SIZE

int[] networkSize={inputs + 1, inputs + 1, 1};                           //NETWORK STRUCTURE

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

int OFFSET_WIDTH = 0;
int OFFSET_HEIGHT = 0;

PVector birdStart;
PVector birdVel;
PVector GRAVITY = new PVector(0,1);
//Bird bird;
ArrayList<Bird> BIRDS = new ArrayList<>();
int NUM_BIRDS = 1000;
int NUM_BIRDS_DEMO = 10;

int jumpFrameLast;

float currentFPS = 10000;
int BIRD_ALIVE_COUNT = NUM_BIRDS;
int GENERATION_COUNT = 0;

boolean crunchMode = false;

int PILLAR_COUNT = 0;


float baseFrame = 0;
ArrayList<Pillar> PILARS = new ArrayList<>();

boolean isOnScreen(PVector pos)
{
  if(pos.x + OFFSET_WIDTH >= 0 && pos.x + OFFSET_WIDTH <= width && pos.y + OFFSET_HEIGHT >= 0 && pos.y + OFFSET_HEIGHT <= height)
  {
    return true;
  }
  return false;
}
void generateBirds()
{
  BIRDS = new ArrayList<>();
  for(int i=0;i<NUM_BIRDS;i++)
  {
    BIRDS.add(makeDefaultBird());
  }
}
Bird makeDefaultBird()
{
  Pillar p = PILARS.get(0);
  Bird b = new Bird(new PVector(width/4,random(p.topHeight,p.bottomHeight)),new PVector(0,0),GRAVITY);
  while(true)
  {
    b = new Bird(new PVector(width/4,random(0,height)),new PVector(0,0),GRAVITY);
    b.update();
    if(b.alive)
      return b;
  }
}

void generatePillars()
{
  
  PILARS = new ArrayList<>();
  PILARS.add(new Pillar(width/4));
  PILARS.add(new Pillar(width/2));
  PILARS.add(new Pillar(3*width/4));
  PILLAR_COUNT = 3;
  baseFrame = frameCount;
}
void setup()
{
  //size(800, 800);
  fullScreen();
  strokeWeight(1);
  stroke(255);
  generatePillars();
  generateBirds();
  frameRate(currentFPS); 
}


void draw() {
  for(Bird bird:BIRDS)
  {
    if(!bird.alive) continue;
    bird.update();
  }
  if ((baseFrame + frameCount) % 120 == 0) {
    PILARS.add(new Pillar());
    PILLAR_COUNT++;
  }
  ArrayList<Pillar> toRemove = new ArrayList<>();
  for(Pillar p : PILARS)
  {
    if (p.isOffscreen()) {
      toRemove.add(p);
      continue;
    }
    p.update();
  }
  

  BIRD_ALIVE_COUNT = getBirdAliveCount();
  
    if(!crunchMode){
    background(0);
    for(Bird bird:BIRDS)
    {
      if(!bird.alive)
        continue;
      bird.show();
    }
    for(Pillar p : PILARS)
    {
      p.show();
    }
  }
  //BIRDS.removeAll(toRemoveBirds);
  PILARS.removeAll(toRemove);
  if(BIRD_ALIVE_COUNT ==0)
  {
    generatePillars();
    single_parent_next_generation();
    GENERATION_COUNT++;
  }
  println("FaremRate " + new Float(frameRate).toString() + " Generation Count " + new Float(GENERATION_COUNT).toString() + " Birds Alive " + new Float(BIRD_ALIVE_COUNT).toString());
}

int getBirdAliveCount()
{
  int cnt = 0;
  for(Bird b:BIRDS)
  {
    if(b.alive)
    cnt++;
    
  }
  return cnt;
} 
void keyPressed()
{
  if(key=='r')
  {
    generateBirds();
  }
  
  if(key == 'C')
  {
    crunchMode = !crunchMode;
  }
  
}


void showStats()
{
  int stillalive=0;
  for (Bird b : BIRDS)
  {
    if(b.alive)
      stillalive++;
  }
  pushMatrix();
  float textSize=20;
  textSize(textSize);
  fill(255);
  textAlign(LEFT, TOP);
  text("Generation "+GENERATION_COUNT, -width/2, -height/2);
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
} //<>//
