//Import any other libraries here //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>//
import java.io.IOException;
import java.util.*;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.xpath.XPathExpressionException;

import org.w3c.dom.Element;
import org.w3c.dom.Document;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;
import java.io.File;
import java.io.FileWriter;
import java.io.FileReader;
import java.io.Reader;
import javax.xml.namespace.QName;
import javax.xml.stream.XMLInputFactory;
import javax.xml.stream.XMLStreamConstants;
import javax.xml.stream.XMLStreamReader; /** * This class is used to read XML elements using Stax parser. * @author javawithease */




//Define GLOBAL arrays/variables
HashMap < String, country > Countries = new HashMap();
Object result;
NodeList nodes;
int nNodes;
ArrayList < String > countryNames2 = new ArrayList < String > ();

//Ideally these numbers wouldn't be hard coded in, maybe use an array list
float maxnMedals=0;
int maxnAttendees=0;
float maxGdpRatio=0;
float minGdpRatio=100000000;
int numberOfOlympicGames = 28;
String[] yearString = new String[28];

//**** Don't think the Glyphs are a part of this sketch
//Create Glyphs
String[] YEAR = new String[28];
String[] hostCountry = new String[28];
String[] hostCity = new String[28];
ArrayList < PVector > hostLoc;

// These are used to cycle through the years. Again ideally not hardcoded
int timeStep = 0;
int dT = 0; //For 28 years
int delay = 1;
int diameter = 50;

PFont arialMT;
PFont arialBig;



//Create an array of images
ArrayList < PImage > flags;

//Maximum attendees per year

//!!!!!!!!!!!!!!!!!!!!!!!!!!SETUP FUNCTION!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
void setup() {

// Sets all the country data
 try {
  olympicInfo();
 } catch (Exception e) {
  e.printStackTrace();
 }

 try {
  getLatLon();
 } catch (Exception e) {
  e.printStackTrace();
 }
 
 try {
  continents();
 } catch (Exception e) {
  e.printStackTrace();
 }
 Countries=sortByContinent(Countries);
 
 //Size of SOS should be 2048x1024 at minimum or 4096x2048. Avoid creating a sketch that does not scale
 size(1500,1500, P3D);



// For the sketch as currently set up only the yearString is needed
 //!!!!!!!LOAD DATASETS  Load Historic Dataset
 Table table = loadTable("winterOlympicsDataHistoricAll_v4.csv", "header");
 Table table3 = loadTable("winterOlympicsDataOverall.csv", "header");

 int cnt10 = 0;
 hostLoc = new ArrayList < PVector > ();
 float[] hlat = new float[table3.getRowCount()];
 float[] hlon = new float[table3.getRowCount()];
 //!!!! OVERALL Extract overall data
 for (TableRow row: table3.rows()) {
  String YEAR_ = row.getString("Year");
  String host_ = row.getString("Host");
  String hostc_ = row.getString("City");
  String hostLat = row.getString("Latitude");
  String hostLon = row.getString("Longitude");

  YEAR[cnt10] = YEAR_;
  hostCountry[cnt10] = host_;
  hostCity[cnt10] = hostc_;
  yearString[cnt10] = ("y" + YEAR_);
  hlat[cnt10] = float(hostLat);
  hlon[cnt10] = float(hostLon);

  cnt10 = cnt10 + 1;

 }

 /*** Not needed for this sketch
 //Define local arrays/variables
 /*int nofRows = table.getRowCount();
 float[] lat = new float[nofRows];
 float[] lon = new float[nofRows];*/


 
 
 //Calculate screen values using map function
 //Projection for SOS is Equatorial Cylindrical Equidistant which means x = longitude; y = latitude. 
 //Use the gicentre packages for other projectors. Specially webmercator. 

 //needed for map function
 int w_start = 180; //Longitude start - largest longitude value
 int w_end = -180; //Longitude end - smallest longitude value
 int h_start = 90; //Latitude start - largest latitude value
 float h_end = -83.5; //Latitude end - smallest latitude value

 for (int j = 0; j < table3.getRowCount(); j = j + 1) {
  float temp1 = map(hlon[j], w_end, w_start, 0, width);
  float temp2 = map(hlat[j], h_start, h_end, 0, height);
  PVector hll = new PVector(temp1, temp2);
  hostLoc.add(hll);
 }



 arialMT = loadFont("Arial-BoldMT-48.vlw");
 arialBig = loadFont("Arial-BoldMT-96.vlw");


 //Load flags
 flags = new ArrayList < PImage > ();
// Goes through each country and generates flag filename. Ideally this would be done when generating the country data in olympicInfo()
 for (int j = 0; j < countryNames2.size(); j++) {  
   String flagFile;
   // Checks if theres an iso2 Code for the country, if so uses that for the filename otherwise uses the countries full name. Then throws the flag into a list
  if (Countries.get(countryNames2.get(j)).countryAbbre.length() != 2) {
   //println("nope " + countryNames2.get(j));
   flagFile = "countrySVG/" + Countries.get(countryNames2.get(j)).countryName.replaceAll("\\s+", "").toLowerCase() + ".png";
  } else {
   flagFile = "countrySVG/" + Countries.get(countryNames2.get(j)).countryAbbre.toLowerCase() + ".svg.png";
  }
  PImage currentFlag = loadImage(flagFile);
  flags.add(currentFlag);
  
// Finds the maximum number of medals ever won.
for (Map.Entry < String, country > Countries: Countries.entrySet()) {
for(int years=0;years<yearString.length;years++){
  if(Countries.getValue().olympics.get(yearString[dT]).totMed>maxnMedals){
maxnMedals=Countries.getValue().olympics.get(yearString[dT]).totMed;
}
  if(Countries.getValue().olympics.get(yearString[dT]).athletes>maxnAttendees){
  maxnAttendees=Countries.getValue().olympics.get(yearString[dT]).athletes;
  }
  
  

}
}
 }

for (Map.Entry < String, country > Countries: Countries.entrySet()) {
for(int years=0;years<yearString.length;years++){

  
  if(Countries.getValue().olympics.get(yearString[dT]).gdp/Countries.getValue().olympics.get(yearString[dT]).athletes>maxGdpRatio){
maxGdpRatio=(Countries.getValue().olympics.get(yearString[dT]).gdp/Countries.getValue().olympics.get(yearString[dT]).athletes);
  
}

if(Countries.getValue().olympics.get(yearString[dT]).gdp/Countries.getValue().olympics.get(yearString[dT]).athletes>0 & Countries.getValue().olympics.get(yearString[dT]).gdp/Countries.getValue().olympics.get(yearString[dT]).athletes<minGdpRatio){
minGdpRatio=(Countries.getValue().olympics.get(yearString[dT]).gdp/Countries.getValue().olympics.get(yearString[dT]).athletes);
  
}

}
}
 



}


