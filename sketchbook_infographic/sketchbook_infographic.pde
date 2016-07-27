//Import any other libraries here //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>//
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
ArrayList < String[] > allData;
ArrayList < Float > x = new ArrayList < Float > ();
ArrayList < Float > y = new ArrayList < Float > ();
String[] countryNames = new String[119];
String[] countryAbb = new String[119];
float[] pop = new float[119];
float[] areaL = new float[119];
float[] gdp = new float[119];
float[] CO2 = new float[119];
float[] gdpPcap = new float[119];
float maxnAttendees;
float maxnMedals;
float maxGdpRatMil=0;
float shrink = 1;
//initialize svg shape
PShape worldSVG;
String[] yearString = new String[28];
String[] YEAR = new String[28];
String[] hostCountry = new String[28];
String[] hostCity = new String[28];
float[] totalMedalsOlympics=new float[28];
PImage olympicsLogo, sprite, overlay, colorbar, medalYEAR, barChart;
//ArrayList<PImage> medal;
float spacer=0;
//offscreen buffer!
ArrayList < PGraphics > PG;
IntList pg_index;
float mil=1000000;
int aa=0,bb=0,cc=0,dd=0,ee=0,ff=0;
HashMap < String, country > Countries = new HashMap();
Object result;
NodeList nodes;
int nNodes;
ArrayList < String > countryNames2 = new ArrayList < String > ();

// THIS INITIALIZES SHAPES OF COUNTRIES - Great for cartigram or chlorophet
ArrayList < createCountry > allShapes;

//Create Glyphs
float maxpop, maxGDP, maxareaL;
float minpop, minGDP, minareaL;
ArrayList < PVector > hostLoc;

int timeStep = 0;
int dT = 0; //For 24 years
int delay = 1;
int diameter = 50;

//This is where I would initialize easing functions
//Ani aniA;

//Fonts
PFont sans, sansp, arialMT, arialMTsmall;

//Trouble children Shapes
ArrayList < PShape > troubleChildren;

//Coordinates for Europe BOX
PVector europeBoxUpper;
PVector europeBoxLower;

//Overlays
ArrayList < PImage > rCharts;

//Maximum attendees per year and number maximum medals
float mAtt;
float mMed;
float[] meOverAt = new float[24]; //medals over participants
float[] AtOverGPC = new float[24]; // national support


