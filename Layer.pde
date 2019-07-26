class Layer
{
  int size;
  int inputs;
  float mutation_rate;

  Node[] nodes;
  Layer(int size_, int inputs_, float mutation_rate_)
  {
    size=size_;
    inputs=inputs_;
    mutation_rate=mutation_rate_;

    nodes=new Node[size];
    for (int i=0; i<size; i++)
    {
      nodes[i]=new Node(inputs, mutation_rate);
    }
  }
  float[] output(float []inputs)
  {
    float[]outputs=new float[size];
    for (int i=0; i<size; i++)
    {
      outputs[i]=nodes[i].output(inputs);
    }
    return outputs;
  }
  Layer give_copy()
  {
    Layer copylayer=new Layer(size, inputs, mutation_rate);
    for (int i=0; i<size; i++)
    {
      copylayer.nodes[i]=nodes[i].give_copy();
    }
    return copylayer;
  }
  Layer give_mutated()
  {
    Layer mutated=new Layer(size, inputs, mutation_rate);
    for (int i=0; i<size; i++)
    {
      mutated.nodes[i]=nodes[i].give_mutated();
    }
    return mutated;
  }
}
