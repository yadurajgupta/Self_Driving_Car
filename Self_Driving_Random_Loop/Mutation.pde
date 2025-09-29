//SINGLE PARENT MUTATION
void single_parent_next_generation()
{
  float cumuscore[]=new float[NUM_BIRDS];
  int curr_score=0;
  int j=0;
  for (Bird b : BIRDS)
  {
      curr_score+=b.getScore();
      cumuscore[j++]=curr_score;
  }
  ArrayList<Bird> next=new ArrayList<>();
  for (int i=0; i<NUM_BIRDS; i++)
  {
    next.add(pickparent(cumuscore));
  }
  BIRDS=next;
}
Bird pickparent(float []cumuscore)
{
  float tot=cumuscore[NUM_BIRDS-1];
  float ran=random(tot);
  for (int i=0; i<NUM_BIRDS; i++)
  {
    if (ran<cumuscore[i])
    {
      Bird b=makeDefaultBird();
      b.net=BIRDS.get(i).net.give_mutated();
      return b;
    }
  } 
  return null;
}


////MATING PARENTS TOGETHER
//Car pickpairandmate(float[] cumuscore)
//{
//  Car parent1=pickparent(cumuscore);
//  Car parent2=pickparent(cumuscore);
//  while (parent2==parent1)
//  {
//    parent2=pickparent(cumuscore);
//  }
//  return mate(parent1, parent2);
//}
//Car mate(Car Parent1, Car Parent2)
//{
//  Car child=new Car(start, mutation);
//  child.net.Mate(Parent1.net, Parent2.net);
//  return child;
//}
//void Mate_next_generation()
//{
//  float cumuscore[]=new float[cars.size()];
//  int curr_score=0;
//  int j=0;
//  for (Car c : cars)
//  {
//    curr_score+=c.lifetime;
//    cumuscore[j++]=curr_score;
//  }
//  ArrayList<Car> next=new ArrayList<Car>();
//  for (int i=0; i<cars.size(); i++)
//  {
//    next.add(pickpairandmate(cumuscore));
//  }
//  cars=next;
//}
