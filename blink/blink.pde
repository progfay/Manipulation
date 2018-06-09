import fisica.*;

// y = Ax + B
final float A = 0.4;
final float B = 300;
final float THRESHOLD = 1;
final int BLUR_FRAME = 90;

FWorld world;
FCircle ball;

ArrayList<PVector> onLine = new ArrayList<PVector>();
boolean continuously = false;

void setup() {
  size(1280, 720);
  smooth();

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
  ball.setStroke(128);
  ball.setVelocity(800, 150);
  ball.setFill(64);
  world.add(ball);
}

void draw() {
  background(255);
  noStroke();

  world.step();
  if (abs(A * ball.getX() + B - ball.getY()) >= THRESHOLD) {
    continuously = false;
  } else if (!continuously) {
    onLine.add(new PVector(ball.getX(), ball.getY(), frameCount));
    continuously = true;
  }

  for (PVector vec : onLine) {
    int diff = int(abs(vec.z - frameCount + BLUR_FRAME * 2));
    if (diff > BLUR_FRAME) continue;
    fill(64, 64, 64, map(diff, 0, BLUR_FRAME, 255, 0));
    ellipse(vec.x, vec.y, 25, 25);
  }

  if (frameCount <= BLUR_FRAME) return;
  save("frame/" + nf(frameCount-BLUR_FRAME, 3) + ".png");
  if (frameCount == 650 + BLUR_FRAME) exit();
}
