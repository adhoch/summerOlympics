public class country    
  {
     String countryName, countryIso3="", incomeLevel,continent;
     float latitude, longitude, population, gdp_, land_area, co2_;     
     //HashMap olympics;
     HashMap<String, olympics> olympics;     
     String countryAbbre="";
     createCountry COUNTRYSHAPE; 
     PShape shapeCombo;
     
     
     public void setIso2(String iso2){
     this.countryAbbre=iso2;
     }
     public void setConName(String name){
     this.countryName=name;
     }
     public void setIncome(String income){
     this.incomeLevel=income;
     }
     public void setIso3(String iso3){
     this.countryIso3=iso3;
     }
     
     public void setContinent(String cont){
     this.continent=cont;
     }
     
     public void setLat(float lat){
     this.latitude=lat;
     }
     public void setGdp(float gdp){
     this.gdp_=gdp;
     }
     public void setPop(float pop){
     this.population=pop;
     }
     public void setLon(float lon){
     this.longitude=lon;
     }
     public void setCo2(float co2){
     this.longitude=co2;
     }public void setLandA(float land){
     this.land_area=land;
     }
     public void setOly(HashMap<String, olympics> oly){
     this.olympics=oly;
     }    
     
     public void setShape(createCountry COUNTRYSHAPE){
       this.COUNTRYSHAPE=COUNTRYSHAPE;
     }
     
     public void setShapeCombo(PShape shapeCombo){
     this.shapeCombo=shapeCombo;
     }
     
  }
  
  
public class olympics {
    int year=0,athletes=0,men=0,women=0,bronze=0,silver=0,gold=0,totMed=0;
    float pop,gdp,co2, gdpRat=0;
    String yTest, countryName;
    
    public int checkString(String string){
      
       try
    {
        Integer.parseInt(string);
        return Integer.valueOf(string);
    } catch (NumberFormatException ex)
    {
        return 0;
    }
      
    }
       
  public void setPop(float pop){
     this.pop=pop;
     }
 public void setGdp(float gdp){
     this.gdp=gdp;
     }
 public void setCo2(float co2){
     this.co2=co2;
     }
   public void setYear(String year){
     this.year=checkString(year);
   }
   public void setAth(String athletes){
     this.athletes=checkString(athletes);
   }
    public void setMen(String men){
     this.men=checkString(men);
   }
   public void setWomen(String women){
     this.women=checkString(women);
   }
   public void setBronze(String bronze){
     this.bronze=checkString(bronze);
   }
   public void setSilver(String silver){
     this.silver=checkString(silver);
   }
   public void setGold(String gold){
     this.gold=checkString(gold);
   }
   public void setTot(String tot){
     this.totMed=checkString(tot);
   }
   public void setYeart(String ytest){
     this.yTest=ytest;
   }
   public void setConName(String name){
     this.countryName=name;
     }     
     
   public int getTot(){
   return totMed;
   }
     
}