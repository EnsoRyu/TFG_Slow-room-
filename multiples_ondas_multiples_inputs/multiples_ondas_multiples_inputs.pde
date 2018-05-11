ondas a;
ondas b;
ondas c;
int[] x = new int[2];
int[] y = new int[2];
PFont font;

void setup() {
  size(1000, 500);
  blendMode(MULTIPLY);
  a = new ondas(180);
  b = new ondas(10);
  c = new ondas(50);
  x[1]=500;
  y[1]=500;
  font = createFont("Arial Bold",48);
  
}

void draw() {
  x[0] = mouseX;
  y[0] = mouseY;
  background(255);
  a.calcWave(300, 5000);
  a.drawGradient(600, 100, 100, 150, x[0], y[0],70);
  a.drawShape();
  a.maskondas();
  b.calcWave(100, 1000);
  b.drawGradient(600, 100, 100, 400, x[1], y[1],70);
  b.drawShape();
  b.maskondas();
  c.calcWave(100, 1000);
  c.drawGradient(600, 100, 100, 400, x[0], y[0],70);
  c.drawShape();
  c.maskondas();
  fill(0);
  text(frameRate,20,20);


}

void keyPressed()
  {
      if (key == 'd')
      {
        x[1] = x[1] + 20;
      }
      if  (key == 'a')
      {
        x[1] = x[1] - 20;
      }
      if (key == 'w')
      {
        y[1] = y[1] -20;
      }
      if (key == 's')
      {
        y[1] = y[1] + 20;
      }
    }