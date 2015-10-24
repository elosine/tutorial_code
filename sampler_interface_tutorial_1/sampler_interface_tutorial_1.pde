import oscP5.*;
import netP5.*;

OscP5 osc;
NetAddress sc;

float cx = 0.0;

void setup(){
  size(1000, 150);
  osc = new OscP5(this, 12321);
  sc = new NetAddress("127.0.0.1", 57120);
  osc.plug(this, "trix", "/ix");
}

void draw(){
  background(0);
  
  //Track Background
  noStroke();
  fill(25, 33, 47);
  rect(0,0,1000,150);
  
  //Beat Grid
  ////Measure markers
  stroke(255);
  strokeWeight(1);
  line(0,0,0,150);
  line(250,0,250,150);
  line(500,0,500,150);
  line(750,0,750,150);
  ////Beat markers
  noStroke();
  fill(255);
  ellipseMode(CENTER);
  for(int i=0;i<16;i++){
    ellipse(i*62.5, 75, 8, 8);
  }
  
  //Cursor
  OscMessage ixmsg = new OscMessage("/getidx");
  osc.send(ixmsg, sc);
  strokeWeight(3);
  stroke(153,255,0);
  line(cx, 0, cx, 150);
  
}


void trix(float idx){
  cx = map(idx, 0.0, 1.0, 0.0, 1000.0);
}

