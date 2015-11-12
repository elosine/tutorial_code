import netP5.*;
import oscP5.*;

OscP5 osc;
NetAddress sc;

float amp1 = 0.0;
float amp1b = 0.0;
float amp1c = 0.0;

void setup(){
  size(500, 500);
  osc = new OscP5(this, 12321);
  sc = new NetAddress("127.0.0.1", 57120);
  osc.plug(this, "newamp", "/amp1");
}

void draw(){
  background(0);
  OscMessage msg = new OscMessage("/getamp");
  osc.send(msg, sc);
  strokeWeight(10);
  stroke(15,161,255);
  line(20, (height/2.0)-30, 30+amp1b, height/2.0-30);
  
  stroke(153,255,0);
  line(20, height/2.0, 30+amp1, height/2.0);
  stroke(255,3,231);
  line(20, (height/2.0)+30, 30+amp1c, height/2.0+30);
}

void newamp(float rms){
  amp1 = map(rms, 0.0, 1.0, 0.0, 350.0);
  amp1b = map(rms, 0.0, 1.0, 50.0, 200.0);
  amp1c = map(rms, 0.0, 1.0, 10.0, 430.0);
}