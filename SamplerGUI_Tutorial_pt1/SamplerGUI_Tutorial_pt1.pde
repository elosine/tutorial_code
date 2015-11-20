import netP5.*;
import oscP5.*;
import processing.serial.*;

OscP5 osc;
NetAddress sc;
int numbut = 15;
int xi = 20;
int yi = 20;
int[] l, r, t, b;
int sz = 50;
int gap = 10;

void setup() {
  size(1000, 300);
  osc = new OscP5(this, 12321);
  sc = new NetAddress("127.0.0.1", 57120);

  l = new int[numbut];
  for (int i=0; i<numbut; i++) l[i] = xi + ( (sz+gap)*i );

  r = new int[numbut];
  for (int i=0; i<numbut; i++) r[i] = l[i]+sz;

  t = new int[numbut];
  for (int i=0; i<numbut; i++) t[i] = yi;

  b = new int[numbut];
  for (int i=0; i<numbut; i++) b[i] = yi+sz;
}

void draw() {
  background(0);
  noStroke();
  fill(153, 255, 0);
  for (int i=0; i<numbut; i++) {
    rect(l[i], t[i], sz, sz);
  }
}

void mousePressed() {
  for (int i=0; i<numbut; i++) {
    if ( bon(l[i], r[i], t[i], b[i]) ) {
      OscMessage msg1 = new OscMessage("/playbuf");
      msg1.add(i);
      osc.send(msg1, sc);
    }
  }
}

boolean bon( int l, int r, int t, int b ) {
  boolean on = false;
  if ( mouseX>=l && mouseX <=r && mouseY>=t && mouseY<=b) {
    on = true;
  }
  return on;
}