import oscP5.*;
import netP5.*;

OscP5 osc;
NetAddress sc;

int numtrx = 8;
float trht = 120;
float w = 1000;
float h;
float x0 = 24;
float numMes = 4;
float btspermes = 4;
float btspertrk;
float pxpermes, pxperbt;

float cx = 0.0;
int[] rectogs, playtogs;
int bufsize = 1000;

float[][] samparrays;

void setup() {
  size( 1024, 960 );
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
  samparrays = new float[numtrx][bufsize];
  for (int i=0; i<numtrx; i++) {
    for (int j=0; j<bufsize; j++) samparrays[i][j] = 0;
  }

  rectogs = new int [numtrx];
  for (int i=0; i<numtrx; i++) rectogs[i] = 0;
  playtogs = new int [numtrx];
  for (int i=0; i<numtrx; i++) playtogs[i] = 1;
}

void draw() {
  background(0);

  //Track Background
  noStroke();
  for (int i=0; i<numtrx; i++) {
    if (i%2==0) fill(25, 33, 47);//alternating tracks have different colors
    else fill(0);
    rect(x0, i*trht, w, trht);
  }
  for (int j=0; j<numtrx; j++) {
    ////update waveform
    if (rectogs[j]==1) {
      if (frameCount%12 == 0) {
        OscMessage wfmsg = new OscMessage("/wavfrm");
        wfmsg.add(j);
        osc.send(wfmsg, sc);
      }
    }
    ////draw waveform
    strokeWeight(1);
    stroke(255);
    for (int i=1; i<bufsize; i++) {
      line(i-1+x0, (j*trht) + (trht/2) + ( samparrays[j][i-1]*(trht/ -2) ), 
        i+x0, (j*trht) + (trht/2) + ( samparrays[j][i]*(trht/ -2) ) );
    }
  }


  //Beat Grid
  ////Measure markers
  stroke(255);
  strokeWeight(1);
  for (int j=0; j<numtrx; j++) {
    //Draw measure lines for one track
    for (int i=0; i<numMes; i++) line((i*pxpermes)+x0, (j*trht)+20, (i*pxpermes)+x0, (j*trht)+trht-20);
  }

  ////Beat markers
  noStroke();
  fill(255);
  ellipseMode(CENTER);
  for (int j=0; j<numtrx; j++) {
    for (int i=0; i<btspertrk; i++) ellipse((i*pxperbt)+x0, (j*trht)+(trht/2), 6, 6); //beat markers for 1 trk
  }
  for (int i=0; i<numtrx; i++) {
    //Record Highlighting
    if (rectogs[i]==1) {
      noStroke();
      fill(255, 0, 0, 70);
      rect(x0, i*trht, width, trht);
    }

    //Pause Highlighting
    if (playtogs[i]==0) {
      noStroke();
      fill(150, 100);
      rect(x0, i*trht, width, trht);
    }
  }

  //Play/Rec Buttons
  noStroke();
  for (int i=0; i<numtrx; i++) {
    fill(255, 0, 0);
    rect(0, (i*trht)+20, 17, 17);
    fill(0, 255, 0);
    rect(0, (i*trht)+20+20, 17, 17);
  }

  //Cursor
  OscMessage ixmsg = new OscMessage("/getidx");
  osc.send(ixmsg, sc);
  strokeWeight(3);
  stroke(153, 255, 0);
  line(cx, 0, cx, height);
}

void trix(float idx) {
  cx = map(idx, 0.0, 1.0, x0, w+x0);
}

void mousePressed() {
  //Turn Rec ON/OFF
  for (int i=0; i<numtrx; i++) {
    if ( mouseY>(i*trht)+20 && mouseY < ( (i*trht) + 37 ) ) {
      if ( mouseX <= 17 ) {
        rectogs[i] = (rectogs[i] + 1)%2;
        if (rectogs[i]==1) {
          OscMessage ron = new OscMessage("/recon");
          ron.add(i);
          osc.send(ron, sc);
        } else if (rectogs[i] == 0) {
          OscMessage roff = new OscMessage("/recoff");
          roff.add(i);
          osc.send(roff, sc);
        }
      }
    }
  }

  //Play/Pause
  for (int i=0; i<numtrx; i++) {
    if (mouseY > (i*trht)+20+20 && mouseY < ( (i*trht) + +20+20+17 ) ) {
      if (mouseX<=17) {
        playtogs[i] = (playtogs[i] +1)%2; //increments the toggle
        //to play
        if (playtogs[i]==1) {
          OscMessage pmsg = new OscMessage("/play");
          pmsg.add(i);
          osc.send(pmsg, sc);
        } else if (playtogs[i] ==0) {
          OscMessage psmsg = new OscMessage("/pause");
          psmsg.add(i);
          osc.send(psmsg, sc);
        }
      }
    }
  }
} //end mouse pressed

void oscEvent(OscMessage msg) {
  if ( msg.checkAddrPattern("/sbuf") ) { 
    int trn = msg.get(0).intValue();
    for (int i=0; i<bufsize; i++) {
      samparrays[trn][i] = msg.get(i+1).floatValue();
    }
  }
}