void draw() {


background(100,100,100);
 stroke(255);
 textSize(24);
 textFont(arialMT);


 float rb = 400;



 noFill();
 stroke(150, 150, 150);
 //!!  FOR NUMBER OF ATTENDEES !!
 /* float maxCircleSize = 2*rb + 2*(height*.2*(maxnAttendees+30)/maxnAttendees);
  float maxCTIS = 2*rb+2*(height*.2*(mAtt[dT]+30)/maxnAttendees);*/

 //!! FOR NUMBER OF MEDALS
 float maxCircleSize = 2 * rb + 2 * (height * .2 * (maxnMedals + 30) / maxnMedals);
 //float maxCTIS = 2*rb+2*(height*.2*(mMed[dT]+30)/maxnMedals);
 // ellipse(width/2, height/2,maxCircleSize, maxCircleSize);
 // ellipse(width/2, height/2, maxCTIS, maxCTIS);



// used to create the arcs in the radial. I'm not sure exactly how the math works. The numbers were handcoded
float total=225;  
float asiasize=53;
float europesize= 53;
float africasize=55;
float nasize=32;
float sasize=11;
float ocsize=19;
float olysize=2;


  
  //ARCS showing Continents
  fill(255,2,112);
  noStroke();
  //Europe
  arc(width/2, height/2, 1.9*rb, 1.9*rb, -PI/2, (2*PI*europesize/total) - PI/2);

   
  fill(232,187,0);
  noStroke();
  //Asia
  arc(width/2, height/2, 1.9*rb, 1.9*rb, -PI/2+2*PI*europesize/total, -PI/2+2*PI*europesize/total+(2*PI*asiasize/total));

  
  fill(255,118,2);
  noStroke();
  //Africa
  arc(width/2, height/2, 1.9*rb, 1.9*rb, -PI/2+2*PI*europesize/total+(2*PI*asiasize/total), -PI/2+2*PI*europesize/total+(2*PI*asiasize/total)+(2*PI*africasize/total));

  
  fill(62,0,232);
  noStroke();
  // Oceania
  arc(width/2, height/2, 1.9*rb, 1.9*rb, -PI/2+2*PI*europesize/total+(2*PI*asiasize/total)+(2*PI*africasize/total), -PI/2+2*PI*europesize/total+(2*PI*asiasize/total)+(2*PI*africasize/total)+(2*PI*ocsize/total));
  fill(4,194,255);
  noStroke();
  //South America
  arc(width/2, height/2, 1.9*rb, 1.9*rb, -PI/2+2*PI*europesize/total+(2*PI*asiasize/total)+(2*PI*africasize/total)+(2*PI*ocsize/total), -PI/2+2*PI*europesize/total+(2*PI*asiasize/total)+(2*PI*africasize/total)+(2*PI*ocsize/total)+(2*PI*sasize/total));


 fill(0,255,121);
  noStroke();
  //North America
  arc(width/2, height/2, 1.9*rb, 1.9*rb, -PI/2+2*PI*europesize/total+(2*PI*asiasize/total)+(2*PI*africasize/total)+(2*PI*ocsize/total)+(2*PI*sasize/total),  -PI/2+2*PI*europesize/total+(2*PI*asiasize/total)+(2*PI*africasize/total)+(2*PI*ocsize/total)+(2*PI*sasize/total)+(2*PI*nasize/total));


fill(200,200,200);
  noStroke();
  // Athletes without a country
  arc(width/2, height/2, 1.9*rb, 1.9*rb,  -PI/2+2*PI*europesize/total+(2*PI*asiasize/total)+(2*PI*africasize/total)+(2*PI*ocsize/total)+(2*PI*sasize/total)+(2*PI*nasize/total),-PI/2+2*PI*europesize/total+(2*PI*asiasize/total)+(2*PI*africasize/total)+(2*PI*ocsize/total)+(2*PI*sasize/total)+(2*PI*nasize/total)+(2*PI*olysize/total));


  
   fill(2,1,0);
  noStroke();
  ellipse(width/2,height/2,1.8*rb,1.8*rb);
  
  
   fill(2,1,0);
  noStroke();
  ellipse(width/2,height/2,1.8*rb,1.8*rb);
  

  


 translate(width / 2, height / 2);


 for (int j = 0; j < countryNames2.size(); j++) {
  //Displays only flags of countries that participated in a years olympics
   if (Countries.get(countryNames2.get(j)).olympics.get(yearString[dT]).athletes > 0) {
   
   float angleDelta = (2 * PI) / (countryNames2.size());
   float xR = rb * sin(angleDelta * j);
   float yR = -rb * cos(angleDelta * j);
   float widthRec = (2 * PI * rb / countryNames2.size()) * .9;
   float baseHeight = height * .1;
   pushMatrix();

   translate(xR, yR);
   rotateZ(PI);
   rotateZ(angleDelta * j);
   noStroke();
   fill(175, 136, 249);
   //Attendees
    
   //  float totalSizeR = baseHeight * (float(Countries.get(countryNames2.get(j)).olympics.get(yearString[dT]).totMed) + 30) / maxnAttendees;
   //int ath = Countries.get(countryNames2.get(j)).olympics.get(yearString[dT]).athletes;
   //int pop = int(Countries.get(countryNames2.get(j)).olympics.get(yearString[dT]).pop);

   fill(191, 243, 255);
   //rect(-widthRec, 0, widthRec, baseHeight * (float(pop / ath)));
   //Medals
   //  rect(-widthRec,0,widthRec, baseHeight*(float(allData.get(j)[timeStep+18])+30)/maxnMedals); 
   float totalSizecomp=baseHeight * (float(Countries.get(countryNames2.get(j)).olympics.get(yearString[dT]).athletes)+10) / maxnAttendees;
   float totalSizeR = baseHeight * Countries.get(countryNames2.get(j)).olympics.get(yearString[dT]).gdp/float(Countries.get(countryNames2.get(j)).olympics.get(yearString[dT]).athletes)  / (maxGdpRatio);
    //rect(-widthRec,0,widthRec, baseHeight*(float(Countries.get(countryNames2.get(j)).olympics.get(yearString[dT]).totMed) +30)/maxnAttendees);
float gdpRat=(Countries.get(countryNames2.get(j)).olympics.get(yearString[dT]).gdp / float(Countries.get(countryNames2.get(j)).olympics.get(yearString[dT]).athletes));
   pushMatrix();


   rotateZ(-PI);
   PImage flagPNG = flags.get(j);
   int scaledSize = int(widthRec);
   flagPNG.resize(scaledSize, scaledSize);   
   image(flagPNG, 0, 35);

   popMatrix();
float hundThou=100000;
float mil=1000000;
float hundMil=100000000;
float tenMil=10000000;
PImage goldB= loadImage("goldBar.png");
PImage silverB= loadImage("silverB.jpg");

if(gdpRat>0){
//println(gdpRat/mil);
}
if(gdpRat/mil<1){
       //Medals Bronze
      fill(120, 64, 34);
        rect(-widthRec, 0, widthRec,  gdpRat/hundThou);
      }

   if(gdpRat/mil<1000){
//Medals Silver
  //fill(196, 196, 180);
  
   beginShape();
      textureWrap(REPEAT);
  texture(silverB);

    vertex(0,0,0,0);
    vertex(0,gdpRat/tenMil,0,gdpRat/tenMil);
    vertex(widthRec,gdpRat/tenMil,30,gdpRat/tenMil);
    vertex(widthRec,0,30,0);

//       rect(-widthRec, 0, widthRec,  gdpRat/mil);
        
        endShape();
      }
      
        else if (gdpRat/mil>1000) {
        //Medals Gold
        //fill(255, 216, 24);
        beginShape();
  println(countryNames2.get(j)+"  "+gdpRat/(mil*10));
      textureWrap(REPEAT);
  texture(goldB);

    vertex(0,0,0,0);
    vertex(0,gdpRat/hundMil,0,gdpRat/hundMil);
    vertex(widthRec,gdpRat/hundMil,30,gdpRat/hundMil);
    vertex(widthRec,0,30,0);

endShape();
        }
      
      
   //Attendees 
   //Male
   //  fill(191, 243, 255);
   
   // rect(-widthRec, 0, widthRec, totalSizeR * ((float(Countries.get(countryNames2.get(j)).olympics.get(yearString[dT]).men))) / float(Countries.get(countryNames2.get(j)).olympics.get(yearString[dT]).athletes));
   //Female
   //fill(255, 191, 243);
   
   //rect(-widthRec, totalSizeR * (float(Countries.get(countryNames2.get(j)).olympics.get(yearString[dT]).men)) / float(Countries.get(countryNames2.get(j)).olympics.get(yearString[dT]).athletes), widthRec, totalSizeR * (float(Countries.get(countryNames2.get(j)).olympics.get(yearString[dT]).women)) / float(Countries.get(countryNames2.get(j)).olympics.get(yearString[dT]).athletes));

  //Medals Bronze
 //       fill(120, 64, 34);
//        rect(-widthRec, 0, widthRec, totalSizeR * (float(Countries.get(countryNames2.get(j)).olympics.get(yearString[dT]).bronze) / float(Countries.get(countryNames2.get(j)).olympics.get(yearString[dT]).totMed)));
        //Medals Silver
  //  fill(196, 196, 180);
    //    rect(-widthRec, totalSizeR * (float(Countries.get(countryNames2.get(j)).olympics.get(yearString[dT]).bronze) / float(Countries.get(countryNames2.get(j)).olympics.get(yearString[dT]).totMed)), widthRec, totalSizeR * (float(Countries.get(countryNames2.get(j)).olympics.get(yearString[dT]).silver) / float(Countries.get(countryNames2.get(j)).olympics.get(yearString[dT]).totMed)));



        //Medals Gold
      //  fill(255, 216, 24);
        //rect(-widthRec, totalSizeR * (float(Countries.get(countryNames2.get(j)).olympics.get(yearString[dT]).bronze) / float(Countries.get(countryNames2.get(j)).olympics.get(yearString[dT]).totMed)) + totalSizeR * (float(Countries.get(countryNames2.get(j)).olympics.get(yearString[dT]).silver) / float(Countries.get(countryNames2.get(j)).olympics.get(yearString[dT]).totMed)), widthRec, totalSizeR * (float(Countries.get(countryNames2.get(j)).olympics.get(yearString[dT]).gold) / float(Countries.get(countryNames2.get(j)).olympics.get(yearString[dT]).totMed)));
       
//Athletes
       // fill(255,255,255);
        //rect(-widthRec*.85,totalSizeR* (float(Countries.get(countryNames2.get(j)).olympics.get(yearString[dT]).bronze) / float(Countries.get(countryNames2.get(j)).olympics.get(yearString[dT]).totMed)) + totalSizeR * (float(Countries.get(countryNames2.get(j)).olympics.get(yearString[dT]).silver) / float(Countries.get(countryNames2.get(j)).olympics.get(yearString[dT]).totMed))+totalSizeR * (float(Countries.get(countryNames2.get(j)).olympics.get(yearString[dT]).gold) / float(Countries.get(countryNames2.get(j)).olympics.get(yearString[dT]).totMed)) , widthRec*.7, totalSizecomp);
       

   popMatrix();
   // break;
  }
 }
 textAlign(CENTER, CENTER);
 textSize(96);
 textFont(arialBig);

 noStroke();
 fill(255, 255, 255);
 text(YEAR[dT], 0, -80);

 noStroke();
/*
 textSize(48);
 textFont(arialMT);
 fill(150, 150, 150);
 text("Number of Participants", 0, 0);
 text("by Gender ", 0, 40);
 fill(255, 191, 243);
 text("Female", -60, 100);
 fill(150, 150, 150);
 text("/", 35, 100);
 fill(191, 243, 255);
 text("Male", 100, 100);

*/

 
     textSize(48);
     textFont(arialMT);
     fill(150, 150, 150);
     text("Number of Medals ", 0, 0);
     text("Won by Country", 0, 40);
     fill(255, 216, 24);
     text("100 Million", -140, 100);

     fill(196, 196, 180);
     text("10 Million", 160, 100);

     //fill(120, 64, 34);
     //text("Bronze", 160, 100);
 
 //Text

 textFont(arialMT);
 textSize(36);
 fill(232, 187, 0);
 noStroke();
 pushMatrix();
 rotateZ(-PI / 3.1);
 text("EUROPE", 0, 0.8 * rb);
 popMatrix();
 pushMatrix();
 rotateZ(0.55);
 fill(255, 118, 2);
 noStroke();
 text("ASIA", 0, 0.8 * rb);
 popMatrix();

 pushMatrix();
 rotateZ(PI / .8);
 fill(255, 2, 112);
 noStroke();
 text("AFRICA", 0, 0.8 * rb);
 popMatrix();

 pushMatrix();
 rotateZ(PI / 1.9);
 fill(62, 0, 232);
 noStroke();
 text("OC", 0, 0.8 * rb);
 popMatrix();

 pushMatrix();
 rotateZ(PI / 1.55);
 fill(62, 0, 232);
 fill(4, 194, 255);
 noStroke();
 text("SA", 0, 0.8 * rb);
 popMatrix();

 pushMatrix();
 rotateZ(PI / 1.18);
 fill(0, 255, 121);
 noStroke();
 text("NA", 0, 0.8 * rb);
 popMatrix();
 pushMatrix();
 rotateZ(PI / 1.01);
 fill(200, 200, 200);
 noStroke();
 text("IOA", 0, 0.8 * rb);
 popMatrix();


 delay   = delay + 1;
 if (delay > 0) {
  delay = 0;
  timeStep = timeStep + 1;
  dT = dT + 1;
 }
 if (timeStep > numberOfOlympicGames - 1) {
  timeStep = 0;
  dT = 0;
 }

 saveFrame("radialChart##.png");

}

