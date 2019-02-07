int kreiselCount = 7;
int radius = 40;
float stepDivider = 100;

float[] horizontalProgress;
color[] colorList;
float[] verticalProgress;
PShape[] shapeCache;

void setup() {
  // setup Display
  frameRate(120);
  size(800, 800, P2D);
  background(22, 22, 24);

  setupVariables();
}

void setupVariables() {
  println("Setup variables...");
  colorList = new color[kreiselCount];
  
  horizontalProgress = new float[kreiselCount];
  verticalProgress = new float[kreiselCount];
  shapeCache = new PShape[kreiselCount * kreiselCount];
  
  setZero();
  resetShapeCache();
  
  fillColorList();
}

void setZero() {
  println("Zeroing arrays...");
  // reset horizontal outer circles
  for (int i = 0; i < horizontalProgress.length; i++) {
    horizontalProgress[i] = 0.0f;
  }
  // reset vertical outer circles
  for (int i = 0; i < verticalProgress.length; i++) {
    verticalProgress[i] = 0.0f;
  }
}

void resetShapeCache() {
  for (int i = 0; i < shapeCache.length; i++) {
    shapeCache[i] = createShape();
  }
}

// MUST BE EDITED WHEN INCREASING CIRCLE COUNT
void fillColorList() {
  colorList[0] = color(192, 95, 104);
  colorList[1] = color(211, 156, 122);
  colorList[2] = color(241, 245, 168);
  colorList[3] = color(140, 210, 147);
  colorList[4] = color(137, 208, 227);
  colorList[5] = color(212, 147, 180);
  colorList[6] = color(186, 160, 216);
}

void setupStrokeOuterCircle(int index) {
  println("Setup stroke for outer circles...");
  stroke(colorList[index]);
  strokeWeight(1);
  noFill();
  //fill(255);
}

void setupStrokeInnerCircle(int index1, int index2) {
  println("Setup stroke for inner circles...");
  float red = (red(colorList[index1]) + red(colorList[index2])) / 2f;
  float green = (green(colorList[index1]) + green(colorList[index2])) / 2f;
  float blue = (blue(colorList[index1]) + blue(colorList[index2])) / 2f;
  stroke(color(red, green, blue));
  strokeWeight(1);
  noFill();
  //fill(255);
}

void setupStrokeOuterPoint() {
  println("Setup stroke for outer circles...");
  stroke(255, 255, 255);
  strokeWeight(10);
  noFill();
  //fill(255);
}

void setupStrokeInnerPoint() {
  println("Setup stroke for inner circles...");
  stroke(255, 255, 255);
  strokeWeight(3);
  noFill();
  //fill(255);
}

void mouseClicked() {
  setZero();
}

void draw() {
  println("Drawing...");
  //background(22, 22, 24);
  drawOuterCircles();
  drawInnerCircles();
  makeProgress();
}

void drawOuterCircles() {
  println("Drawing outer circles...");
  drawHorizontalOuterCircles();
  drawVerticalOuterCircles();
}

void drawHorizontalOuterCircles() {
  println("Drawing horizontal outer circles...");
  pushMatrix();
  translate(radius, radius);
  for (int i = 0; i < horizontalProgress.length; i++) {
    translate(100, 0);
    drawRegularCircle(i);
    drawRegularProgressPoint(horizontalProgress[i]);
  }
  popMatrix();
}

void drawVerticalOuterCircles() {
  println("Drawing vertical outer circles...");
  pushMatrix();
  translate(radius, radius);
  for (int i = 0; i < verticalProgress.length; i++) {
    translate(0, 100);
    drawRegularCircle(i);
    drawRegularProgressPoint(verticalProgress[i]);
  }
  popMatrix();
}

void drawRegularCircle(int index) {
  setupStrokeOuterCircle(index);
  ellipse(10, 10, radius*2, radius*2);
}

void drawRegularProgressPoint(float progress) {
  setupStrokeOuterPoint();
  float x = radius * cos(progress);
  float y = radius * sin(progress);
  point(x+10, y+10);
}

void drawInnerCircles() {
  println("Drawing inner circles...");
  pushMatrix();
  // go through all horizontal circles
  for (int i = 0; i < horizontalProgress.length; i++) {
    // go through all vertical circles
    for (int j = 0; j < verticalProgress.length; j++) {
      shapeCache[getShapeIndex(i, j)].vertex(radius * cos(verticalProgress[j]), radius * sin(horizontalProgress[i]));
      drawInnerCircleShapeWithProgressPoint(i, j);
    }
  }
  popMatrix();
}

void drawInnerCircleShapeWithProgressPoint(int horizontal, int vertical) {
  println("Drawing inner circle ("+horizontal+", "+vertical+")...");
  pushMatrix();
  float x = horizontalProgress[horizontal];
  float y = verticalProgress[vertical];
  translate((horizontal+1)*100 + radius, (vertical+1)*100 + radius);
  drawInnerCircleShape(horizontal, vertical);
  drawInnerCirclePoint(x, y);
  popMatrix();
}

void drawInnerCircleShape(int horizontal, int vertical) {
  setupStrokeInnerCircle(horizontal, vertical);
  shape(shapeCache[getShapeIndex(horizontal, vertical)]);
}

void drawInnerCirclePoint(float progressHorizontal, float progressVertical) {
  //setupStrokeInnerPoint();
  float x = radius * cos(progressHorizontal);
  float y = radius * sin(progressVertical);
  point(x+10, y+10);
}

void makeProgress() {
  print("Making progress...");
  // moving horizontal outer circles progress
  for (int i = 0; i < horizontalProgress.length; i++) {
    horizontalProgress[i] = (horizontalProgress[i] + ((float)(i+1) / stepDivider)) % 360;
  }
  // moving vertical outer circles progress
  for (int i = 0; i < verticalProgress.length; i++) {
    verticalProgress[i] = (verticalProgress[i] + ((float)(i+1) / stepDivider)) % 360;
  }
}

int getShapeIndex(int horizontal, int vertical) {
  return horizontal + vertical * kreiselCount;
}
