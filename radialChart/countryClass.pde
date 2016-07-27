// Don't know exactly what this does

public class countryClass implements Comparable{
  
  public int ID;
  public float X;
  public float Y;
  
  //Constructor
  countryClass(int id,  float x, float y){
    ID = id;
    X = x;
    Y = y;
  }
  
  public int compareTo(Object o){
    countryClass C2 = (countryClass)o;
    
    if(this.Y!=C2.Y)
    {
       if(this.Y < C2.Y){
         return -1;
       }else{
         return 1;
       }
    }else if(this.X!=C2.X){
      if(this.X<C2.X){
        return -1;
      }else{
        return 1;}
    }else {return 0;}
  
}
}