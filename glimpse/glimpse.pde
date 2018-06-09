import fisica.*;

// y = Ax + B
final float A = 0.4;
final float B = 300;
final float THRESHOLD = 1;
final int BLUR_FRAME = 30;

FWorld world;
FCircle ball;

ArrayList<PVector> onLine = new ArrayList<PVector>();
ArrayList<PVector> direction = new ArrayList<PVector>();
boolean continuously = false;

void setup() {
  size(1280, 720);

  Fisica.init(this);

  world = new FWorld();
  world.setEdges();
  world.remove(world.left);
  world.remove(world.right);
  world.remove(world.top);
  world.setEdgesRestitution(0.0);

  ball = new FCircle(25);
  ball.setPosition(-500, height/6);
  ball.setRestitution(1.0);
  ball.setVelocity(800, 150);
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
    direction.add(new PVector(ball.getVelocityX(), ball.getVelocityY()));
    continuously = true;
  }

  for (int i = 0; i < onLine.size(); i++) {
    PVector position = onLine.get(i);
    PVector revDirection = direction.get(i).copy().mult(-1).normalize();
    int diff = int(abs(position.z - frameCount + BLUR_FRAME * 2));
    if (diff > BLUR_FRAME) continue;

    for (int j = 8; j > 0; j--) {
      fill(map(j, 0, 8, 160, 255), map(diff, 0, BLUR_FRAME, 255, 0));
      ellipse(position.x+revDirection.x*j, position.y+revDirection.y*j, 25, 25);
    }

    fill(64, map(diff, 0, BLUR_FRAME, 255, 0));
    ellipse(position.x, position.y, 25, 25);
  }

  if (frameCount <= BLUR_FRAME) return;
  save("frame/" + nf(frameCount-BLUR_FRAME, 3) + ".png");
  if (frameCount == 650 + BLUR_FRAME) exit();
}