/*  Three methods that get the scraped olympic/country data, one method that sorts.
1) olympicInfo -- gets general country information and olympic data
2) getLatLon -- sets the latitude and longitude of countries. This file is the country's center. The lat/lon in the olympic data file is for the capitol.
3) continents -- adds continent information - needed for the radial
4) sortByContinent - sorts the countries by continent. Need for the radial.
*/ 


void olympicInfo() throws ParserConfigurationException, SAXException,
 IOException, XPathExpressionException {

  try { 
  // seems to need an absolute path, I couldn't get relative paths to work here
   String filePath = ("/Users/adamhoch/Documents/processing2/radialChart/data/summerOlympicCountries.xml");
   String elName = null;
   String countName = null;   
   String olName = null;
   int nNodes = 0;
   String countryName;
   String iso2;
   String iso3;
   float pop;
   String part;
   String endEl;
   Boolean olympicEl = null;
   int test = 0;
   HashMap < String, olympics > olympic = null;
   olympics indivGames = null;
   country indCount = null;
   //Read XML file. 
   Reader fileReader = new FileReader(filePath);
   //Get XMLInputFactory instance. 
   XMLInputFactory xmlInputFactory = XMLInputFactory.newInstance();
   //Create XMLStreamReader object. 
   XMLStreamReader xmlStreamReader = xmlInputFactory.createXMLStreamReader(fileReader); //Iterate through events.
   while (xmlStreamReader.hasNext()) {
    //Get integer value of current event. 
    int xmlEvent = xmlStreamReader.next();
    switch (xmlEvent) {
     
     // If it's the start of the element gets the element name
     case XMLStreamConstants.START_ELEMENT:
     
     // Sets variable containing the element name. Used later to connect the element value to its title 
      elName = xmlStreamReader.getLocalName();
      // if the element is item starts a new country. The nNodes variable is neccesary because of how the old code is adapted, it would probably be ideal to go through and eliminate it. 
      if (elName == "item") {
       nNodes = nNodes + 1;
       indCount = new country();       
      } 
      // Every individual olypmic games element starts with a y. This starts a new individual olympic games. the olympicEl variable is used to distinguish overall country results from individual games
      else if (elName.startsWith("y")) {
       indivGames = new olympics();
       olName = xmlStreamReader.getLocalName();
       olympicEl = true;
      }
      // Each country has a single olympic element that contains all the original games. Prepares a hashmap that will contain all the games.
      if (elName == "olympics") {
       olympic = new HashMap < String, olympics > ();
      }

      break;
     // looks for the closing of an element
     case XMLStreamConstants.END_ELEMENT:     
      endEl = xmlStreamReader.getLocalName();
      
      // if the element is item adds all the hashmap containing all the games to the individual country then adds that country to the list of countries
      
      if (xmlStreamReader.getLocalName() == "item") {

       indCount.setOly(olympic);
       Countries.put(countName, indCount);


      } 
      
      // if the element starts with y(an individual years games) adds it to the hashmap of games with a key of the element name (eg "y2008")
      else if (xmlStreamReader.getLocalName().startsWith("y")) {

       olympic.put(olName, indivGames);

       olympicEl = false;

      }
      break;
    }
     

    // Gets the value of the element. In retrospect it might have been more efficient to use attributes instead of elements in the xml
    if (xmlEvent == XMLStreamConstants.CHARACTERS) {

// sets country data on the basis of element name
     switch (elName.toLowerCase()) {
      case "country":
       countName = xmlStreamReader.getText();
       indCount.setConName(countName);

       break;

      case "iso2count":
       iso2 = xmlStreamReader.getText();
       indCount.setIso2(iso2);

       break;
      case "iso3count":
       iso3 = xmlStreamReader.getText();
       indCount.setIso3(iso3);
       break;
      case "incomelevel":
       indCount.setIncome(xmlStreamReader.getText());
       break;
      case "co2":
       indCount.setCo2(float(xmlStreamReader.getText()));
       break;

      case "population":
       pop = float(xmlStreamReader.getText());
       if (olympicEl) {
        indivGames.setPop(float(xmlStreamReader.getText()));
       } else {
        indCount.setPop(pop);
       }
       break;
       case "gdp":       
       if (olympicEl) {
        
        if(xmlStreamReader.getText().length()>4){        
        println(float(xmlStreamReader.getText()));
        indivGames.setGdp(float(xmlStreamReader.getText()));
        }
        
    }
    break;
      case "gold":
       if (olympicEl) {
        indivGames.setGold(xmlStreamReader.getText());
       }
       break;
      case "silver":
       if (olympicEl) {
        indivGames.setSilver(xmlStreamReader.getText());
       }
       break;
      case "bronze":
       if (olympicEl) {
        indivGames.setBronze(xmlStreamReader.getText());
       }
       break;
      case "total":
       if (olympicEl) {
        indivGames.setTot(xmlStreamReader.getText());
       }
       break;
      case "participants":
       if (olympicEl) {
        part = xmlStreamReader.getText();
        indivGames.setAth(part);
        
       break;
       }
      case "men":
       if (olympicEl) {
        indivGames.setMen(xmlStreamReader.getText());
       }
       break;
      case "women":
       if (olympicEl) {
        indivGames.setWomen(xmlStreamReader.getText());
       }
       break;
     }
    }


   }
  } catch (Exception e) {
   e.printStackTrace();
  }

 }