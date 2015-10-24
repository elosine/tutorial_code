import oscP5.*;
import netP5.*;

OscP5 osc;
NetAddress sc;

float numtrx = 8;
float trht = 120;
float w = 1000;
float h;
float numMes = 4;
float btspermes = 4;
float btspertrk;
float pxpermes, pxperbt;

float cx = 0.0;
int rectog = 0;
int playtog = 1;


int bufsize = 1000;

float[] samparray;

void setup() {
  size( 1000, 960 );
  OscProperties prop = new OscProperties();
  prop.setListeningPort(12321);
  prop.setDatagramSize(5136);
  osc = new OscP5(this, prop);
  sc = new NetAddress("127.0.0.1", 57120);
  osc.plug(this, "trix", "/ix");

  h = numtrx * trht;
  pxpermes = w/numMes;
  btspertrk = numMes*btspermes;
  pxperbt = w/btspertrk;
  samparray = new float[bufsize];
  for (int i=0; i<samparray.length; i++) samparray[i] = 0;
}

void draw() {
  background(0);

  //Track Background
  noStroke();
  for (int i=0; i<numtrx; i++) {
    if (i%2==0) fill(25, 33, 47);//alternating tracks have different colors
    else fill(0);
    rect(0, i*trht, w, trht);
  }

  ////update waveform
  if (rectog==1) {
    if (frameCount%12 == 0) {
      OscMessage wfmsg = new OscMessage("/wavfrm");
      osc.send(wfmsg, sc);
    }
  }
  ////draw waveform
  strokeWeight(1);
  stroke(255);
  for (int i=1; i<samparray.length; i++) {
    line(i-1, (height/2) + ( samparray[i-1]*(height/ -2) ), i, (height/2) + ( samparray[i]*(height/ -2) ) );
  }

  //Beat Grid
  ////Measure markers
  stroke(255);
  strokeWeight(1);
  for (int j=0; j<numtrx; j++) {
    //Draw measure lines for one track
    for (int i=0; i<numMes; i++) line(i*pxpermes, (j*trht)+20, i*pxpermes, (j*trht)+trht-20);
  }

  ////Beat markers
  noStroke();
  fill(255);
  ellipseMode(CENTER);
  for (int j=0; j<numtrx; j++) {
    for (int i=0; i<btspertrk; i++) ellipse(i*pxperbt, (j*trht)+(trht/2), 6, 6); //beat markers for 1 trk
  }
  //Record Highlighting
  if (rectog==1) {
    noStroke();
    fill(255, 0, 0, 70);
    rect(0, 0, width, height);
  }

  //Pause Highlighting
  if (playtog==0) {
    noStroke();
    fill(150, 100);
    rect(0, 0, width, height);
  }

  //Cursor
  OscMessage ixmsg = new OscMessage("/getidx");
  osc.send(ixmsg, sc);
  strokeWeight(3);
  stroke(153, 255, 0);
  line(cx, 0, cx, height);
}

void trix(float idx) {
  cx = map(idx, 0.0, 1.0, 0.0, 1000.0);
}

void mousePressed() {
  //Turn Rec ON/OFF
  if ( mouseX < width/2 ) {
    rectog = (rectog + 1)%2;
    if (rectog==1) {
      OscMessage ron = new OscMessage("/recon");
      osc.send(ron, sc);
    } else if (rectog == 0) {
      OscMessage roff = new OscMessage("/recoff");
      osc.send(roff, sc);
    }
  }

  //Play/Pause
  if (mouseX>width/2) {
    playtog = (playtog +1)%2; //increments the toggle
    //to play
    if (playtog==1) {
      OscMessage pmsg = new OscMessage("/play");
      osc.send(pmsg, sc);
    } else if (playtog ==0) {
      OscMessage psmsg = new OscMessage("/pause");
      osc.send(psmsg, sc);
    }
  }
}

void oscEvent(OscMessage msg) {
  if ( msg.checkAddrPattern("/sbuf") ) {
    for (int i=0; i<bufsize; i++) {
      if (i>0) {
        samparray[i-1] = msg.get(i).floatValue();
      }
    }
  }
}

