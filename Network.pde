class Network
{
  int []networksize;
  Layer[] layers;
  int inputs;
  int layersnum;
  float mutation_rate;
  Network(int[]networksize_, int inputs_, float mutation_rate_)
  {
    networksize=networksize_;
    inputs=inputs_;
    mutation_rate=mutation_rate_;
    layersnum=networksize.length;

    layers=new Layer[layersnum];
    layers[0]=new Layer(networksize[0], inputs, mutation_rate);
    for (int i=1; i<layersnum; i++)
    {
      layers[i]=new Layer(networksize[i], networksize[i-1], mutation_rate);
    }
  }
  float[] output(float[]input)
  {
    float[]tempinput=input;
    for (int i=0; i<layersnum; i++)
    {
      float[]tempoutput=layers[i].output(tempinput);
      tempinput=tempoutput;
    }
    return tempinput;
  }
  Network give_copy()
  {
    Network copynetwork=new  Network(networksize, inputs, mutation_rate);
    for (int i=0; i<layersnum; i++)
    {
      copynetwork.layers[i]=layers[i].give_copy();
    }
    return copynetwork;
  }
  Network Mate(Network parent1, Network parent2)
  {
    Network childnetwork=new  Network(networksize, inputs, mutation_rate);
    int seperation=floor(random(layersnum));
    for (int i=0; i<seperation; i++)
    {
      childnetwork.layers[i]=parent1.layers[i].give_copy();
    }
    for (int i=seperation; i<layersnum; i++)
    {
      childnetwork.layers[i]=parent2.layers[i].give_copy();
    }
    return childnetwork;
  }
  Network give_mutated()
  {
    Network mutated=this.give_copy();
    for (int i=0; i<layersnum; i++)
    {
      mutated.layers[i]=this.layers[i].give_mutated();
    }
    return mutated;
  }
}
