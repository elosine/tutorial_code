import netP5.*;
import oscP5.*;

OscP5 osc;
NetAddress sc;
float pitch = 60.0;
float amp = 1.0;

float pitchlo = 50.0;
float pitchhi = 72.0;

float numkeys;
float keyw, keyh;

int startpart;

void setup() {
  size(1000, 200);
  osc = new OscP5(this, 12321);
  sc = new NetAddress("127.0.0.1", 57120);

  numkeys = pitchhi - pitchlo;
  keyw = width/numkeys;
  keyh = height;
  
  startpart = int(pitchlo)%12;
  
  pitchlo = pitchlo - 0.5;
  pitchhi = pitchhi - 0.5;
  
}

void draw() {
  background(0);
  pitch = map(mouseX, 0, width, pitchlo, pitchhi);
  //pitch = floor(pitch+0.5); //makes each key produce a half-step
  amp = norm(mouseY, height, 0.0);

  OscMessage pitchmsg = new OscMessage("/pitch");
  pitchmsg.add(pitch);
  osc.send(pitchmsg, sc);
  OscMessage ampmsg = new OscMessage("/amp");
  ampmsg.add(amp);
  osc.send(ampmsg, sc);

  strokeWeight(3);
  stroke(0);
  fill(255);
  for (int i=0; i<numkeys; i++) {
    int n = i+startpart;
    if(n%12==1 || n%12==3 || n%12==6 || n%12==8 || n%12==10)fill(0);
    else fill(255);
    rect( keyw*i, 0, keyw, keyh);
  }
}

void mousePressed() {
  OscMessage trig = new OscMessage("/trig");
  trig.add(1);
  osc.send(trig, sc);
}
void mouseReleased() {
  OscMessage trig = new OscMessage("/trig");
  trig.add(0);
  osc.send(trig, sc);
}