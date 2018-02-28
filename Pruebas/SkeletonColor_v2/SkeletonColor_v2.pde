/*
Thomas Sanchez Lengeling.
 http://codigogenerativo.com/
 KinectPV2, Kinect for Windows v2 library for processing
 Skeleton color map example.
 Skeleton (x,y) positions are mapped to match the color Frame
 */
 // Skeleton (x,y,z) es Skeleton3D, aunque está el ejercicio a medias

//importamos libreria de huesos Kjoint
import KinectPV2.KJoint;
//importamos el resto de librerias mediante "*"
import KinectPV2.*;

//invocamos la clase KinectPV2
KinectPV2 kinect;


void setup() {
  /*
  P3D utiliza OpenGL, en vez de usar la CPU trabaja con el gráfica. 
  P3D se utiliza para gráficos 3D, mientras P2D es para gráficos 2D.
  */
  size(1920, 1080, P3D);
  //crea un objeto. "this" se utiliza para hacer referencia al mismo objeto.
  kinect = new KinectPV2(this);
  
  //habilita ("true") las funciones de esqueleto color y el vídeo.  
  kinect.enableSkeletonColorMap(true);
  kinect.enableColorImg(true);

  //inicia el hardware con las funciones habilitadas anteriormente. 
  kinect.init();
}

//CADA FRAME DIBUJA DE NUEVO EL "VÍDEO", LAS ARTICULACIONES Y EL ESTADO DE LAS MANOS.
void draw() {
  background(0);
  
  //objeto imagen con el video de kinect, el cual ocupa todo el ancho y alto.
  image(kinect.getColorImage(), 0, 0, width, height);

  //Se crea una arraylist de KSkeleton llamada skeletonArray que pertenece a .getskeletoncolormap(); 
  ArrayList<KSkeleton> skeletonArray =  kinect.getSkeletonColorMap();

  //individual JOINTS
  /*
  Por cada bloque de array skeleton. Se le aplicará... 
  SkeletonArray son las cantidad de personas que hay en escena.
  */
  for (int i = 0; i < skeletonArray.size(); i++) {
    // El objeto skeleton de la array KSkeleton será igual a la conseguida skeletonArray.get(i)
    KSkeleton skeleton = (KSkeleton) skeletonArray.get(i);
    //si skeleton es traqueado por la kinect, entonces...
    if (skeleton.isTracked()) {
      //La array joints consigue los joints de la objeto skeleton.
      KJoint[] joints = skeleton.getJoints();

      //cada cuerpo de skeleton tiene un color asignado
      color col  = skeleton.getIndexColor();
      fill(col);
      stroke(col);
      drawBody(joints);

      //draw different color for each hand state
      drawHandState(joints[KinectPV2.JointType_HandRight]);
      drawHandState(joints[KinectPV2.JointType_HandLeft]);
    }
  }

  fill(255, 0, 0);
  text(frameRate, 50, 50);
  text(skeletonArray.size(), 50, 70);
}

//DRAW BODY es la función que dibuja artículaciones y huesos.
//KJoint es una array con todas las articulaciones de un skeleton
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

//draw joint
void drawJoint(KJoint[] joints, int jointType) {
  pushMatrix();
  translate(joints[jointType].getX(), joints[jointType].getY(), joints[jointType].getZ());
  ellipse(0, 0, 25, 25);
  popMatrix();
}

//draw bone
void drawBone(KJoint[] joints, int jointType1, int jointType2) {
  pushMatrix();
  translate(joints[jointType1].getX(), joints[jointType1].getY(), joints[jointType1].getZ());
  ellipse(0, 0, 25, 25);
  popMatrix();
  line(joints[jointType1].getX(), joints[jointType1].getY(), joints[jointType1].getZ(), joints[jointType2].getX(), joints[jointType2].getY(), joints[jointType2].getZ());
}

//draw hand state
void drawHandState(KJoint joint) {
  noStroke();
  handState(joint.getState());
  pushMatrix();
  translate(joint.getX(), joint.getY(), joint.getZ());
  ellipse(0, 0, 70, 70);
  popMatrix();
}

/*
Different hand state
 KinectPV2.HandState_Open
 KinectPV2.HandState_Closed
 KinectPV2.HandState_Lasso
 KinectPV2.HandState_NotTracked
 */
void handState(int handState) {
  switch(handState) {
  case KinectPV2.HandState_Open:
    fill(0, 255, 0);
    break;
  case KinectPV2.HandState_Closed:
    fill(255, 0, 0);
    break;
  case KinectPV2.HandState_Lasso:
    fill(0, 0, 255);
    break;
  case KinectPV2.HandState_NotTracked:
    fill(255, 255, 255);
    break;
  }
}