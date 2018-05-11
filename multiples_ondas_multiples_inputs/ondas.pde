class ondas {

PImage gradient;
PGraphics shape;
//Parametros de onda
int xspacing = 10;   // separación entre los puntos
int w;              // Ancho de la onda
float theta; // Ángulo de la onda inicial
float dx;  // Value for incrementing X, a function of period and xspacing
float[] yvalues;  // Using an array to store height values for the wave


ondas(float a) {
  gradient = createImage(width, height, RGB);
  shape = createGraphics(width, height, JAVA2D);
  theta = a;

}

 void calcWave(int amplitude, int period) {
  // modificación de posición del punto para crear movimiento
  theta += 0.02;
  w = width+16;
  dx = (TWO_PI / period) * xspacing;
  yvalues = new float[w/xspacing];
  // For every x value, calculate a y value with sine function
  float x = theta;
  for (int i = 0; i < yvalues.length; i++) {
    yvalues[i] = sin(x)*amplitude;
    x+=dx;
  }
}

   
void drawGradient(int H, int S, int B, int Hstart, int positionX, int positionY, int dark ) {
  colorMode(HSB, H, S, B);
  gradient.loadPixels();
  /*imagen de gradiente creada desde positionX-Y, cuando se le asigna un input como mouseX, 
  la posición de degradado se puede controlar. */
  for (int y=0; y<gradient.height; y++) {
    for (int x=0; x<gradient.width; x++) {
      int index = x + y * gradient.width;
      float distance = dist(x, y, positionX, positionY);
   // 8+Hstart es un modificación cutre para empezar el degradado en un color y agrandarlo
  // "/8" agranda el degradado y +Hstart empieza el degradado en ese número.
      gradient.pixels[index] = color(distance/8+Hstart,dark,1000);
    }
  }
  gradient.updatePixels();
  colorMode(RGB, 255, 255, 255);
}

void drawShape() { 
  shape.beginDraw();
  shape.background(0);
  shape.noStroke();
  shape.fill(255);
  shape.beginShape();
  // A simple way to draw the wave with an ellipse at each location
  for (int k = 0; k < yvalues.length; k++) {
    shape.vertex(k*xspacing, height/2+yvalues[k]);
  }
  shape.vertex(width, height);
  shape.vertex(0, height);
  shape.endShape();
  shape.endDraw();
}

void maskondas() {
  //la imagen gradiente es enmascarada por el shape.
  gradient.mask(shape);
  image(gradient, 0, 0);
}

}