//!!!!!!!!!!!!!!!!!!!!!!!!!!SETUP FUNCTION!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
void setup() {

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
// Countries = sortByContinent(Countries);

 float rb = width * .06;
 maxnAttendees = 150;
println("<25 "+aa);
println("<50 "+bb);
println("<1000 "+cc);
println("<5000 "+dd);
println("<10000 "+ee);
println("ff "+ff);
 //Size of SOS should be 2048x1024 at minimum or 4096x2048. Avoid creating a sketch that does not scale
 size(4028,2048, P3D);



 //!!!!!!!LOAD DATASETS  Load Historic Dataset
 Table table = loadTable("winterOlympicsDataHistoricAll_v3.csv", "header");
 Table table2 = loadTable("winterOlympicsDataByCountry_v1.csv", "header");
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


 //Define local arrays/variables
 int nofRows = table.getRowCount();

 float[] lat = new float[nofRows];
 float[] lon = new float[nofRows];

 int i = 0;

 //!!!! GEOPOLITICAL DATA HERE -- Extract and arrange data
 for (TableRow row: table.rows()) {
  String countryName = row.getString("Country");
  String countryAbbre = row.getString("Alpha-2 code");
  float latitude = row.getFloat("Latitude (average)");
  float longitude = row.getFloat("Longitude (average)");
  float population = row.getFloat("Population (2012)");
  float gdp_ = row.getFloat("GDP");
  float land_area = row.getFloat("Land Area (sq km)");
  float co2_ = row.getFloat("CO2 emissions (kt)");

  countryNames[i] = countryName;
  countryAbb[i] = countryAbbre;
  lat[i] = latitude;
  lon[i] = longitude;
  pop[i] = population;
  areaL[i] = land_area;
  gdp[i] = gdp_;
  CO2[i] = co2_;
  gdpPcap[i] = gdp_ / population;
  i = i + 1;
 }

 maxpop = max(pop);
 minpop = min(pop);
 maxareaL = max(areaL);
 minareaL = min(areaL);
 maxGDP = max(gdp);
 minGDP = min(gdp);

 //Calculate screen values using map function
 //Projection for SOS is Equatorial Cylindrical Equidistant which means x = longitude; y = latitude. 
 //Use the gicentre packages for other projectors. Specially webmercator. 

 //needed for map function
 int w_start = 180; //Longitude start - largest longitude value
 int w_end = -180; //Longitude end - smallest longitude value
 float h_start = 90; //Latitude start - largest latitude value
 float h_end = -90; //Latitude end - smallest latitude value

 for (int j = 0; j < table3.getRowCount(); j = j + 1) {
  float temp1 = map(hlon[j], w_end, w_start, 0, width);
  float temp2 = map(hlat[j], h_start, h_end, 0, height);
  PVector hll = new PVector(temp1, temp2);
  hostLoc.add(hll);
 }
 //println(yearString[dT]);
 for (int j = 0; j < countryNames2.size(); j = j + 1) {

  x.add(map(Countries.get(countryNames2.get(j)).longitude, w_end, w_start, 0, width));
  y.add(map(Countries.get(countryNames2.get(j)).latitude, h_start, h_end, 0, height * shrink));

 }

 //!!!!!!! EUROPE BOX, X, Y COORDINATES////
 float xlTemp = map(-8, w_end, w_start, 0, width);
 float ylTemp = map(30, h_start, h_end, 0, height);
 float xuTemp = map(40, w_end, w_start, 0, width);
 float yuTemp = map(70, h_start, h_end, 0, height);
 europeBoxUpper = new PVector(xuTemp, yuTemp);
 europeBoxLower = new PVector(xlTemp, ylTemp);
 //println(xlTemp+"  "+ylTemp+"  "+xuTemp+"  "+yuTemp);

 //!!!!! SHAPE DATA HERE + ALL OLYMPIC DATA BY COUNTRY ---- Extract and arrange all data
 //The array allData contains all data per country by an array of Strings[]
 allData = new ArrayList < String[] > ();
 allShapes = new ArrayList < createCountry > ();
 int[] indexTrouble = new int[6];


 for (int cnt = 0; cnt < countryNames2.size(); cnt++) {
  int cnt2 = 0;

  createCountry COUNTRYSHAPE;

  //initialize shapes here


  COUNTRYSHAPE = new createCountry(Countries.get(countryNames2.get(cnt)).countryName, Countries.get(countryNames2.get(cnt)).countryIso3, Countries.get(countryNames2.get(cnt)).olympics.get(yearString[dT]).athletes);
  allShapes.add(COUNTRYSHAPE);
 Countries.get(countryNames2.get(cnt)).setShape(COUNTRYSHAPE);


 }
 //  print(allShapes.get(120));
 // Deal with trouble children
 PShape CZECHO, SERMON, USSR, YUGOS, UNITEAM, UAR;
 //Append troublechildren
 troubleChildren = new ArrayList < PShape > ();
 //  

 SERMON = createShape(GROUP);
 createCountry serS = new createCountry("Serbia", "", 1);
 createCountry monS = new createCountry("Montenegro", "", 1);
 SERMON.addChild(serS.getShape());
 SERMON.addChild(monS.getShape());
 troubleChildren.add(SERMON);
 Countries.get("Serbia and Montenegro").setShapeCombo(SERMON);

 USSR = createShape(GROUP);
 createCountry rusS = new createCountry("Russia", "", 1);
 createCountry ukrS = new createCountry("Ukraine", "", 1);
 createCountry uzbS = new createCountry("Uzbekistan", "", 1);
 createCountry kazS = new createCountry("Kazakhstan", "", 1);
 createCountry belS = new createCountry("Belarus", "", 1);
 createCountry azeS = new createCountry("Azerbaijan", "", 1);
 createCountry geoS = new createCountry("Georgia", "", 1);
 createCountry tajS = new createCountry("Tajikistan", "", 1);
 createCountry molS = new createCountry("Moldova", "", 1);
 createCountry kyrS = new createCountry("Kyrgyzstan", "", 1);
 createCountry litS = new createCountry("Lithuania", "", 1);
 createCountry estS = new createCountry("Estonia", "", 1);
 createCountry armS = new createCountry("Armenia", "", 1);
 createCountry latS = new createCountry("Latvia", "", 1);
 USSR.addChild(rusS.getShape());
 USSR.addChild(ukrS.getShape());
 USSR.addChild(uzbS.getShape());
 USSR.addChild(kazS.getShape());
 USSR.addChild(belS.getShape());
 USSR.addChild(azeS.getShape());
 USSR.addChild(geoS.getShape());
 USSR.addChild(tajS.getShape());
 USSR.addChild(molS.getShape());
 USSR.addChild(kyrS.getShape());
 USSR.addChild(litS.getShape());
 USSR.addChild(estS.getShape());
 USSR.addChild(armS.getShape());
 USSR.addChild(latS.getShape());
 // troubleChildren.add(USSR);
  Countries.get("Soviet Union").setShapeCombo(USSR);
 //  


 //
 UNITEAM = createShape(GROUP);
 createCountry rus2S = new createCountry("Russia", "", 0);
 createCountry ukr2S = new createCountry("Ukraine", "", 0);
 createCountry uzb2S = new createCountry("Uzbekistan", "", 0);
 createCountry kaz2S = new createCountry("Kazakhstan", "", 0);
 createCountry bel2S = new createCountry("Belarus", "", 0);
 createCountry aze2S = new createCountry("Azerbaijan", "", 0);
 createCountry geo2S = new createCountry("Georgia", "", 0);
 createCountry taj2S = new createCountry("Tajikistan", "", 0);
 createCountry mol2S = new createCountry("Moldova", "", 0);
 createCountry kyr2S = new createCountry("Kyrgyzstan", "", 0);
 createCountry arm2S = new createCountry("Armenia", "", 0);
 UNITEAM.addChild(rus2S.getShape());
 UNITEAM.addChild(ukr2S.getShape());
 UNITEAM.addChild(uzb2S.getShape());
 UNITEAM.addChild(kaz2S.getShape());
 UNITEAM.addChild(bel2S.getShape());
 UNITEAM.addChild(aze2S.getShape());
 UNITEAM.addChild(geo2S.getShape());
 UNITEAM.addChild(taj2S.getShape());
 UNITEAM.addChild(mol2S.getShape());
 UNITEAM.addChild(kyr2S.getShape());
 UNITEAM.addChild(arm2S.getShape());
 troubleChildren.add(UNITEAM);
 Countries.get("Unified Team").setShapeCombo(UNITEAM);

 YUGOS = createShape(GROUP);
 createCountry ser2S = new createCountry("Serbia", "", 0);
 createCountry mon2S = new createCountry("Montenegro", "", 0);
 createCountry slovS = new createCountry("Slovenia", "", 1);
 createCountry croS = new createCountry("Croatia", "", 1);
 createCountry bosS = new createCountry("Bosnia and Herzegovina", "BA", 1);
 YUGOS.addChild(ser2S.getShape());
 YUGOS.addChild(mon2S.getShape());
 YUGOS.addChild(slovS.getShape());
 YUGOS.addChild(croS.getShape());
 YUGOS.addChild(bosS.getShape());
 troubleChildren.add(YUGOS);
 //Countries.get("Yugoslavia").setShapeCombo(YUGOS);
 
 UAR = createShape(GROUP);
 createCountry egy= new createCountry("Egpyt","",0);
 createCountry syr= new createCountry("Syria","",0);
 UAR.addChild(egy.getShape());
 UAR.addChild(syr.getShape());
 troubleChildren.add(YUGOS);
 Countries.get("United Arab Republic").setShapeCombo(UAR);
 

 //!!!! BACKGROUND SVG -- load an svg of world
 worldSVG = loadShape("BlankMap-Equirectangular.svg");
 overlay = loadImage("4096.png");
 olympicsLogo = loadImage("Olympic_rings_square_flood.png");
 sprite = loadImage("sprite.png");
 colorbar = loadImage("colorbar.png");
 medalYEAR = loadImage("medalsGlyphs/1956_pie_bg.png");
 barChart = loadImage("barChart2014.png");

 //  noLoop();
 //Adding Ani
 //Ani.init(this);
 //aniA = new Ani(this, 2, "USA", 100);

 //load font
 sans = loadFont("SansSerif.bold-72.vlw");
 sansp = loadFont("SansSerif.plain-60.vlw");
 arialMT = loadFont("Arial-BoldMT-76.vlw");

 //Here we get the maximum number of VARIABLE per year
 int anothercount = 0;
 float mAtt2 = 0;
 float mMed2 = 0;
  totalMedalsOlympics[dT]=0;
 for (int k = 0; k < countryNames2.size(); k++) {



  float test = 0;
  //Get attendees maximum per year
  int j = k;
  if (countryNames2.get(k).equals("Individual Olympic Athletes")) {
   //println("done "+k);
  }
  float attYear = float(Countries.get(countryNames2.get(k)).olympics.get(yearString[dT]).athletes);
  float medalYear = float(Countries.get(countryNames2.get(k)).olympics.get(yearString[dT]).totMed);
  float medalOverAttend;
  float natSup = 0;
  if (Float.isNaN(attYear)) {
   attYear = 0;
  }
  if (Float.isNaN(medalYear)) {
   medalYear = 0;
  }
  int olYear=0;
  for (Map.Entry < String, olympics > entry: Countries.get(countryNames2.get(k)).olympics.entrySet()) {
  
  totalMedalsOlympics[olYear]=totalMedalsOlympics[olYear]+entry.getValue().totMed;
  olYear++;
}
  if (attYear < 0) {
    
   medalOverAttend = medalYear / attYear;
   natSup = attYear / (Countries.get(countryNames2.get(k)).olympics.get(yearString[dT]).gdp / Countries.get(countryNames2.get(k)).olympics.get(yearString[dT]).pop);
  } else {
   medalOverAttend = 0;
  }
  //println(attYear);
  if (mAtt2 < attYear) {
   mAtt2 = attYear;
  }
  //println(countryNames2.get(j)+" athletes: "+attYear+" "+mAtt2);
  if (mMed2 < medalYear) {
   mMed2 = medalYear;
  };
  mAtt = mAtt2;
  mMed = 239;
  anothercount = anothercount + 1;


 }
//println("");


}

