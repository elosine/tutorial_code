import oscP5.*;
import netP5.*;
OscP5 osc;

int x = 0;

void setup() {
  size(800, 600);
  osc = new OscP5(this, 12321);
  osc.plug(this, "movex", "/movex");
}

void draw() {
  background(0);
  noStroke();
  strokeWeight(3);
  stroke(255);
  noFill();
  rect(x, height/2, 80, 170);
}


void movex(int ax) {
  x = ax;
}

