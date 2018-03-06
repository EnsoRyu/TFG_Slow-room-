/*
Thomas Sanchez Lengeling.
 http://codigogenerativo.com/
 
 KinectPV2, Kinect for Windows v2 library for processing
 
 3D Skeleton.
 Some features a not implemented, such as orientation
 */

import KinectPV2.KJoint;
import KinectPV2.*;

KinectPV2 kinect;


//AÑADIDO*****************************************************
float xjoint, yjoint, zjoint;
float xMapped, yMapped, zMapped;
float xobject = 0;
float yobject = 0;
float zobject = 0;

float x1, x2, x3, x4, y1, y2, y3, y4;
  
int ncuerpo;

int dtxt = 60;

float x5 = 0.257;
float y5 = -0.156;
float z5 = 1.27;
float r= 0.2;
float Dxy;
float Dyz;
boolean dentro = false;
boolean activar = false;

color col2 = color(255,0,0);
color fixcolor;

void setup() {
  size(1920, 1080, P3D);

  kinect = new KinectPV2(this);

  kinect.enableColorImg(true);

  //enable 3d  with (x,y,z) position
  kinect.enableSkeleton3DMap(true);

  kinect.init();
  textSize(60);
  fill(255,0,0);
}

void draw() {
  background(0);

  image(kinect.getColorImage(), 0, 0, width, height);

  ArrayList<KSkeleton> skeletonArray =  kinect.getSkeleton3d();

  //individual JOINTS
  for (int i = 0; i < skeletonArray.size(); i++) {
    KSkeleton skeleton = (KSkeleton) skeletonArray.get(i);
    if (skeleton.isTracked()) {
      KJoint[] joints = skeleton.getJoints();

      //cada cuerpo de skeleton tiene un color asignado
      color col  = skeleton.getIndexColor();
      fill(col);
      stroke(col);
      drawBody(joints);
      //AÑADIDO LINEA 141
      posicion(joints);
      //AÑADIDO LINEA 147
      drawHand();
      //AÑADIDO
      locbox(joints);
      //AÑADIDO
      rectbody();
      //draw different color for each hand state
      drawHandState(joints[KinectPV2.JointType_HandRight]);
      drawHandState(joints[KinectPV2.JointType_HandLeft]);
      //aparece welcome en pantalla cuando collision()
      //welcome();
    }
  }
  //TEXTO informativo
  fill(255, 0, 0);
  text(frameRate, 50, dtxt);
  text("número de personas: " + skeletonArray.size(), 50, dtxt*2);
  text (xjoint+" X  "+ yjoint+" Y  " + zjoint +" Z  ", 50, dtxt*3);
  text (xMapped+" X  "+ yMapped+" Y  " + zMapped +" Z  ", 50, dtxt*4);
  text ("distancia XY: "+Dxy, 50, dtxt*5);
  text ("distancia YZ: "+Dyz, 50, dtxt*6);
  //int dentroint = int(dentro);
  //text (dentroint, 50, dtxt*6);
  
  //colision bola
  //pushStyle();
  collision();
  //ellipse(x5,y5,r,r);
  //popStyle();
}


void drawBody(KJoint[] joints) {
  drawBone(joints, KinectPV2.JointType_Head, KinectPV2.JointType_Neck);
  drawBone(joints, KinectPV2.JointType_Neck, KinectPV2.JointType_SpineShoulder);
  drawBone(joints, KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_SpineMid);

  drawBone(joints, KinectPV2.JointType_SpineMid, KinectPV2.JointType_SpineBase);
  drawBone(joints, KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_ShoulderRight);
  drawBone(joints, KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_ShoulderLeft);
  drawBone(joints, KinectPV2.JointType_SpineBase, KinectPV2.JointType_HipRight);
  drawBone(joints, KinectPV2.JointType_SpineBase, KinectPV2.JointType_HipLeft);

  // Right Arm    
  drawBone(joints, KinectPV2.JointType_ShoulderRight, KinectPV2.JointType_ElbowRight);
  drawBone(joints, KinectPV2.JointType_ElbowRight, KinectPV2.JointType_WristRight);
  drawBone(joints, KinectPV2.JointType_WristRight, KinectPV2.JointType_HandRight);
  drawBone(joints, KinectPV2.JointType_HandRight, KinectPV2.JointType_HandTipRight);
  drawBone(joints, KinectPV2.JointType_WristRight, KinectPV2.JointType_ThumbRight);

  // Left Arm
  drawBone(joints, KinectPV2.JointType_ShoulderLeft, KinectPV2.JointType_ElbowLeft);
  drawBone(joints, KinectPV2.JointType_ElbowLeft, KinectPV2.JointType_WristLeft);
  drawBone(joints, KinectPV2.JointType_WristLeft, KinectPV2.JointType_HandLeft);
  drawBone(joints, KinectPV2.JointType_HandLeft, KinectPV2.JointType_HandTipLeft);
  drawBone(joints, KinectPV2.JointType_WristLeft, KinectPV2.JointType_ThumbLeft);

  // Right Leg
  drawBone(joints, KinectPV2.JointType_HipRight, KinectPV2.JointType_KneeRight);
  drawBone(joints, KinectPV2.JointType_KneeRight, KinectPV2.JointType_AnkleRight);
  drawBone(joints, KinectPV2.JointType_AnkleRight, KinectPV2.JointType_FootRight);

  // Left Leg
  drawBone(joints, KinectPV2.JointType_HipLeft, KinectPV2.JointType_KneeLeft);
  drawBone(joints, KinectPV2.JointType_KneeLeft, KinectPV2.JointType_AnkleLeft);
  drawBone(joints, KinectPV2.JointType_AnkleLeft, KinectPV2.JointType_FootLeft);

  drawJoint(joints, KinectPV2.JointType_HandTipLeft);
  drawJoint(joints, KinectPV2.JointType_HandTipRight);
  drawJoint(joints, KinectPV2.JointType_FootLeft);
  drawJoint(joints, KinectPV2.JointType_FootRight);

  drawJoint(joints, KinectPV2.JointType_ThumbLeft);
  drawJoint(joints, KinectPV2.JointType_ThumbRight);

  drawJoint(joints, KinectPV2.JointType_Head);
}

