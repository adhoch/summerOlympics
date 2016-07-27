class createCountry {
 //This class will open a GEOJSON file and will create a shape for the "countryname" requested
 //Class variables here
 //Variables passed to class here
 String SELECTNAME;
 String ID="";
PVector colorShapeBy, colorStrokeBy;
int strokeW;

 float shrink = 1;
 //Variables used globably in the class here
 //initialize JSON array
 JSONArray countryJSON;
 //Variables for shapes
 ArrayList < PVector > coordsSHAPE;
 FloatList xborders;
 FloatList yborders;
 FloatList xborders2;
 FloatList yborders2;
 //Write output
 PrintWriter output;
 //The shape here
 PShape countrySHAPE;
 boolean typeGeom = false;
 boolean typeGeom2 = true;
createCountry(String name, String id, int ath) {
    SELECTNAME = name;
    ID=id;
    boolean found=false;
    //Reference files for geometry of each country 
    //countryJSON = loadJSONArray("countriesT.geo.json");
    countryJSON = loadJSONArray("countries.geo2.json");
    //Temporary file created to store the shape for the country requested
    output = createWriter("JSONTEST.txt");

    for (int i = 0; i <countryJSON.size(); i++)
    {
      JSONObject countryShape = countryJSON.getJSONObject(i);    
      JSONObject countryNAMES = countryShape.getJSONObject("properties");
      
      String cnames = countryNAMES.getString("name");
         if(SELECTNAME.equals("Malaya")){
         SELECTNAME="Malaysia";
         }     
         else if (SELECTNAME.equals("Rhodesia")){
         SELECTNAME="Zimbabwe";
         
         }
         
         else if (SELECTNAME.equals("Australasia")){
         SELECTNAME="Australia";
         
         }
         
         else if(SELECTNAME.equals("Bohemia")){
         SELECTNAME="Czech Republic";
         }
 
        if (cnames.equals(SELECTNAME)==true)
        {
          
          found=true;
          JSONObject countryCoordShape = countryShape.getJSONObject("geometry");
        //  println(SELECTNAME);
          String geometry = countryCoordShape.getString("type");
          if (geometry.equals("MultiPolygon"))
          {
            typeGeom = true;
            typeGeom2 = false;
          }
          JSONArray jsonArr = countryCoordShape.getJSONArray("coordinates");
          output.println(jsonArr);
          break;
        }
        
        if(found!=true & !countryShape.isNull("id")){
          String countryID = countryShape.getString("id");          
          if(ID.equals(countryID)){
           
          found=true;
          JSONObject countryCoordShape = countryShape.getJSONObject("geometry");
          String geometry = countryCoordShape.getString("type");
          if (geometry.equals("MultiPolygon"))
          {
            typeGeom = true;
            typeGeom2 = false;
          }
          JSONArray jsonArr = countryCoordShape.getJSONArray("coordinates");
          output.println(jsonArr);
          break;
          
          }
          
      
        }
        if(found!=true & i==countryJSON.size()-1){
          
        println(SELECTNAME);
          
        }
      }

   
   output.close();
 
   //Reading geometry of country requested and creating PShape

   String lines[] = loadStrings("JSONTEST.txt");
   
   FloatList latBorders = new FloatList();
   FloatList lonBorders = new FloatList();
   String compare = "  [[";

//MULTIPOLYGONS 
int counter = 0;
if(typeGeom){
  int startHere = 0;
  IntList nofPolygons = new IntList(); 
  
   for (int cnt = 3; cnt < lines.length-1; cnt = cnt+4)
   {
     
     if (lines[cnt].equals(compare))
     {
       startHere = counter;
       cnt = cnt -2; 
       nofPolygons.append(lonBorders.size());
       }else{
            String thisTest = lines[cnt];
            String thisTest2 = lines[cnt+1];
            String together = thisTest+thisTest2;
            String[] countriesBordertemp = split(together, ',');
            
            lonBorders.append(float(countriesBordertemp[0]));
            latBorders.append(float(countriesBordertemp[1]));
            
          }
      counter = counter + 1;
     }

  //needed for map function
    int w_start = 180; //Longitude start - largest longitude value
    int w_end = -180; //Longitude end - smallest longitude value
    float h_start = 90; //Latitude start - largest latitude value
    float h_end = -90; //Latitude end - smallest latitude value
    
   //!!!!!!!!!!!!!!!!!!!!!!!! IF THERE ARE MORE THAN 2 POLYGONS LIKE IN CANADA
    if (nofPolygons.size()>1)
    {
    countrySHAPE = createShape(GROUP);
    ArrayList<PShape> multiPolygons;
    multiPolygons = new ArrayList<PShape>();
    for(int cnt3 = 0; cnt3 < nofPolygons.size(); cnt3++)
    {
      PShape multiShape;
      multiShape = createShape();
      multiShape.beginShape();
     
   stroke(204,204,204);
     strokeWeight(2);
      multiShape.fill(8,62,120, 255);
      
      
      xborders = new FloatList();
      yborders = new FloatList(); 
     
      if(cnt3 == 0)
      {      
        for (int cnt5 = 0 ; cnt5<nofPolygons.get(0); cnt5++)
       {     
           xborders.append(map(lonBorders.get(cnt5), w_end, w_start, 0, width));
           yborders.append(map(latBorders.get(cnt5), h_start, h_end, 0, height*shrink));
           multiShape.vertex(xborders.get(cnt5), yborders.get(cnt5));
       }
       multiShape.endShape();
       multiPolygons.add(multiShape);
     }else if((cnt3>0) && (cnt3<nofPolygons.size()-1)){
       int cnt8 = 0;
        for (int cnt4 = nofPolygons.get(cnt3-1) ; cnt4< nofPolygons.get(cnt3); cnt4++)
         {
            xborders.append(map(lonBorders.get(cnt4), w_end, w_start, 0, width));
             yborders.append(map(latBorders.get(cnt4), h_start, h_end, 0, height*shrink));
             multiShape.vertex(xborders.get(cnt8), yborders.get(cnt8));
             cnt8 = cnt8 + 1;
        }
         stroke(204,204,204);
     strokeWeight(2);
        multiShape.endShape();
        multiPolygons.add(multiShape);
      } else{
        int cnt9 = 0;
              for (int cnt6 = nofPolygons.get(cnt3); cnt6<latBorders.size(); cnt6++)
               {
                 xborders.append(map(lonBorders.get(cnt6), w_end, w_start, 0, width));
                 yborders.append(map(latBorders.get(cnt6), h_start, h_end, 0, height*shrink));
                 multiShape.vertex(xborders.get(cnt9), yborders.get(cnt9));
                 cnt9 = cnt9 + 1;
               }
                stroke(204,204,204);
     strokeWeight(2);
               multiShape.endShape();
               multiPolygons.add(multiShape);
      }
    }
    // Add polygons to group
    for (int cnt7 = 0; cnt7< multiPolygons.size(); cnt7++){
      countrySHAPE.addChild(multiPolygons.get(cnt7));
    }
   }else{        
//!!!!!    ONLY TWO POLYGONS
        countrySHAPE = createShape(GROUP);
        PShape countrysub1; 
        countrysub1 = createShape();
        countrysub1.beginShape();
       
        stroke(204,204,204);
        strokeWeight(2);
        countrysub1.fill(8,62,120, 255);
    
       
        xborders = new FloatList();
        yborders = new FloatList(); 
           
       for (int k = 0 ; k<startHere; k++)
       {
         xborders.append(map(lonBorders.get(k), w_end, w_start, 0, width));
         yborders.append(map(latBorders.get(k), h_start, h_end, 0, height*shrink));
         countrysub1.vertex(xborders.get(k), yborders.get(k));
       }
      
       countrysub1.endShape();
       
        PShape countrysub2;
        countrysub2 = createShape();
        countrysub2.beginShape();
     
      stroke(204,204,204);
      strokeWeight(2);
        countrysub2.fill(8,62,120, 255);
       
        xborders2 = new FloatList();
        yborders2 = new FloatList();
       
       int cnt2 = 0;
       for (int l = startHere ; l<latBorders.size(); l++)
       {
         xborders2.append(map(lonBorders.get(l), w_end, w_start, 0, width));
         yborders2.append(map(latBorders.get(l), h_start, h_end, 0, height*shrink));
         countrysub2.vertex(xborders2.get(cnt2), yborders2.get(cnt2));
       cnt2 = cnt2 + 1;
       }
    
       countrysub2.endShape();
       
       countrySHAPE.addChild(countrysub1);
       countrySHAPE.addChild(countrysub2);
     
}
}

//POLYGONS
if(typeGeom2)
{
  for (int cnt = 2; cnt < lines.length-1; cnt = cnt+4)
   {
        String thisTest = lines[cnt];
        String thisTest2 = lines[cnt+1];
        String together = thisTest+thisTest2;
        String[] countriesBordertemp = split(together, ',');
        lonBorders.append(float(countriesBordertemp[0]));
        latBorders.append(float(countriesBordertemp[1]));
   }
   
  //Create the pshape object
 
    countrySHAPE = createShape();
    countrySHAPE.beginShape();
    stroke(204,204,204);
    strokeWeight(2);
    countrySHAPE.fill(8,62,120,255);
   
    xborders = new FloatList();
    yborders = new FloatList(); 
    
    //needed for map function
    int w_start = 180; //Longitude start - largest longitude value
    int w_end = -180; //Longitude end - smallest longitude value
    int h_start = 90; //Latitude start - largest latitude value
    float h_end = -90; //Latitude end - smallest latitude value
   
   for (int k = 0 ; k<latBorders.size(); k++)
   {
     xborders.append(map(lonBorders.get(k), w_end, w_start, 0, width));
     yborders.append(map(latBorders.get(k), h_start, h_end, 0, height*shrink));
     countrySHAPE.vertex(xborders.get(k), yborders.get(k));
   }
   countrySHAPE.endShape();
 }

}
 public PShape getShape() {
  return countrySHAPE;
 }

 void update(PVector vector) {
  colorShapeBy = new PVector(vector.x, vector.y, vector.z);
  countrySHAPE.setFill(color(colorShapeBy.x, colorShapeBy.y, colorShapeBy.z));
  shape(countrySHAPE);
 }

}