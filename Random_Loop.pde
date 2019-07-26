
//PERFECT RANDOM LOOP FORMATIONUSING PERLIN NOISE //////(ONPEN SIMPLEX)(SINPLEX)
//going aroung a circle in the noise function
int resolution=100;
float noise_radius=0.5;  //JAGEDNESS OF THE LOOP
float x_offset=10;
float y_offset=10;
float acc_radius;    //SIZE OF THE LOOP
float track_thickness=50;
//7 times the Width


ArrayList<PVector> outer=new ArrayList<PVector>();
ArrayList<PVector> center=new ArrayList<PVector>();
ArrayList<PVector> inner=new ArrayList<PVector>();
ArrayList<Boundary> innerbounds=new ArrayList<Boundary>();
ArrayList<Boundary> outerbounds=new ArrayList<Boundary>();
ArrayList<Boundary> checkpoints=new ArrayList<Boundary>();
ArrayList<Boundary> bounds=new ArrayList<Boundary>();
void make_track()
{
  outer.clear();
  center.clear();
  inner.clear();
  innerbounds.clear();
  outerbounds.clear();
  checkpoints.clear();
  bounds.clear();
  x_offset+=random(1);
  y_offset+=random(1);
  for (int i=0; i<resolution; i++)
  {
    float ang=map(i, 0, resolution, 0, 2*PI);
    float x=x_offset+noise_radius*(1+sin(ang));
    float y=y_offset+noise_radius*(1+cos(ang));
    center.add(new PVector(acc_radius*noise(x, y)*cos(ang), acc_radius*noise(x, y)*sin(ang)));
    outer.add(new PVector((acc_radius+track_thickness)*noise(x, y)*cos(ang), (acc_radius+track_thickness)*noise(x, y)*sin(ang)));
    inner.add(new PVector((acc_radius-track_thickness)*noise(x, y)*cos(ang), (acc_radius-track_thickness)*noise(x, y)*sin(ang)));
  }
  outerbounds.add(new Boundary(outer.get(outer.size()-1), outer.get(0)));
  bounds.add(new Boundary(outer.get(outer.size()-1), outer.get(0)));
  innerbounds.add(new Boundary(inner.get(outer.size()-1), inner.get(0)));
  bounds.add(new Boundary(inner.get(outer.size()-1), inner.get(0)));

  for (int i=1; i<outer.size(); i++)
  {
    outerbounds.add(new Boundary(outer.get(i-1), outer.get(i)));
    innerbounds.add(new Boundary(inner.get(i-1), inner.get(i)));
    bounds.add(new Boundary(outer.get(i-1), outer.get(i)));
    bounds.add(new Boundary(inner.get(i-1), inner.get(i)));
    if (i!=outer.size()-1)
    {
      checkpoints.add(new Boundary(inner.get(i), outer.get(i)));
    } else
    {
      bounds.add(new Boundary(inner.get(i), outer.get(i)));
    }
  }
  start=center.get(0);
  end=checkpoints.get(checkpoints.size()-1);
}
