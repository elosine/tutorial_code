import netP5.*;
import oscP5.*;
import processing.serial.*;

OscP5 osc;
NetAddress sc;

PFont font1;
int vh = 1;
PushMe buttons, buttons2;

void setup() {
  size(1000, 600);
  osc = new OscP5(this, 12321);
  sc = new NetAddress("127.0.0.1", 57120);

  font1 = createFont("Monaco-14.vlw", 14);
  textFont(font1);
  buttons = new PushMe(0, 5, 80, 80, 100, 60, 1, "Hi-Hat:Snare:Kick",
  "FFCB1717:FF99FF00:FF00FFFD:FFE58BFF", "1:2:3:4:5:6:7:8:9:0",
  "/testmsg", 0, 20);
  buttons2 = new PushMe(1, 5, 210, 80, 100, 60, 0, "Hi-Hat:Snare:Kick",
  "FFCB1717:FF99FF00:FF00FFFD:FFE58BFF", "1:2:3:4:5:6:7:8:9:0",
  "/testmsg", 0, 20);
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