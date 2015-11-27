import netP5.*;
import oscP5.*;
import processing.serial.*;

OscP5 osc;
NetAddress sc;

PFont font1;
int vh = 1;
PushMe buttons;

void setup() {
  size(1000, 600);
  osc = new OscP5(this, 12321);
  sc = new NetAddress("127.0.0.1", 57120);

  font1 = createFont("Monaco-14.vlw", 14);
  textFont(font1);
  buttons = new PushMe(0, 5, 80, 80, 100, 60, 1, "Hi-Hat:Snare:Kick",
  "FFCB1717:FF99FF00:FF00FFFD:FFE58BFF", "1:2:3:4:5:6:7:8:9:0",
  "/testmsg", 1, 0);
}

void draw() {
  background(0);
  buttons.drw();
}

void mousePressed() {
  buttons.msprs();
}

void mouseReleased() {
  buttons.msrel();
}

void mouseMoved() {
  buttons.msmvd();
}

void keyPressed() {
  buttons.keyprs();
}

void keyReleased() {
  buttons.keyrel();
}



boolean bon( int l, int r, int t, int b ) {
  boolean on = false;
  if ( mouseX>=l && mouseX <=r && mouseY>=t && mouseY<=b) {
    on = true;
  }
  return on;
}