
void setup() {
  size(800, 600);
}

void draw() {
  background(0);
 noStroke();
   rectMode(CENTER);
strokeWeight(3);
stroke(255);
  noFill();
  rect(width/2, height/2, 80, 170);
  ellipse(width/2, 180, 50, 50);
  rect(300, 250, 100, 20);
  rect(500, 250, 100, 20);
  rect(380, 450, 20, 100);
  rect(420, 450, 20, 100);

 

  if (frameCount>10 && frameCount<12) {
    saveFrame("render-###.tif");
  }
}

