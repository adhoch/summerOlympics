class colorScale{
  //input variables
 float currentValue;

  //global variables
 float maxV=3000; //maximum participants for 2010
 float minV = 0;   //minimum participants for 2010
 //These values for dataset 1
/* float rhigh = 193;
 float ghigh = 237;
 float bhigh = 253; 
 float rlow = 27;
 float glow = 72;
 float blow = 127;*/
 //These values for dataset 2
 
 //return vector 
 PVector cScaled;

  
  
  colorScale(float value, float MAXV){

    currentValue=value;
   if (currentValue>3000){
     println("big");
     maxV=40000;
     minV=3000;
  float rlow = 0;
 float glow = 219;
 float blow = 222;
 float rhigh = 252;
 float ghigh = 0;
 float bhigh = 255; 
   float prop = (currentValue - minV)/(maxV - minV);
   float rval = rhigh - prop*(rhigh-rlow);
   float gval = ghigh - prop*(ghigh-glow);
   float bval = bhigh - prop*(bhigh-blow);
   cScaled = new PVector(rval, gval, bval);
 
 }
   else {
    float rhigh = 0;
 float ghigh = 219;
 float bhigh = 222;
 float rlow = 194;
 float glow = 21;
 float blow = 0;
   float prop = (currentValue - minV)/(maxV - minV);
   float rval = rhigh - prop*(rhigh-rlow);
   float gval = ghigh - prop*(ghigh-glow);
   float bval = bhigh - prop*(bhigh-blow);
   cScaled = new PVector(rval, gval, bval);
 
   }
  
   
   }
 
  
  public PVector getValue(){
    return(cScaled);
  }
}