static final int WIDTH = 700;
static final int HEIGHT = 400;

float sizeX = 3.5;
float sizeY = 2.;
float zoom = 0.0;
float centerX = -0.75;
float centerY = 0;
int colorVariation;

void setup() {
  size(WIDTH, HEIGHT);
  frame.setTitle("Mandelbrot");
  colorMode(HSB, 100, 100, 100);
  // Makes the colors different each time.
  colorVariation = (int) random(100);

  background(0, 0, 100);
  drawMandelbrot(centerX, centerY);
}

void draw() {
  // Zooms in.
  if (mousePressed && mouseButton == LEFT) {
    centerX = map(mouseX, 0, WIDTH - 1, centerX - sizeX / 2, centerX + sizeX / 2);
    centerY = map(mouseY, 0, HEIGHT - 1, centerY - sizeY / 2, centerY + sizeY / 2);
    zoom += .25;

    // Redraw zoomed in picture.
    background(0, 0, 100);
    drawMandelbrot(centerX, centerY);
  }
}

void drawMandelbrot(float centerX, float centerY) {
  // Calculates zoomed coordinates / sizes.
  sizeX = (float) Math.pow(2, -zoom) * sizeX;
  float minX = (float) centerX - (sizeX / 2);
  float maxX = (float) centerX + (sizeX / 2);

  sizeY = (float) Math.pow(2, -zoom) * sizeY;
  float minY = centerY - (sizeY / 2);
  float maxY = centerY + (sizeY / 2);

  // Adapted from http://math.stackexchange.com/a/30560
  int maxIteration = (int) (Math.sqrt(Math.abs(2 * Math.sqrt(Math.abs(1 - Math.sqrt(5 * zoom))))) * 66.5);
  
  // Escape time algorithm.
  for (int point_x = 0; point_x < WIDTH; point_x++) {
    for (int point_y = 0; point_y < HEIGHT; point_y++) {

      float x0 = map(point_x, 0, WIDTH - 1, minX, maxX);
      float y0 = map(point_y, 0, HEIGHT - 1, minY, maxY);

      float x = 0;
      float y = 0;

      int iteration = 0;

      while (x * x + y * y < 2 * 2 && iteration < maxIteration) {
        float xtemp = x*x - y*y + x0;
        y = 2*x*y + y0;

        x = xtemp;

        iteration++;
      }
      
      // Pixel coloring.
      if (iteration < maxIteration)
        stroke((iteration + colorVariation) % 100, 100, 100);
      else
        stroke(0, 100, 0);
      point(point_x, point_y);
    }
  }
}