void drawJoint(KJoint[] joints, int jointType) {
  /*
  pushMatrix();
  translate(joints[jointType].getX(), joints[jointType].getY(), joints[jointType].getZ());
  ellipse(0, 0, 25, 25);
  popMatrix();
  */
}

//prueba de localización*******************************************************
void posicion(KJoint[] joints) {
  ncuerpo = KinectPV2.JointType_HandLeft;
  xjoint = joints [ncuerpo].getX();
  yjoint = joints [ncuerpo].getY();
  zjoint = joints [ncuerpo].getZ();
  println(xjoint, yjoint, zjoint);
  
  //mapear valores x, y ,z
  /*
  xMapped = map(joints [ncuerpo].getX(), -1.30, 1.2, 0, width);
  yMapped = map(joints [ncuerpo].getY(), 0.6, -0.50, 0, height);
  zMapped = map(joints [ncuerpo].getZ(), 3.5, 0.3, 0, 600);
  */
  //-1.1 1.5
  xMapped = map(joints [ncuerpo].getX(), -1.2, 1.5, 0, width);
  yMapped = map(joints [ncuerpo].getY(), 0.7, -0.80, 0, height);
  zMapped = map(joints [ncuerpo].getZ(), 3, 0.3, -300, 300);
  zMapped = 0;  
}
//localización de BOXCOLLIDER***************************************************
void locbox(KJoint[] joints) {
x1 = map(joints [KinectPV2.JointType_ShoulderRight].getX(), -1.2, 1.5, 0, width);
x2 = map(joints [KinectPV2.JointType_ShoulderLeft].getX(), -1.2, 1.5, 0, width);
x3 = map(joints [KinectPV2.JointType_HipLeft].getX(), -1.2, 1.5, 0, width);
x4 = map(joints [KinectPV2.JointType_HipRight].getX(), -1.2, 1.5, 0, width);
y1 = map(joints [KinectPV2.JointType_ShoulderRight].getY(), 0.6, -0.50, 0, height);
y2 = map(joints [KinectPV2.JointType_ShoulderLeft].getY(), 0.6, -0.50, 0, height);
y3 = map(joints [KinectPV2.JointType_HipLeft].getY(), 0.6, -0.50, 0, height);
y4 = map(joints [KinectPV2.JointType_HipRight].getY(), 0.6, -0.50, 0, height);
}
//BOXCOLLIDER*******************************************************************
void rectbody() {
beginShape();
vertex(x1,y1);
vertex(x2,y2);
vertex(x3,y3);
vertex(x4,y4);
endShape();
}

//dibujar mano******************************************************************
void drawHand(){
  pushMatrix();
  translate(xMapped, yMapped, zMapped);
  ellipse(0,0, 25, 25);
  popMatrix();
}

//collision3D********************************************************************************
void changeColor(){
col2= color (random(255), random(255), random(255));
fill (col2);
}

void collision() {
  Dxy = dist(xjoint, yjoint, x5, y5);
  Dyz = dist(yjoint, zjoint, y5, z5);
if (Dxy < r) {
  if (Dyz < r) {
    pushStyle();
    textSize(100);
    text("DON'T TOUCHA MY BACK", width/4, height/2);
    popStyle();
    //dentro = true;
    //activar = true;
    //changeColor();
  }
}
}
/*
else {
  dentro = false;
  }
}

void welcome() {
if (activar){
pushStyle();
textSize(100);
text("WELCOME", width/2, height/2);
popStyle();
}
}
*/

void drawBone(KJoint[] joints, int jointType1, int jointType2) {
  /*
  pushMatrix();
  translate(joints[jointType1].getX(), joints[jointType1].getY(), joints[jointType1].getZ());
  ellipse(0, 0, 25, 25);
  popMatrix();
  */
  line(joints[jointType1].getX(), joints[jointType1].getY(), 0, joints[jointType2].getX(), joints[jointType2].getY(), 0);
}

void drawHandState(KJoint joint) {
  /*
  noStroke();
  handState(joint.getState());
  pushMatrix();
  translate(joint.getX(), joint.getY(), joint.getZ());
  ellipse(0, 0, 0, 70, 70);
  popMatrix();
  */
}

void handState(int handState) {
  switch(handState) {
  case KinectPV2.HandState_Open:
    stroke(0, 255, 0);
    break;
  case KinectPV2.HandState_Closed:
    stroke(255, 0, 0);
    break;
  case KinectPV2.HandState_Lasso:
    stroke(0, 0, 255);
    break;
  case KinectPV2.HandState_NotTracked:
    stroke(100, 100, 100);
    break;
  }
}