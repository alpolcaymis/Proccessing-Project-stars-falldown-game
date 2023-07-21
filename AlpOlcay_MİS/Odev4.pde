import java.util.ArrayList;

int numShapes = 6;
ArrayList<Shape> shapes = new ArrayList<Shape>();
int screenSizeX, screenSizeY;
boolean gameOver = false;

void setup() {
  //fullScreen();
  size(800, 600);
  background(0);
  screenSizeX = width;
  screenSizeY = height;
  createShapes();
}

void draw() {
  if (!gameOver) {
    background(0);
    drawShapes();
    updateShapes();
    checkCollision();
  } else {
    textAlign(CENTER, CENTER);
    textSize(40);
    fill(255);
    text("NO MORE FLAKES TO SHOOT", width / 2, height / 2);
  }
}

void createShapes() {
  for (int i = 0; i < numShapes; i++) {
    float x = random(width);
    float y = random(height);
    float speed = random(3, 15);
    color c = color(random(255), random(255), random(255));
    float size = random(3, 10);
    int rotationDir = (int)(random(-2, 2));
    shapes.add(new Shape(x, y, speed, c, size, rotationDir));
  }
}

void drawShapes() {
  for (Shape shape : shapes) {
    shape.display();
  }
}

void updateShapes() {
  for (Shape shape : shapes) {
    shape.update();
    if (shape.isOffScreen()) {
      shape.reset();
    }
  }
}

void checkCollision() {
  for (int i = shapes.size() - 1; i >= 0; i--) {
    Shape shape = shapes.get(i);
    if (shape.isHit(mouseX, mouseY)) {
      shapes.remove(i);
    } else if (shape.isOffScreenMoreThanThreeTimes()) {

      println("isOffScreenMoreThanThreeTimes return True" );
      shape.setWhite();
      shape.fillWhite();
      if (allShapesWhite()) {
        gameOver = true;
      }
    }
  }
}

boolean allShapesWhite() {
  for (Shape shape : shapes) {
    if (!shape.isWhite()) {
      return false;
    }
  }
  return true;
}

void mouseMoved() {
  stroke(255, 0, 0);
  strokeWeight(20);
  point(mouseX, mouseY);
}

class Shape {
  float x, y;
  float speed;
  color c;
  float size;
  float originalSize;
  int rotationDir;
  float rotationAngle = 0;
  boolean white = false;
  int offScreenCounter = 0;

  Shape(float x, float y, float speed, color c, float size, int rotationDir) {
    this.x = x;
    this.y = y;
    this.speed = speed;
    this.c = c;
    this.size = size;
    this.originalSize = size;
    this.rotationDir = rotationDir;
  }

  void update() {
    y += speed;
    rotationAngle += rotationDir * 0.05;
    size += 0.01;
    if (size >= 1.5 * originalSize || size <= -1.5 * originalSize) {
      size = constrain(size, -1.5 * originalSize, 1.5 * originalSize);
    }
  }

  void display() {
    pushMatrix();
    translate(x, y);
    rotate(rotationAngle);
    fill(c);
    noStroke();

    if (white) {
      println("display() fill(white) executed");
      fill(255,255,255);
    }
    drawStar(0, 0, 6, size * 10, size * 5);
    popMatrix();
  }

  boolean isHit(float targetX, float targetY) {
    return dist(targetX, targetY, x, y) <= size * 5;
  }

  boolean isOffScreen() {
    if (y > height) {
      println("isOffScreen() executed");
      offScreenCounter++;
    }

    return (y > height);
  }

  boolean isOffScreenMoreThanThreeTimes() {
    return (offScreenCounter >= 3);
  }

  void setWhite() {
    println("setWhite() executed");
    white = true;
  }

  void fillWhite() {
    println("fillWhite() executed");
    c = color(255, 255, 255);
    fill(c);
  }

  boolean isWhite() {
    return white;
  }

  void reset() {
    x = random(width);
    y = random(-height, 0);
    speed = random(3, 5);
    size = random(3, 10);
    originalSize = size;
    rotationDir = (int)(random(-2, 2));
    rotationAngle = 0;
  }


  // how to create six pointed star in processing
  void drawStar(float x, float y, int numPoints, float outerRadius, float innerRadius) {
    float angle = TWO_PI / numPoints;
    float halfAngle = angle / 2.0;
    beginShape();
    for (float a = 0; a < TWO_PI; a += angle) {
      float sx = x + cos(a) * outerRadius;
      float sy = y + sin(a) * outerRadius;
      vertex(sx, sy);
      sx = x + cos(a + halfAngle) * innerRadius;
      sy = y + sin(a + halfAngle) * innerRadius;
      vertex(sx, sy);
    }
    endShape(CLOSE);
  }
}
