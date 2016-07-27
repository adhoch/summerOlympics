class colorScaleCountry{
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

  
  
  colorScaleCountry(float value, float MAXV){
currentValue=value;
if (currentValue<1){
float rval=0;
float gval=0;
float bval=0;
println(value);
cScaled = new PVector(rval, gval, bval);
  

}
else if (currentValue<10)
{
  cScaled = new PVector(8,29,88);


}
else if(currentValue<20){
cScaled = new PVector(239,248,181);
}

else if (currentValue<40){

cScaled = new PVector(207,236,179);

}
else if (currentValue<80){
cScaled = new PVector(151,214,184);

}
else if (currentValue<160){
cScaled = new PVector(92,192,192);

}
else if (currentValue<320){
  cScaled = new PVector(48,165,194);

}
else if (currentValue<640){
cScaled = new PVector(30,128,184);


}
else if (currentValue<1280){

cScaled = new PVector(34,84,163);
}
else if (currentValue<2560){

cScaled = new PVector(33,49,141);}
else if (currentValue<5120){

  cScaled = new PVector(8,29,88);
}



//else if (currentValue <25000){
//  cScaled = new PVector(0,128,0);
//}

else if (currentValue<10000){
  cScaled = new PVector(255,0,255);
}


//else if (currentValue<50000){
//  cScaled = new PVector(255,0,0);
//}


else if (currentValue<100000){
  cScaled = new PVector(255,0,0);
}    
    
    
else {
cScaled= new PVector(0,0,0);
}
  /*  currentValue=value;
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
  */
   
   }
 
  
  public PVector getValue(){
    return(cScaled);
  }
}