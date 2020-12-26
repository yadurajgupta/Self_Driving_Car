float min=0;
float max=1;
class Node
{
  float[] weights;
  int inputnum;
  float mutation_rate;

  Node(int inputnum_, float mutation_rate_)
  {
    inputnum=inputnum_;
    mutation_rate=mutation_rate_;


    weights=new float[inputnum+1];
    for (int i=0; i<inputnum+1; i++)
    {
      weights[i]=random(-1, 1);
    }
  }
  float output(float[]inputs)
  {
    float out=0;
    for (int i=0; i<inputnum; i++)
    {
      out+=weights[i]*inputs[i];
    }
    out+=weights[inputnum];
    return activation(out);
  }
  float activation(float in)
  {
    //SIGMOID
    return 1.0/(1+exp(-in));


    //SIGNUM
    //if (in>0)
    //  return 1;
    //else
    //  return -1;



    //TANH
    //return (exp(2*in)-1.0)/(exp(2*in)+1);
  }

  Node give_copy()
  {
    Node copynode=new Node(inputnum, mutation_rate);
    for (int i=0; i<inputnum+1; i++)
    {
      copynode.weights[i]=weights[i];
    }
    return copynode;
  }
  Node give_mutated()
  {
    Node mutated=new Node(inputnum, mutation_rate);
    for (int i=0; i<inputnum+1; i++)
    {
      float ran=random(1);
      if (ran<mutation_rate)
      {
        mutated.weights[i]=weights[i]*(1+random(-mutationStrength,mutationStrength));
        constrain(mutated.weights[i],-1,1);
        float r=random(1);
        if(r<mutationNew)
        mutated.weights[i]=random(-1,1);
      } else
      {
        mutated.weights[i]=weights[i];
      }
    }
    return mutated;
  }
};
