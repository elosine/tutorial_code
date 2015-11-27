// https://www.youtube.com/watch?v=9_zAz-dKH30
// https://www.youtube.com/watch?v=A-QnuPeX9f0

import netP5.*;
import oscP5.*;

OscP5 osc;
NetAddress sc;

PFont font1;

PushMe buttons, buttons2;

void setup() {
  size(1000, 800);
  osc = new OscP5(this, 12321);
  sc = new NetAddress("127.0.0.1", 57120);

  font1 = createFont("Monaco-14.vlw", 14);
  textFont(font1);
  buttons = new PushMe(7, 50, 50, 100, 40, 1);
  buttons2 = new PushMe(10, 200, 80, 40, 40, 0);
}

void draw() {
  background(0);
  buttons.drw();
  buttons2.drw();
}

void mousePressed() {
  buttons.msprs();
  buttons2.msprs();
}

void mouseReleased() {
  buttons.msrel();
  buttons2.msrel();
}

void mouseMoved() {
  buttons.msmvd();
  buttons2.msmvd();
}

void keyPressed() {
  buttons.keyprs();
  buttons2.keyprs();
}

void keyReleased() {
  buttons.keyrel();
  buttons2.keyrel();
}

boolean bon( int l, int r, int t, int b ) {
  boolean on = false;
  if ( mouseX>=l && mouseX <=r && mouseY>=t && mouseY<=b) {
    on = true;
  }
  return on;
}