//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!DRAW FUNCTION!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
void draw() {
 background(100, 100, 100);
 stroke(255);
 smooth();
 PImage silverB= loadImage("silverB.jpg");
 hint(DISABLE_DEPTH_TEST); //avoids z-fighting
 nNodes = countryNames2.size();
 //maxnAttendees = mAtt[dT];
 maxnAttendees = mAtt;
 maxnMedals = mMed;
 int opArc = 255;
 spacer=0;
 //Display SVG
 worldSVG.setFill(color(90, 90, 90));
 shape(worldSVG, 0, 0, width, height * .965);
 float rb = width * .06;
 //Draw Countries Participating in all Olympics
 for (int k = 0; k < x.size(); k = k + 1) {
  //  float rc = sqrt(rb*rb*pop[k]/maxpop);
  //    noStroke();
  //   fill(100,100,100);
  noFill();
  stroke(196, 125, 0, 100);
  //////        noStroke();
  //CREATE TRAVEL LINES --- Need to fix for date line
  //     PVector hostXY = hostLoc.get(dT);
  //if(float(allData.get(k)[timeStep+7])>0){
  //   bezier(x[k], y[k], x[k]-100, y[k]-10, hostXY.x+100, hostXY.y-10, hostXY.x, hostXY.y);
  //  ellipse(x[k],y[k], rc, rc);
  // text(countryNames[k], x[k], y[k]);
  //}
 }

 ///!!!!!!!!! BOX FOR EUROPE

 float xb1 = europeBoxLower.x;
 float yb1 = europeBoxLower.y;
 float xb2 = europeBoxUpper.x;
 float yb2 = europeBoxUpper.y;
 float disp = (yb1 - yb2) * 1.9;
 IntList indexDisp = new IntList();
 int cntDisp = 0;

 int textSIZE = int(width * .025); //maximum size for the text -- if the size of the sketch is changed - modify this!
 //println("1 "+textSIZE);
 int minSIZE = int(width * .006); //minimum size for the text
 int dText = int(width * .025); //Condition to displace text

 //!!!!!!!!!!!!!!!!!!!!!!!!!END SCALE NUMBERS
 int jA = 0;

 //Initialize arraylist for offscreen buffer 
 PG = new ArrayList < PGraphics > ();
 pg_index = new IntList();
 /////!!!!!!!!!!!!! Draw the country SHAPES, AND GLYPHS 
 for (int j = 0; j < countryNames2.size(); j++) {
//println(countryNames2.get(j));
//println(dT);
  int inOlympics = int(Countries.get(countryNames2.get(j)).olympics.get(yearString[dT]).athletes);
  //int testing = int(Countries.get(countryNames2.get(j)).olympics.get(yearString[dT]).totMed);
  float gdpRatMil=(Countries.get(countryNames2.get(j)).olympics.get(yearString[dT]).gdp/Countries.get(countryNames2.get(j)).olympics.get(yearString[dT]).pop/Countries.get(countryNames2.get(j)).olympics.get(yearString[dT]).athletes);
  if (inOlympics == 0) {
   // Do nothing
  } else if (Countries.get(countryNames2.get(j)).shapeCombo != null) {
   //!!!!!!!!!!!!!!!!!!!!!!!!!!!!SHAPES

   PShape current = Countries.get(countryNames2.get(j)).shapeCombo;
   PVector won = new PVector(88, 141, 196); //Won medals
   PVector lost = new PVector(8, 62, 120); //Did not win medals

   //BINARY CLOROPLETH
   /*   if(float(allData.get(j)[timeStep+14])>0){
      country.update(won);}
      else{
      country.update(lost);}*/

   //CLOROPLETH EMPLOYING COLORMAP

   //replace this variables depending on what we will display
   //can make it more generic and create a cloropleth function that takes in the 
   //number of the variable to be colored by
   int numAtt = 7; // place of attendants value in csv file
   int medalsPlace = 14; //place of total medals
   float fractionWon = float(Countries.get(countryNames2.get(j)).olympics.get(yearString[dT]).totMed) / float(Countries.get(countryNames2.get(j)).olympics.get(yearString[dT]).athletes);

   colorScaleCountry colorRange = new colorScaleCountry(gdpRatMil, maxnMedals);
   
   if (float(Countries.get(countryNames2.get(j)).olympics.get(yearString[dT]).totMed) > 0) {
    colorRange = new colorScaleCountry(gdpRatMil, .7);
    //println(float(Countries.get(countryNames2.get(j)).olympics.get(yearString[dT]).totMed)/totalMedalsOlympics[dT]+" perc avail med");
   }

   PVector cR = colorRange.getValue();


   //if medals == 0, color country blue, otherwise use colormap
   /*   if(float(allData.get(j)[timeStep+medalsPlace])==0.0){
        PVector participatedCountry = new PVector(89,97,107);
        country.update(participatedCountry);
     }else{*/
   current.setFill(color(cR.x, cR.y, cR.z)); //}
   shape(current);

   // }
   int sizePG = 750;
   //All the stuff from now on is going to the offscreen buffer
   PGraphics pg = createGraphics(sizePG, sizePG); //size of offscreen buffer! Should be much larger - resize images later
   pg.beginDraw();
   pg.background(0, 0, 0, 0);
   pg.smooth();

   //!!!!!!!!!!!!!!!!!!!!!!!!!!Ellipse representation for number of participants per year
   //scale
   pg.stroke(69, 44, 0);
   pg.fill(196, 125, 0);


   //Population
   //   float rc = sqrt(rb*rb*pop[j]/maxpop);   //SIZE with respect to population

   //Number of medals
   float rc = sqrt(sq(sizePG) * fractionWon);
   //println(countryNames2.get(j)+" sizePG "+sizePG+" fractionWon "+fractionWon+ " total medals "+Countries.get(countryNames2.get(j)).olympics.get(yearString[dT]).totMed+ " athletes "+Countries.get(countryNames2.get(j)).olympics.get(yearString[dT]).athletes);
   
   float rtotal = sizePG;

   pg.stroke(69, 44, 0);
   float percentWomen = float(Countries.get(countryNames2.get(j)).olympics.get(yearString[dT]).women) / float(Countries.get(countryNames2.get(j)).olympics.get(yearString[dT]).athletes);

   pg.fill(196, 125, 0, 0);
   //pg.ellipse(sizePG / 2, sizePG / 2, rtotal, rtotal);

   pg.noStroke();


   //pg.fill(137, 207, 240, 150);
   textureWrap(REPEAT);
  texture(silverB);

 //  pg.arc(sizePG / 2, sizePG / 2, rtotal, rtotal, -PI / 2, -PI / 2 + 2 * PI * (1 - percentWomen));

   pg.fill(255, 182, 193, 150);
   //pg.arc(sizePG / 2, sizePG / 2, rtotal, rtotal, -PI / 2 + 2 * PI * (1 - percentWomen), 3 * PI / 2);
   //Size by medals
   //Size by medals
   float ts = 1 * sizePG / 5;
   pg.fill(255, 255, 255);
   pg.textFont(arialMT);
   pg.textSize(ts);
   //println("2 "+ts);
   pg.textAlign(CENTER, CENTER);
   //pg.text(allData.get(j)[timeStep+numAtt],sizePG/2,4*sizePG/5);  


   //Number of attendants - 6 is the minimum size of the circle and text
   //  float rc = sqrt(rb*rb*float(allData.get(j)[timeStep+7])/maxnAttendees)+minSIZE;
   //   ellipse(x[j],y[j],rc,rc);


   //!!!!tHIS if IS ONLY FOR THE MEDALS -- ERASE FOR ALL ATTENDANTS AND COMMENT OUT ELLIPSES!!
   if (float(Countries.get(countryNames2.get(j)).olympics.get(yearString[dT]).totMed) > 1000) {

    colorScaleE colorRangeE = new colorScaleE(fractionWon*100, 100);
    PVector cRE = colorRangeE.getValue();
    pg.stroke(cRE.x, cRE.y, cRE.z);
    pg.fill(cRE.x, cRE.y, cRE.z);
   // pg.ellipse(sizePG / 2, sizePG / 2, rc, rc);

    //  ellipse(x[j],y[j],rc,rc);
    pg.stroke(69, 44, 0);
    pg.fill(196, 125, 0, 50);

    //create ARCS HERE
    //calculate size of slize
    float slizeBronze = float(Countries.get(countryNames2.get(j)).olympics.get(yearString[dT]).bronze) / float(Countries.get(countryNames2.get(j)).olympics.get(yearString[dT]).totMed);
    float slizeSilver = float(Countries.get(countryNames2.get(j)).olympics.get(yearString[dT]).silver) / float(Countries.get(countryNames2.get(j)).olympics.get(yearString[dT]).totMed);
    float slizeGold = float(Countries.get(countryNames2.get(j)).olympics.get(yearString[dT]).gold) / float(Countries.get(countryNames2.get(j)).olympics.get(yearString[dT]).totMed);
    //create ARCS HERE
    //Bronze
    if ((slizeBronze != 0) && (slizeSilver != 0) && (slizeGold != 0)) {
     //createGold slice
     pg.noStroke();
     pg.fill(255, 216, 24, opArc);
     pg.arc(sizePG / 2, sizePG / 2, rc, rc, -PI / 2, -PI / 2 + 2 * PI * slizeGold);;
     //createSilver slice
     pg.noStroke();
     pg.fill(161, 161, 161, opArc);
     pg.arc(sizePG / 2, sizePG / 2, rc, rc, -PI / 2 + 2 * PI * slizeGold, -PI / 2 + 2 * PI * slizeGold + 2 * PI * slizeSilver);
     //createBronze slice
     pg.noStroke();
     pg.fill(120, 85, 64, opArc);
     pg.arc(sizePG / 2, sizePG / 2, rc, rc, -PI / 2 + 2 * PI * slizeGold + 2 * PI * slizeSilver, 3 * PI / 2);
    } else if ((slizeBronze == 0) && (slizeSilver != 0) && (slizeGold != 0)) { //createGold
     pg.noStroke();
     pg.fill(255, 216, 24, opArc);
     pg.arc(sizePG / 2, sizePG / 2, rc, rc, -PI / 2, -PI / 2 + 2 * PI * slizeGold);
     //createSilver
     pg.noStroke();
     pg.fill(161, 161, 161, opArc);
     pg.arc(sizePG / 2, sizePG / 2, rc, rc, -PI / 2 + 2 * PI * slizeGold, 3 * PI / 2);
    } else if ((slizeBronze == 0) && (slizeSilver == 0) && (slizeGold != 0)) {
     //createGold
     pg.noStroke();
     pg.fill(255, 216, 24, opArc);
     pg.arc(sizePG / 2, sizePG / 2, rc, rc, -PI / 2, 3 * PI / 2);
    } else if ((slizeBronze != 0) && (slizeSilver == 0) && (slizeGold != 0)) {
     //createGold slice
     pg.noStroke();
     pg.fill(255, 216, 24, opArc);
     pg.arc(sizePG / 2, sizePG / 2, rc, rc, -PI / 2, -PI / 2 + 2 * PI * slizeGold);
     //createBronze
     pg.noStroke();
     pg.fill(120, 85, 64, opArc);
     pg.arc(sizePG / 2, sizePG / 2, rc, rc, -PI / 2 + 2 * PI * slizeGold, 3 * PI / 2);
    } else if ((slizeBronze != 0) && (slizeSilver != 0) && (slizeGold == 0)) {
     //createSilver slice
     pg.noStroke();
     pg.fill(161, 161, 161, opArc);
     pg.arc(sizePG / 2, sizePG / 2, rc, rc, -PI / 2, -PI / 2 + 2 * PI * slizeSilver);
     //createBronze
     pg.noStroke();
     pg.fill(120, 85, 64, opArc);
     pg.arc(sizePG / 2, sizePG / 2, rc, rc, -PI / 2 + 2 * PI * slizeSilver, 3 * PI / 2);
    } else if ((slizeBronze != 0) && (slizeSilver == 0) && (slizeGold == 0)) {
     //createBronze
     pg.noStroke();
     pg.fill(120, 85, 64, opArc);
     pg.arc(sizePG / 2, sizePG / 2, rc, rc, -PI / 2, 3 * PI / 2);
    } else {
     //createSilver
     pg.noStroke();
     pg.fill(161, 161, 161, opArc);
     pg.arc(sizePG / 2, sizePG / 2, rc, rc, -PI / 2, 3 * PI / 2);
    }

    /////!!!!!!!!!!!!! PUSH OUT TEXT OVER EUROPE !!!!!!! BOX COORDINATE IN SETUP        
    //Number of Atheletes
    pg.fill(8, 62, 120);
    pg.textFont(arialMT);
    // Size by attendants too
    //   float ts = sqrt(textSIZE*textSIZE*float(allData.get(j)[timeStep+7])/maxnAttendees)+minSIZE;


    //Size by medals
    //    float ts = 2*sizePG/3;
    pg.textSize(2 * rc / 3);
    //println("3 "+(2*rc/3));
    pg.textAlign(CENTER, CENTER);
    //pg.text(Countries.get(countryNames2.get(j)).olympics.get(yearString[dT]).totMed, sizePG / 2, sizePG / 2);
    //   pg.text(int(fractionWon*100), sizePG/2, sizePG/2); 






   }

   pg.textSize(ts);
   //println("4 "+ts);
   pg.fill(255, 255, 255);
   pg.textAlign(CENTER, CENTER);
   //pg.text(Countries.get(countryNames2.get(j)).olympics.get(yearString[dT]).athletes, sizePG / 2, 4 * sizePG / 5);
   pg.textSize(100);
   //pg.text(countryNames2.get(j), (sizePG / 2), (sizePG / 9));

   pg.endDraw();
   PG.add(pg);
   //    pg.clear();
   pg_index.append(j);


  } else {
   //!!!!!!!!!!!!!!!!!!!!!!!!!!!!SHAPES

   createCountry country = allShapes.get(j - jA);
   PVector won = new PVector(88, 141, 196); //Won medals
   PVector lost = new PVector(8, 62, 120); //Did not win medals

   //BINARY CLOROPLETH
   /*   if(float(allData.get(j)[timeStep+14])>0){
      country.update(won);}
      else{
      country.update(lost);}*/

   //CLOROPLETH EMPLOYING COLORMAP

   //replace this variables depending on what we will display
   //can make it more generic and create a cloropleth function that takes in the 
   //number of the variable to be colored by
   int numAtt = 7; // place of attendants value in csv file
   int medalsPlace = 14; //place of total medals
   float fractionWon = float(Countries.get(countryNames2.get(j)).olympics.get(yearString[dT]).totMed) / float(Countries.get(countryNames2.get(j)).olympics.get(yearString[dT]).athletes);
   if (fractionWon > 1) {
    fractionWon = 1;
   }



   colorScaleCountry colorRange = new colorScaleCountry(gdpRatMil, maxnMedals);
   if (float(Countries.get(countryNames2.get(j)).olympics.get(yearString[dT]).totMed) > 0) {
    colorRange = new colorScaleCountry(gdpRatMil, .7);
    //println(float(Countries.get(countryNames2.get(j)).olympics.get(yearString[dT]).totMed)/totalMedalsOlympics[dT]+" perc avail med");
    
   }

   PVector cR = colorRange.getValue();


   //if medals == 0, color country blue, otherwise use colormap
   /*   if(float(allData.get(j)[timeStep+medalsPlace])==0.0){
        PVector participatedCountry = new PVector(89,97,107);
        country.update(participatedCountry);
     }else{*/
   country.update(cR);
   // }
   int sizePG = 750;
   //All the stuff from now on is going to the offscreen buffer
   PGraphics pg = createGraphics(sizePG, sizePG); //size of offscreen buffer! Should be much larger - resize images later
   pg.beginDraw();
   pg.background(0, 0, 0, 0);
   pg.smooth();

   //!!!!!!!!!!!!!!!!!!!!!!!!!!Ellipse representation for number of participants per year
   //scale
   pg.stroke(69, 44, 0);
   pg.fill(196, 125, 0, 50);


   //Population
   //   float rc = sqrt(rb*rb*pop[j]/maxpop);   //SIZE with respect to population

   //Number of medals
   float rc = sqrt(sq(sizePG) * fractionWon);
   //println(countryNames2.get(j)+" sizePG "+sizePG+" fractionWon "+fractionWon+ " total medals "+Countries.get(countryNames2.get(j)).olympics.get(yearString[dT]).totMed+ " athletes "+Countries.get(countryNames2.get(j)).olympics.get(yearString[dT]).athletes);

   float rtotal = sizePG;
   float percentWomen = float(Countries.get(countryNames2.get(j)).olympics.get(yearString[dT]).women) / float(Countries.get(countryNames2.get(j)).olympics.get(yearString[dT]).athletes);

   pg.fill(196, 125, 0, 0);
  // pg.ellipse(sizePG / 2, sizePG / 2, rtotal, rtotal);

   pg.noStroke();

//***** CREATES THE CIRCLES OVER THE COUNTRIES
colorScale yellowColorRange = new colorScale(gdpRatMil, maxnMedals);
 PVector ycR = yellowColorRange.getValue();
 color gold = color(ycR.x, ycR.y, ycR.z);
// println(countryNames2.get(j)+" year "+yearString[dT]+" gdp "+gdpRatMil);
   //pg.fill(137, 207, 240, 150);
   if (gdpRatMil<1000){
    pg.fill(ycR.x, ycR.y, ycR.z,150);}
    else {
    pg.fill(ycR.x, ycR.y, ycR.z,150);
    }
  // pg.arc(sizePG / 2, sizePG / 2, rtotal, rtotal, -PI / 2, -PI / 2 + 2 * PI * (1 - percentWomen));

    //pg.fill(161, 161, 161);
   
  // pg.arc(sizePG / 2, sizePG / 2, rtotal, rtotal, -PI / 2 + 2 * PI * (1 - percentWomen), 3 * PI / 2);
   //Size by medals
   float ts = 1 * sizePG / 5;
   pg.fill(255, 255, 255);
   pg.textFont(arialMT);
   pg.textSize(ts);
   //println("2 "+ts);
   pg.textAlign(CENTER, CENTER);
   //pg.text(allData.get(j)[timeStep+numAtt],sizePG/2,4*sizePG/5);  


   //Number of attendants - 6 is the minimum size of the circle and text
   //  float rc = sqrt(rb*rb*float(allData.get(j)[timeStep+7])/maxnAttendees)+minSIZE;
   //   ellipse(x[j],y[j],rc,rc);


   //!!!!tHIS if IS ONLY FOR THE MEDALS -- ERASE FOR ALL ATTENDANTS AND COMMENT OUT ELLIPSES!!
   if (float(Countries.get(countryNames2.get(j)).olympics.get(yearString[dT]).athletes) > 0) {

    colorScaleE colorRangeE = new colorScaleE(fractionWon * 100, 53);
    
    PVector cRE = colorRangeE.getValue();
    pg.stroke(cRE.x, cRE.y, cRE.z);
    pg.fill(cRE.x, cRE.y, cRE.z);
  //  pg.ellipse(sizePG / 2, sizePG / 2, rc, rc);

    //  ellipse(x[j],y[j],rc,rc);
    pg.stroke(69, 44, 0);
    pg.fill(196, 125, 0, 50);

    //create ARCS HERE
    //calculate size of slize
   /* float slizeBronze = float(Countries.get(countryNames2.get(j)).olympics.get(yearString[dT]).bronze) / float(Countries.get(countryNames2.get(j)).olympics.get(yearString[dT]).totMed);
    float slizeSilver = float(Countries.get(countryNames2.get(j)).olympics.get(yearString[dT]).silver) / float(Countries.get(countryNames2.get(j)).olympics.get(yearString[dT]).totMed);
    float slizeGold = float(Countries.get(countryNames2.get(j)).olympics.get(yearString[dT]).gold) / float(Countries.get(countryNames2.get(j)).olympics.get(yearString[dT]).totMed);*/
    //create ARCS HERE
    //Bronze
   /* if ((slizeBronze != 0) && (slizeSilver != 0) && (slizeGold != 0)) {
     //createGold slice
     pg.noStroke();
     pg.fill(255, 216, 24, opArc);
     pg.arc(sizePG / 2, sizePG / 2, rc, rc, -PI / 2, -PI / 2 + 2 * PI * slizeGold);;
     //createSilver slice
     pg.noStroke();
     pg.fill(161, 161, 161, opArc);
     pg.arc(sizePG / 2, sizePG / 2, rc, rc, -PI / 2 + 2 * PI * slizeGold, -PI / 2 + 2 * PI * slizeGold + 2 * PI * slizeSilver);
     //createBronze slice
     pg.noStroke();
     pg.fill(120, 85, 64, opArc);
     pg.arc(sizePG / 2, sizePG / 2, rc, rc, -PI / 2 + 2 * PI * slizeGold + 2 * PI * slizeSilver, 3 * PI / 2);
    } else if ((slizeBronze == 0) && (slizeSilver != 0) && (slizeGold != 0)) { //createGold
     pg.noStroke();
     pg.fill(255, 216, 24, opArc);
     pg.arc(sizePG / 2, sizePG / 2, rc, rc, -PI / 2, -PI / 2 + 2 * PI * slizeGold);
     //createSilver
     pg.noStroke();
     pg.fill(161, 161, 161, opArc);
     pg.arc(sizePG / 2, sizePG / 2, rc, rc, -PI / 2 + 2 * PI * slizeGold, 3 * PI / 2);
    } else if ((slizeBronze == 0) && (slizeSilver == 0) && (slizeGold != 0)) {
     //createGold
     pg.noStroke();
     pg.fill(255, 216, 24, opArc);
     pg.arc(sizePG / 2, sizePG / 2, rc, rc, -PI / 2, 3 * PI / 2);
    } else if ((slizeBronze != 0) && (slizeSilver == 0) && (slizeGold != 0)) {
     //createGold slice
     pg.noStroke();
     pg.fill(255, 216, 24, opArc);
     pg.arc(sizePG / 2, sizePG / 2, rc, rc, -PI / 2, -PI / 2 + 2 * PI * slizeGold);
     //createBronze
     pg.noStroke();
     pg.fill(120, 85, 64, opArc);
     pg.arc(sizePG / 2, sizePG / 2, rc, rc, -PI / 2 + 2 * PI * slizeGold, 3 * PI / 2);
    } else if ((slizeBronze != 0) && (slizeSilver != 0) && (slizeGold == 0)) {
     //createSilver slice
     pg.noStroke();
     pg.fill(161, 161, 161, opArc);
     pg.arc(sizePG / 2, sizePG / 2, rc, rc, -PI / 2, -PI / 2 + 2 * PI * slizeSilver);
     //createBronze
     pg.noStroke();
     pg.fill(120, 85, 64, opArc);
     pg.arc(sizePG / 2, sizePG / 2, rc, rc, -PI / 2 + 2 * PI * slizeSilver, 3 * PI / 2);
    } else if ((slizeBronze != 0) && (slizeSilver == 0) && (slizeGold == 0)) {
     //createBronze
     pg.noStroke();
     pg.fill(120, 85, 64, opArc);
     pg.arc(sizePG / 2, sizePG / 2, rc, rc, -PI / 2, 3 * PI / 2);
    } else {
     //createSilver
     pg.noStroke();
     pg.fill(161, 161, 161, opArc);
     pg.arc(sizePG / 2, sizePG / 2, rc, rc, -PI / 2, 3 * PI / 2);
    }*/

    /////!!!!!!!!!!!!! PUSH OUT TEXT OVER EUROPE !!!!!!! BOX COORDINATE IN SETUP        
    //Number of Atheletes
    pg.fill(8, 62, 120);
    pg.textFont(arialMT);
    // Size by attendants too
    //   float ts = sqrt(textSIZE*textSIZE*float(allData.get(j)[timeStep+7])/maxnAttendees)+minSIZE;


    //Size by medals
    //    float ts = 2*sizePG/3;
    pg.textSize(2 * rc / 3);
    //println("3 "+(2*rc/3));
    pg.textAlign(CENTER, CENTER);
    //pg.text(Countries.get(countryNames2.get(j)).olympics.get(yearString[dT]).athletes, sizePG / 2, sizePG / 2);
    //   pg.text(int(fractionWon*100), sizePG/2, sizePG/2); 






   } else if (float(Countries.get(countryNames2.get(j)).olympics.get(yearString[dT]).athletes) > 0) {

    colorScaleE colorRangeE = new colorScaleE(0, 53);
    
    PVector cRE = colorRangeE.getValue();
    pg.stroke(cRE.x, cRE.y, cRE.z);
    pg.fill(cRE.x, cRE.y, cRE.z);
    
    //pg.ellipse(sizePG / 2, sizePG / 2, rc, rc);

    //  ellipse(x[j],y[j],rc,rc);
    pg.stroke(69, 44, 0);
    pg.fill(196, 125, 0, 50);


    /////!!!!!!!!!!!!! PUSH OUT TEXT OVER EUROPE !!!!!!! BOX COORDINATE IN SETUP        
    //Number of Atheletes
    pg.fill(8, 62, 120);
    pg.textFont(arialMT);
    // Size by attendants too
    //   float ts = sqrt(textSIZE*textSIZE*float(allData.get(j)[timeStep+7])/maxnAttendees)+minSIZE;


    //Size by medals
    //    float ts = 2*sizePG/3;
    //   pg.text(int(fractionWon*100), sizePG/2, sizePG/2); 






   }

   //println("4 "+ts);
   pg.fill(255, 255, 255);
   pg.textAlign(CENTER, CENTER);
   pg.textSize(100);
   //pg.text(countryNames2.get(j), (sizePG / 2), (sizePG / 9));
   pg.textSize(ts);
   //pg.text(gdpRatMil/100, sizePG / 2, 4 * sizePG / 5);
   //println(" x " + sizePG / 2 + " y " + 4 * sizePG / 5);

   pg.endDraw();
   PG.add(pg);
   //    pg.clear();
   pg_index.append(j);


  }
 }

 ///DISPLAY QUADS + EXPAND 
 // This is still true, but we displace quads instead of text
 //    PImage medalYEAR = medal.get(dT);

 IntList indexpg = new IntList();
 for (int i = 0; i < PG.size(); i++) {

  //1. figure out size of quad
  int j = pg_index.get(i);
  //    if(float(allData.get(j)[timeStep+14])>0){
  int medalsPlace = 14;
  int numAtt = 7;
  //   float sizeQuad = sqrt(rb*rb*float(allData.get(j)[timeStep+medalsPlace])/maxnMedals)+minSIZE;
  float sizeQuad = sqrt(rb * rb * float(Countries.get(countryNames2.get(j)).olympics.get(yearString[dT]).athletes) / maxnAttendees) + minSIZE;
  
  float resQuad = 1;


  //2. figure out location of quad - displace accordingly
  PShape quadStrip;
  PShape medalStrip;
  PGraphics texQuad;


  if (j != 0 && (x.get(j) > xb1) && (x.get(j) < xb2) && (y.get(j) > yb2) && (y.get(j) < yb1)) {
   if (sizeQuad > dText) {
    //Displacement comes later
    cntDisp = cntDisp + 1;
    indexpg.append(i);
    indexDisp.append(j);

    //     texQuad = PG.get(i); 

    //   quadStrip = getQuadStrip(x[j],y[j]-sizeQuad, sizeQuad,sizeQuad, resQuad, texQuad);
    //   shape(quadStrip);

   } else {
    //3. create quad - calls texture
    
    texQuad = PG.get(i);
//    medalStrip = getQuadStrip(x.get(j), y.get(j), sizeQuad, sizeQuad, resQuad, medalYEAR);
    quadStrip = getQuadStrip(x.get(j), y.get(j), sizeQuad, sizeQuad, resQuad, texQuad); //4. display quad
    //        shape(medalStrip);
    shape(quadStrip);
   }
  } else {
   //3. create quad - calls texture
   texQuad = PG.get(i);
   //medalStrip = getQuadStrip(x.get(j), y.get(j), sizeQuad, sizeQuad, resQuad, medalYEAR);
   quadStrip = getQuadStrip(x.get(j), y.get(j), sizeQuad, sizeQuad, resQuad, texQuad); //4. display quad
   //4. display quad
   //      shape(medalStrip);
   shape(quadStrip);
  }
  //}
 }






 //Sort indexDisp by latitude/y values
 countryClass[] o = new countryClass[indexDisp.size()];
 //println(indexDisp.size());
 for (int j = 0; j < indexDisp.size(); j++) {
  //println(j);
  o[j] = new countryClass(indexpg.get(j), indexDisp.get(j), x.get(indexDisp.get(j)), y.get(indexDisp.get(j)));
  //println(j);
 }

 //sort array
 Arrays.sort(o);

 pushMatrix();
 //   translate(xb2,yb1);

 for (int j = 0; j < indexDisp.size(); j++) {
  float deltaAngle = (3 * PI / 4) / cntDisp;
  float xD = -(xb2 - xb1) * 1.5 * cos(PI / 8 - deltaAngle * j);
  float yD = -(xb2 - xb1) * 1.5 * sin(PI / 8 - deltaAngle * j);
  //println(countryNames2.get(j) + "  x " + xD + "  y" + yD);
  int index = o[j].ID;
  int index_PG = o[j].PGID;
  
  int medalsPlace = 14;
  int numAtt = 7;
  float supportPAT = float(Countries.get(countryNames2.get(index)).olympics.get(yearString[dT]).totMed) / float(Countries.get(countryNames2.get(index)).olympics.get(yearString[dT]).athletes);

  //   float sizeQuad = sqrt(rb*rb*float(allData.get(index)[timeStep+medalsPlace])/maxnMedals)+minSIZE;
  float sizeQuad = sqrt(rb * rb * float(Countries.get(countryNames2.get(index)).olympics.get(yearString[dT]).athletes) / maxnAttendees) + minSIZE;

  float resQuad = 1;
  PShape quadStrip2, medalStrip;
  PGraphics texQuad2;
  
  stroke(254, 160, 0);
  strokeWeight(2);
  float yPoint=yb1 - (yb1 - yb2) / 2 + yD-spacer;
  float xPoint=xb1 + (xb2 - xb1) / 2 + xD;
  if(yD<335){
  //println(countryNames2.get(index)+"  y "+yD+"  x"+xD+" xpnt "+(xb1 + (xb2 - xb1) / 2 + xD)+" Ypnt "+ (yb1 - (yb1 - yb2) / 2 + yD)+" xhome "+x.get(index)+" yhome "+ y.get(index));
  if(xPoint<1650){
  xPoint=1650;}
  //line(xPoint, yPoint, x.get(index), y.get(index));
  //println(countryNames2.get(index) + " x " + x.get(index));
  noFill();

  texQuad2 = PG.get(index_PG);

  //y[index]+yD-sizeQuad
  //      medalStrip = getQuadStrip(xb1 + (xb2-xb1)/2+xD,yb1 -(yb1-yb2)/2, sizeQuad,sizeQuad, resQuad, medalYEAR);
  quadStrip2 = getQuadStrip(xPoint, yPoint, sizeQuad, sizeQuad, resQuad, texQuad2);}
  
  else {
    yD=yD*1.5;
  if(xPoint<1700){
  xPoint=1700;}  
  //println(countryNames2.get(index)+"  y "+yD+"  x"+xD+" xpnt "+(xb1 + (xb2 - xb1) / 2 + xD)+" Ypnt "+ (yb1 - (yb1 - yb2) / 2 + yD)+" xhome "+x.get(index)+" yhome "+ y.get(index));
  //line(xPoint, yPoint, x.get(index), y.get(index));
  
  //println(countryNames2.get(index) + " x " + x.get(index));
  noFill();

  texQuad2 = PG.get(index_PG);

  //y[index]+yD-sizeQuad
  //      medalStrip = getQuadStrip(xb1 + (xb2-xb1)/2+xD,yb1 -(yb1-yb2)/2, sizeQuad,sizeQuad, resQuad, medalYEAR);
  quadStrip2 = getQuadStrip(xPoint,yPoint, sizeQuad, sizeQuad, resQuad, texQuad2);
spacer=(spacer-10)*1.1;}
  //    shape(medalStrip);
  shape(quadStrip2);


  //   fill(254,160,0,70);
  // bezier(xD+20, yD,xD-50, yD+20, x[index]-xb2, y[index]-yb1, x[index]-xb2-5, y[index]-yb1-5);


 }
 popMatrix();
//!!!!!!!!!!!!!! DISPLAY YEAR - HOST NAMES, IMAGES -- ANYTHING ABOUT THE HOST HERE 
 textFont(sans);
 textSize(.01);
 fill(255);
 textAlign(CENTER, CENTER);
// text(YEAR[dT], 200, 1200);

 textSize(int(width * .0125));
 textAlign(LEFT, TOP);
 //original no textAling and 100,620)
 // text(hostCity[dT]+", "+hostCountry[dT], 50, 620);
 PVector hostPlace = hostLoc.get(dT);
 int olyresizeX = int(width * .025);
 int olyresizeY = int(width * .0125);
 olympicsLogo.resize(olyresizeX, olyresizeY);
 image(olympicsLogo, hostPlace.x - olyresizeX / 2, hostPlace.y - olyresizeY / 2);

 rCharts = new ArrayList < PImage > ();
 //medal = new ArrayList<PImage>();
 //Load overlays - slowing down this even more!
 for (int j = 1; j < 10; j++) {
  String imageString = "radialChart0" + j + ".png";
  //String medalString = "medalsGlyphs/"+YEAR[j-1]+".png";
  PImage currentImage = loadImage(imageString);
  //PImage currentMedal = loadImage(medalString);

  rCharts.add(currentImage);
  //medal.add(currentMedal);

 }

 for (int j = 10; j < 29; j++) {
  String imageString = "radialChart" + j + ".png";
  //String medalString = "medalsGlyphs/"+YEAR[j-1]+".png";
  PImage currentImage = loadImage(imageString);
  //PImage currentMedal = loadImage(medalString);

  rCharts.add(currentImage);
  //medal.add(currentMedal);

 }

 //println(rCharts.size());
 PImage rCharttest = rCharts.get(3);
 //lOAD RADIAL CHARTS
 PImage radialChart = rCharts.get(dT);
 int scaledSize = 818;
 //println(scaledSize);
 radialChart.resize(scaledSize, scaledSize);
 tint(255);
// image(radialChart, -width * .08, height / 4);
 //image(radialChart, width * .92, height / 4);
 //overlay.resize(width, height);


 //  image(overlay, 0, 0);

 //Place Color Bar
 //colorbar.resize(int(width*.12), int(height*.12));
 //image(colorbar,width*.164,height*.628); 
 //image(colorbar,width*.660,height*.628);
 PShape colorBarQuad, colorBarQuad2;
 float sizecbX = width * .12;
 float sizecbY = height * .12;
 float resCB = 1;
 tint(255);
 //colorBarQuad = getQuadStrip(width*.164,height*.528, sizecbX, sizecbY, resCB, colorbar);
 //colorBarQuad2 = getQuadStrip(width*.660,height*.528, sizecbX, sizecbY, resCB, colorbar);
 //shape(colorBarQuad);,118);
 colorScale blueColorRange = new colorScale(maxnMedals, maxnMedals);
 PVector cR = blueColorRange.getValue();
 color blue = color(cR.x, cR.y, cR.z);
 colorScale yellowColorRange = new colorScale(float(1), maxnMedals);
 PVector ycR = yellowColorRange.getValue();
 color gold = color(ycR.x, ycR.y, ycR.z);
 color yellow = color(157, 128, 34);
 //gradientRect(width * .125, height * .528, sizecbX, sizecbY / 2, gold, blue);
 fill(255, 255, 255);
 textSize(12);
 //text("Percent of available medals won", width * .13, height * .528 + sizecbY / 3.25);
 //text("1%", width * .125, height * .528 + sizecbY / 1.5);
 //text(">75%", width * .125 + sizecbX, height * .528 + sizecbY / 1.5);

 //shape(colorBarQuad2);

 // image(barChart,0,height*.8);
 //Animation controls for now
 delay = delay + 1;
 if (delay > 0) {
  delay = 0;
  timeStep = timeStep + 1;
  dT = dT + 1;
  if (dT == 24) {
   print("stp");
  }
 }
 if (dT > 27) {
  timeStep = 0;
  dT = 0;
 }


 //To Save animation uncomment here
 saveFrame("summerOlympic-HRES-NI-###.png");
 //saveFrame("IQwall03.png");


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
test++;
       indCount.setOly(olympic);

       Countries.put(countName, indCount);
       countryNames2.add(countName);


      }

      // if the element starts with y(an individual years games) adds it to the hashmap of games with a key of the element name (eg "y2008")
      else if (xmlStreamReader.getLocalName().startsWith("y")) {
      float gdpRat=indivGames.gdp/indivGames.pop/indivGames.athletes;
      indivGames.gdpRat=gdpRat;
     // println(gdpRat);
      if(gdpRat <25){
      aa++;
      }
      else if (gdpRat < 50){
      bb++;}
      else if (gdpRat <1000){
      cc++;}
      else if (gdpRat < 5000){
      dd++;
      }
      else if (gdpRat < 10000){
      ee++;
      }
      else if (gdpRat>10000) {
      ff++;
      }
      if (gdpRat>maxGdpRatMil &gdpRat<1000000000){
      maxGdpRatMil=gdpRat;
    println(maxGdpRatMil);  
    }
      
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
        if (int(xmlStreamReader.getText()) > indivGames.athletes) {
         indivGames.setTot(Integer.toString(indivGames.athletes));
        } else {
         indivGames.setTot(xmlStreamReader.getText());
        }
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


void getLatLon() throws ParserConfigurationException, SAXException,
 IOException, XPathExpressionException {

  try { //File Path 

   String filePath = ("/Users/adamhoch/Documents/processing2/radialChart/data/countriesLat.xml");
   String elName = null;
   String country = null;

   //Read XML file. 
   Reader fileReader = new FileReader(filePath);
   //Get XMLInputFactory instance. 
   XMLInputFactory xmlInputFactory = XMLInputFactory.newInstance();
   //Create XMLStreamReader object. 
   XMLStreamReader xmlStreamReader = xmlInputFactory.createXMLStreamReader(fileReader); //Iterate through events.
   while (xmlStreamReader.hasNext()) {
    //Get integer value of current event. 
    int xmlEvent = xmlStreamReader.next();

    // If it's the start of the element gets the element name
    if (xmlEvent == XMLStreamConstants.START_ELEMENT) {

     elName = xmlStreamReader.getLocalName();

    }
    // If it's the end of the element resets the element name. Not sure why this is neccesary
    if (xmlEvent == XMLStreamConstants.END_ELEMENT) {

     elName = "";

    }

    // Gets the country iso2code, assigns it to a variable
    if (xmlEvent == XMLStreamConstants.CHARACTERS) {
     if (elName == "country") {
      country = xmlStreamReader.getText();



     }

     // if the current element is latitude 
     if (elName == "latitude") {

      // Goes through every country in the list of countries 
      for (Map.Entry < String, country > Countries: Countries.entrySet()) {
       // Matches the country entry to the latitude based on iso2 code
       if (country.toLowerCase().equals(Countries.getValue().countryAbbre.toLowerCase())) {

        Countries.getValue().setLat(float(xmlStreamReader.getText()));
        break;
       }
      }
     }

     // if the current element is longitude
     if (elName == "longitude") {
      // Goes through every country in the list of countries
      for (Map.Entry < String, country > Countries: Countries.entrySet()) {
       // Matches the country entry to the latitude based on iso2 code
       if (country.toLowerCase().equals(Countries.getValue().countryAbbre.toLowerCase())) {
        Countries.getValue().setLon(float(xmlStreamReader.getText()));
        break;
       }
      }
     }

    }
   }

  } catch (Exception e) {
   e.printStackTrace();
  }

 }


void latEquiv(String knownCountry, String unknownCountry) {
 Countries.get(unknownCountry).setLat(Countries.get(knownCountry).latitude);
 Countries.get(unknownCountry).setLon(Countries.get(knownCountry).longitude);
}

void continents() throws ParserConfigurationException, SAXException,
 IOException, XPathExpressionException {

  try { //File Path 

   String filePath = ("/Users/adamhoch/Documents/processing2/radialChart/data/continents.xml");
   String elName = null;
   String country = null;

   //Read XML file. 
   Reader fileReader = new FileReader(filePath);
   //Get XMLInputFactory instance. 
   XMLInputFactory xmlInputFactory = XMLInputFactory.newInstance();
   //Create XMLStreamReader object. 
   XMLStreamReader xmlStreamReader = xmlInputFactory.createXMLStreamReader(fileReader); //Iterate through events.
   while (xmlStreamReader.hasNext()) {
    //Get integer value of current event. 
    int xmlEvent = xmlStreamReader.next();

    if (xmlEvent == XMLStreamConstants.START_ELEMENT) {

     elName = xmlStreamReader.getLocalName();
     if (elName.equals("country")) {
      country = xmlStreamReader.getAttributeValue(null, "countryCode");

      for (Map.Entry < String, country > Countries: Countries.entrySet()) {
       if (country.toLowerCase().equals(Countries.getValue().countryAbbre.toLowerCase())) {
        Countries.getValue().setContinent(xmlStreamReader.getAttributeValue(null, "continent"));
       }

      }

     }

    }

 /*   latEquiv("Russia", "Soviet Union");
    latEquiv("Russia", "Unified Team");
    latEquiv("Slovakia", "Czechoslovakia");
    latEquiv("Malaysia", "Malaya");
    latEquiv("Germany", "West Germany");
    Countries.get("East Germany").setLon(9.9651000);
    Countries.get("East Germany").setLat(53.551);
    latEquiv("Bosnia and Herzegovina", "Yugoslavia");
    latEquiv("Australia", "Australasia");
    latEquiv("Serbia", "Serbia and Montenegro");
    latEquiv("Egypt", "United Arab Republic");
    latEquiv("Zimbabwe", "Rhodesia");
    latEquiv("Trinidad and Tobago", "West Indies Federation");
    Countries.get("South Vietnam").setLat(10.8231);
    Countries.get("South Vietnam").setLon(106.6297);
    Countries.get("Saar").setLat(49.396);
    Countries.get("Saar").setLon(7.02);
    Countries.get("Newfoundland").setLat(53.1355);
    Countries.get("Newfoundland").setLon(57.6604);
    Countries.get("Crete").setLat(35.2401);
    Countries.get("Crete").setLon(24.8093);
    Countries.get("Netherlands Antilles").setLat(12.22607);
    Countries.get("Netherlands Antilles").setLon(69.0600);
    Countries.get("South Yemen").setLat(12.8);
    Countries.get("South Yemen").setLon(45.033);
    Countries.get("North Yemen").setLat(15.354);
    Countries.get("North Yemen").setLon(44.206);
    Countries.get("North Borneo").setLat(5.9788);
    Countries.get("North Borneo").setLon(116.0753);
    Countries.get("Bohemia").setLat(40.769);
    Countries.get("Bohemia").setLon(-73.115);*/

   }



  } catch (Exception e) {
   e.printStackTrace();
  }

  for (Map.Entry < String, country > Countries: Countries.entrySet()) {

   // A list of countries that aren't in the list of continents. Mostly because they no longer exists
   if (Countries.getValue().continent == null) {
    if (Countries.getValue().countryName.equals("Soviet Union") | Countries.getValue().countryName.equals("Bohemia") | Countries.getValue().countryName.equals("Yugoslavia") | Countries.getValue().countryName.equals("Czechoslovakia") | Countries.getValue().countryName.equals("West Germany") | Countries.getValue().countryName.equals("East Germany") | Countries.getValue().countryName.equals("Saar") | Countries.getValue().countryName.equals("Crete") | Countries.getValue().countryName.equals("Serbia and Montenegro")) {
     Countries.getValue().setContinent("EU");
    } else if (Countries.getValue().countryName.equals("South Yemen") | Countries.getValue().countryName.equals("North Yemen") | Countries.getValue().countryName.equals("Malaya") | Countries.getValue().countryName.equals("South Vietnam") | Countries.getValue().countryName.equals("North Borneo") | Countries.getValue().countryName.equals("North Vietnam")) {
     Countries.getValue().setContinent("AS");
    } else if (Countries.getValue().countryName.equals("Netherlands Antilles") | Countries.getValue().countryName.equals("West Indies Federation") | Countries.getValue().countryName.equals("Newfoundland")) {
     Countries.getValue().setContinent("NA");
    } else if (Countries.getValue().countryName.equals("Rhodesia") | Countries.getValue().countryName.equals("United Arab Republic")) {
     Countries.getValue().setContinent("AF");
    } else if (Countries.getValue().countryName.equals("Australasia")) {
     Countries.getValue().setContinent("OC");
    } else if (Countries.getValue().countryName.equals("Unified Team") | Countries.getValue().countryName.equals("Individual Olympic Athletes")) {
     Countries.getValue().setContinent("Olympics");
    }

   }
  }

 }



public LinkedHashMap < String, country > sortByContinent(HashMap map) {
 Map < String, country > LinkedHashMap = new LinkedHashMap < String, country > (map);
 LinkedHashMap < String, country > sortedMap = new LinkedHashMap < String, country > ();
 LinkedHashMap asia = new LinkedHashMap < String, country > ();
 LinkedHashMap africa = new LinkedHashMap < String, country > ();
 LinkedHashMap northAmerica = new LinkedHashMap < String, country > ();
 LinkedHashMap southAmerica = new LinkedHashMap < String, country > ();
 LinkedHashMap europe = new LinkedHashMap < String, country > ();
 LinkedHashMap oceania = new LinkedHashMap < String, country > ();
 LinkedHashMap olympic = new LinkedHashMap < String, country > ();
 for (Map.Entry < String, country > entry: LinkedHashMap.entrySet()) {
  if (entry.getValue().latitude == 0.0) {

  }

  if (entry.getValue().continent.equals("AS")) {
   asia.put(entry.getKey(), entry.getValue());


  } else if (entry.getValue().continent.equals("AF")) {
   africa.put(entry.getKey(), entry.getValue());

  } else if (entry.getValue().continent.equals("NA")) {
   northAmerica.put(entry.getKey(), entry.getValue());


  } else if (entry.getValue().continent.equals("SA")) {
   southAmerica.put(entry.getKey(), entry.getValue());


  } else if (entry.getValue().continent.equals("EU")) {
   europe.put(entry.getKey(), entry.getValue());


  } else if (entry.getValue().continent.equals("OC")) {
   oceania.put(entry.getKey(), entry.getValue());


  } else if (entry.getValue().continent.equals("Olympics")) {
   olympic.put(entry.getKey(), entry.getValue());


  }

 }
 sortedMap.putAll(africa);
 sortedMap.putAll(europe);
 sortedMap.putAll(asia);
 sortedMap.putAll(oceania);
 sortedMap.putAll(southAmerica);
 sortedMap.putAll(northAmerica);
 sortedMap.putAll(olympic);
 for (Map.Entry < String, country > entry: sortedMap.entrySet()) {
  //Creates the list of country names in the new order
  countryNames2.add(entry.getKey());
  print(entry.getKey() + ",");
 }


 return sortedMap;

}

void gradientRect(float x, float y, float w, float h, color c1, color c2) {
 beginShape();
 fill(c1);
 vertex(x, y);
 vertex(x, y + h);
 fill(c2);
 vertex(x + w, y + h);
 vertex(x + w, y);
 noStroke();
 endShape();
}