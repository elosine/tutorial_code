import processing.serial.*;
import oscP5.*;
import netP5.*;

OscP5 osc;
NetAddress sc;

Serial ino;

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
float[] rangeX1, rangeX2; 
int[] ranger;
int[] trcsr;
float[] tcx;

boolean serialon = true;

void setup() {
  size( 1024, 960 );
  OscProperties prop = new OscProperties();
  prop.setListeningPort(12321);
  prop.setDatagramSize(5136);
  osc = new OscP5(this, prop);
  sc = new NetAddress("127.0.0.1", 57120);
  osc.plug(this, "trix", "/ix");

  //println( Serial.list() );
  if (serialon) {
    String portname = Serial.list()[5];
    ino = new Serial(this, portname);
  }

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

  rangeX1 = new float[numtrx];
  for (int i = 0; i<numtrx; i++) rangeX1[i] = x0;
  rangeX2 = new float[numtrx];
  for (int i = 0; i<numtrx; i++) rangeX2[i] = w;
  ranger = new int[numtrx];
  for (int i = 0; i<numtrx; i++) ranger[i] = 0;
  trcsr = new int[numtrx];
  for (int i=0; i<numtrx; i++) trcsr[i]=0;
  tcx = new float[numtrx];
  for (int i=0; i<numtrx; i++) tcx[i]= 0.0;
}//end setup

void draw() {
  background(0);

  if (serialon) {
    if (ino.available() > 0) {
      String smsg = ino.readString();
      String[] mt1 = split(smsg, '\r');
      mt1 = shorten(mt1);
      for (int i=0; i<mt1.length; i++) {
        String[] mt2 = split(mt1[i], ':');
        //// bt0 ////
        if ( mt2[0].equals("bt0") ) {
          rectogs[0] = ( rectogs[0] + int(mt2[1]) )%2;
          if (rectogs[0]==1) recon(0);
          else recoff(0);
        }
        //// bt1 ////
        if ( mt2[0].equals("bt1") ) {
          rectogs[1] = ( rectogs[1] + int(mt2[1]) )%2;
          if (rectogs[1]==1) recon(1);
          else recoff(1);
        }
        //// bt2 ////
        if ( mt2[0].equals("bt2") ) {
          rectogs[2] = ( rectogs[2] + int(mt2[1]) )%2;
          if (rectogs[2]==1) recon(2);
          else recoff(2);
        }
        //// bt3 ////
        if ( mt2[0].equals("bt3") ) {
          rectogs[3] = ( rectogs[3] + int(mt2[1]) )%2;
          if (rectogs[3]==1) recon(3);
          else recoff(3);
        }
        //// cs1 ////
        if ( mt2[0].equals("cs1") ) {
          playtogs[0] = ( playtogs[0] + int(mt2[1]) )%2;
          if (playtogs[0]==1) play(0);
          else pause(0);
        }
        //// cs2 ////
        if ( mt2[0].equals("cs2") ) {
          playtogs[1] = ( playtogs[1] + int(mt2[1]) )%2;
          if (playtogs[1]==1) play(1);
          else pause(1);
        }
        //// cs3 ////
        if ( mt2[0].equals("cs3") ) {
          playtogs[2] = ( playtogs[2] + int(mt2[1]) )%2;
          if (playtogs[2]==1) play(2);
          else pause(2);
        }
      }
    }
  }

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

  //Loop Highlighting
  for (int i=0; i<numtrx; i++) {
    if (ranger[i] == 1) {
      noStroke();
      fill(255, 255, 0, 70);
      rect(rangeX1[i], trht*i, rangeX2[i]-rangeX1[i], trht);
    }
  }


  //Record Highlighting
  for (int i=0; i<numtrx; i++) {
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
    fill(0, 0, 255);
    rect(0, (i*trht)+20+20+20, 17, 17);
  }

  //Primary Cursor
  OscMessage ixmsg = new OscMessage("/getidx");
  ixmsg.add(99);
  osc.send(ixmsg, sc);
  strokeWeight(3);
  stroke(153, 255, 0);
  line(cx, 0, cx, height);

  //track cursor
  for (int i=0; i<numtrx; i++) {
    if (trcsr[i] == 1) {
      OscMessage tixmsg = new OscMessage("/getidx");
      tixmsg.add(i);
      osc.send(tixmsg, sc);
      strokeWeight(3);
      stroke(0, 255, 153);
      line(tcx[i], trht*i, tcx[i], (trht*i)+trht);
    }
  }
}//end draw

