/*(public PShape getQuadStrip(float px_, float py_,float sizex_, float sizey_, float resolution, PImage image){

//This function returns a quad strip by giving the size of the 
//quad (assuming user wants a square) and the resolution of the quad
//add an image for texturing
  float px = px_;
  float py = py_;
  float sizeX = sizex_;     //width of the quadstrip
  float sizeY = sizey_;    //height of quadstrip
  float res = resolution; //resolution of the quad strip (how many quads)
  PShape quadStrip;
  PImage tex = image; //Texture
  
  quadStrip = createShape();
  textureWrap(REPEAT);
  quadStrip.beginShape(QUAD_STRIP);
  quadStrip.textureMode(NORMAL);
  quadStrip.texture(tex);
  quadStrip.noStroke();
  quadStrip.fill(0, 0, 255);
    for(float j = 0; j <= sizeY; j = j+(sizeY/res)){
      //changed xvertex from - px, px + size to just size 
      println(j/sizeY);
      float yvertex = -(sizeY/2)+py+j;
      float xvertex = C2SOS(sizeX, yvertex,sizeX);
      quadStrip.vertex(px -xvertex/2, yvertex, 0, j/sizeY-1);
      quadStrip.vertex(px +xvertex/2, yvertex, 3, j/sizeY);
    }
    quadStrip.endShape(CLOSE);
  
  return quadStrip;
}*/
public PShape getQuadStrip(float px_, float py_,float sizex_, float sizey_, float resolution, PImage image){

//This function returns a quad strip by giving the size of the 
//quad (assuming user wants a square) and the resolution of the quad
//add an image for texturing
  float px = px_;
  float py = py_;
  float sizeX = sizex_;     //width of the quadstrip
  float sizeY = sizey_;    //height of quadstrip
  float res = resolution; //resolution of the quad strip (how many quads)
  PShape quadStrip;
  PImage tex = image; //Texture
  
  quadStrip = createShape();
  quadStrip.beginShape(QUAD_STRIP);
  quadStrip.textureMode(NORMAL);
  quadStrip.texture(tex);
  quadStrip.noStroke();
  quadStrip.fill(0, 0, 255);
    for(float j = 0; j <= sizeY; j = j+(sizeY/res)){
      //changed xvertex from - px, px + size to just size 
      float yvertex = -(sizeY/2)+py+j;
      float xvertex = C2SOS(sizeX, yvertex,sizeX);
      quadStrip.vertex(px -xvertex/2, yvertex, 0, j/sizeY);
      quadStrip.vertex(px +xvertex/2, yvertex, 1, j/sizeY);
    }
    quadStrip.endShape(CLOSE);
  
  return quadStrip;
}