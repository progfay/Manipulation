import fisica.*;

// y = Ax + B
final float A = 0.4;
final float B = 300;
final float THRESHOLD = 1;

FWorld world;
FCircle ball;

ArrayList<PVector> onLine = new ArrayList<PVector>();
boolean continuously = false;

void setup() {
  size(1280, 720);

  Fisica.init(this);

  world = new FWorld();
  world.setEdges();
  world.remove(world.left);
  world.remove(world.right);
  world.remove(world.top);
  world.bottom.setFill(255);
  world.bottom.setStroke(255);
  world.setEdgesRestitution(0.0);

  ball = new FCircle(25);
  ball.setPosition(-500, height/6);
  ball.setRestitution(1.0);
  ball.setNoStroke();
  ball.setVelocity(800, 150);
  ball.setFill(224);
  world.add(ball);

  background(255);
  stroke(192);
  strokeWeight(3);
  line(0, B, (height-B) / A, height);
  
  noStroke();
  fill(64);
}

void draw() {
  world.step();
  if (abs(A * ball.getX() + B - ball.getY()) >= THRESHOLD) {
    continuously = false;
  } else if (!continuously) {
    continuously = true;
    onLine.add(new PVector(ball.getX(), ball.getY()));
  }
  
  for (PVector vec : onLine) {
    ellipse(vec.x, vec.y, 25, 25);
  }
  
  world.draw();
  save("frame/" + nf(frameCount, 3) + ".png");
  if (frameCount == 650) exit();
}