void trix(int tr, float idx) {
  if (tr==99)cx = map(idx, 0.0, 1.0, x0, w+x0);
  else {
    tcx[tr] = map(idx, 0.0, 1.0, x0, w+x0);
  }
}

void mousePressed() {
  //Turn Rec ON/OFF
  for (int i=0; i<numtrx; i++) {
    if ( mouseY>(i*trht)+20 && mouseY < ( (i*trht) + 37 ) ) {
      if ( mouseX <= 17 ) {
        rectogs[i] = (rectogs[i] + 1)%2;
        if (rectogs[i]==1) recon(i);
        else if (rectogs[i] == 0) recoff(i);
      }
    }
  }

  //Play/Pause
  for (int i=0; i<numtrx; i++) {
    if (mouseY > (i*trht)+20+20 && mouseY < ( (i*trht) + +20+20+17 ) ) {
      if (mouseX<=17) {
        playtogs[i] = (playtogs[i] +1)%2; //increments the toggle
        //to play
        if (playtogs[i]==1) play(i);
        else if (playtogs[i] ==0) pause(i);
      }
    }
  }
  //Loop Off
  for (int i=0; i<numtrx; i++) {
    if (mouseY > (i*trht)+20+20+20 && mouseY < ( (i*trht) + +20+20+20+17 ) ) {
      if (mouseX<=17) {
        ranger[i] = 0;
        trcsr[i] = 0;
        OscMessage lomsg = new OscMessage("/setidx");
        lomsg.add(99);
        lomsg.add(i);
        lomsg.add(99);
        lomsg.add(99);
        osc.send(lomsg, sc);
      }
    }
  }
  //Set Loop Range
  for (int i=0; i<numtrx; i++) {
    if ( mouseY>(trht*i) && mouseY<( (trht*i)+trht ) ) {
      ranger[i] = 1;
      rangeX1[i] = mouseX;
      rangeX2[i] = mouseX;
    }
  }
} //end mouse pressed

void mouseDragged() {
  for (int i=0; i<numtrx; i++) {
    if ( mouseY>(trht*i) && mouseY<( (trht*i)+trht ) ) {
      rangeX2[i] = mouseX;
    }
  }
} //end mousedragged

void mouseReleased() {
  for (int i=0; i<numtrx; i++) {
    if ( mouseY>(trht*i) && mouseY<((trht*i)+trht) && mouseX>x0 ) {
      float stnorm = norm(rangeX1[i], x0, width);
      float ednorm = norm(rangeX2[i], x0, width);
      OscMessage setidxmsg = new OscMessage("/setidx");
      setidxmsg.add(i);
      setidxmsg.add(stnorm);
      setidxmsg.add(ednorm);
      setidxmsg.add(1);
      osc.send(setidxmsg, sc);
      trcsr[i] = 1;
    }
  }
}

void oscEvent(OscMessage msg) {
  if ( msg.checkAddrPattern("/sbuf") ) { 
    int trn = msg.get(0).intValue();
    for (int i=0; i<bufsize; i++) {
      samparrays[trn][i] = msg.get(i+1).floatValue();
    }
  }
}

// Record On Function
void recon(int tr) {
  OscMessage ron = new OscMessage("/recon");
  ron.add(tr);
  osc.send(ron, sc);
}

// Record Off Function
void recoff(int tr) {
  OscMessage roff = new OscMessage("/recoff");
  roff.add(tr);
  osc.send(roff, sc);
}

//Play Function
void play(int tr) {
  OscMessage pmsg = new OscMessage("/play");
  pmsg.add(tr);
  osc.send(pmsg, sc);
}

//Pause Function
void pause(int tr) {
  OscMessage psmsg = new OscMessage("/pause");
  psmsg.add(tr);
  osc.send(psmsg, sc);
}