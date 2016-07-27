class colorScaleE{
  //input variables
 float currentValue;

  //global variables
 float maxV; //maximum participants for 2010
 float minV = 0;   //minimum participants for 2010
 //These values for dataset 1
/* float rhigh = 193;
 float ghigh = 237;
 float bhigh = 253; 
 float rlow = 27;
 float glow = 72;
 float blow = 127;*/
 //These values for dataset 2
  float rhigh = 204;
 float ghigh = 17;
 float bhigh = 104;
 float rlow = 255;
 float glow = 212;
 float blow = 255;
 
 //return vector 
 PVector cScaled;
  
  colorScaleE(float value, float MAXV){
   currentValue = value; 
   maxV = MAXV;
   float prop = (currentValue - minV)/(maxV - minV);
   float rval = rlow + prop*(rhigh-rlow);
   float gval = glow + prop*(ghigh-glow);
   float bval = blow + prop*(bhigh-blow);
   cScaled = new PVector(rval, gval, bval);
   }
  
  public PVector getValue(){
    return(cScaled);
  }
}
