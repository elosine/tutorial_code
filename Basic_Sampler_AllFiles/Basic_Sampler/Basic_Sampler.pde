import netP5.*;
import oscP5.*;
import processing.serial.*;

OscP5 osc;
NetAddress sc;

//// Serial ///////////////////////////////////////////////////////////////////////////////
Serial ino; 
String serialmsg;
boolean serialon = true;
int serialport = 5;

int numbut = 14;
int xi = 30;
int yi = 20;
int bsz = 80;
int gap = 13;
int[] l, r, t, b;
int[]bonG;
int[]bmo;
char[] keys = {'q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p'};
PImage[]icons;
String[] iconpaths = {"CYMBALS-HI-HAT-14-FIXED-BRILLIANT-SIDE.jpg", 
  "rockstart-kick-drum-colour.png", "snare-topedge-mm.jpg"};

void setup() {
  size(1000, 300);
  osc = new OscP5(this, 12321);
  sc = new NetAddress("127.0.0.1", 57120);  

  //// Serial  /////////////////////////////////////////////////////////////////////////////////
  printArray(Serial.list());
  if (serialon) {
    String portName = Serial.list()[serialport];
    ino = new Serial(this, portName, 9600);
  }

  icons = new PImage[iconpaths.length];
  for (int i=0; i<icons.length; i++) icons[i] = loadImage(iconpaths[i]);

  l = new int[numbut]; 
  for (int i=0; i<numbut; i++) l[i] = xi + ( (bsz+gap)*i );  

  r = new int[numbut]; 
  for (int i=0; i<numbut; i++) r[i] = xi + ( (bsz+gap)*i ) + bsz; 

  t = new int[numbut]; 
  for (int i=0; i<numbut; i++) t[i] = yi;   

  b = new int[numbut]; 
  for (int i=0; i<numbut; i++) b[i] = yi + bsz;   

  bonG = new int[numbut]; 
  for (int i=0; i<numbut; i++) bonG[i] = 0;   

  bmo = new int[numbut]; 
  for (int i=0; i<numbut; i++) bmo[i] = 0;
}
void draw() {
  background(0);


  // READ SERIAL PORT(S) ///////////////////////////////////////////////////////////////////////////////////////////////////////
  if (serialon) { //change this in global variables if you have/have not an arduino plugged in
    if ( ino.available() > 0) {
      serialmsg = trim( ino.readString() ); //rim because sometimes there are extra line feeds and spaes
      String[] msg = split(serialmsg, ":");
      String stag = ""; //dummy values to hold place
      String sval = ""; //dummy values to hold place
      if (msg.length==2) { //only if you are getting a properly formatted message
        stag = msg[0];
        sval = msg[1];
      }
      switch(stag) { //Switch on message tag
        //// FSR 0 ///////////////////////////////////////////
      case "fsrpk0":
        if (int(sval)!=0) {
          float amptmp = norm(int(sval), 120, 800);
          //send osc msg to sc to play sample
          OscMessage oscm1 = new OscMessage("/playbuf");
          oscm1.add(2);
          oscm1.add(amptmp);
          osc.send(oscm1, sc);
          //turn on gate to change color of button for visual feedback 
          bonG[2] = 1;
        }// end if (int(sval)!=0)
        else bonG[2] = 0;
        break;
        //// FSR 1 ///////////////////////////////////////////
      case "fsrpk1":
        if (int(sval)!=0) {
          float amptmp = norm(int(sval), 320, 800);
          //send osc msg to sc to play sample
          OscMessage oscm1 = new OscMessage("/playbuf");
          oscm1.add(1);
          oscm1.add(amptmp);
          osc.send(oscm1, sc);
          //turn on gate to change color of button for visual feedback 
          bonG[1] = 1;
        }// end if (int(sval)!=0)
        else bonG[1] = 0;
        break;
      } //end switch
    }//end if ( ino.available() > 0)
  }// end if (serialon)

  for (int i=0; i<numbut; i++) {
    //DRAW BUTTONS
    //draw a stroke around button if moused over
    if (bmo[i]==1) {
      strokeWeight(3);
      stroke(255, 0, 0);
    } //
    else noStroke();
    //change color of button if pressed
    if (bonG[i]==1) fill(255, 0, 128);
    else fill(153, 255, 0);
    rect(l[i], t[i], bsz, bsz);
    //DRAW ICONS
    image(icons[i%icons.length], l[i]+7, t[i]+7, bsz-14, bsz-14);
  }
}

void mousePressed() {
  for (int i=0; i<numbut; i++) {
    //Detect whether mouse is touching a button
    if ( bon(l[i], r[i], t[i], b[i]) ) {
      //send osc msg to sc to play sample
      OscMessage msg = new OscMessage("/playbuf");
      msg.add(i);
      msg.add(1);
      osc.send(msg, sc);
      //turn on gate to change color of button for visual feedback 
      bonG[i] = 1;
    }
  }
}
void mouseReleased() {
  for (int i=0; i<numbut; i++) {
    //Detect whether mouse is touching a button
    if ( bon(l[i], r[i], t[i], b[i]) ) {
      bonG[i] = 0;
    }
  }
}
void mouseMoved() {
  for (int i=0; i<numbut; i++) {
    if (bon(l[i], r[i], t[i], b[i])) {
      bmo[i] = 1;
    } else bmo[i] = 0;
  }
}

void keyPressed() {
  //iterate through all the keys
  for (int i=0; i<keys.length; i++) {
    if (key==keys[i]) {
      OscMessage msg = new OscMessage("/playbuf");
      msg.add(i);
      msg.add(1);
      osc.send(msg, sc);
      bonG[i%numbut] = 1;
      // bonG[ constrain(i, 0, numbut-1) ] = 1;
    }
  }
} //end keyPressed
void keyReleased() {
  //iterate through all the keys
  for (int i=0; i<keys.length; i++) {
    if (key==keys[i]) {
      bonG[i%numbut] = 0;
      //bonG[ constrain(i, 0, numbut-1) ] = 1;
    }
  }
} //end keyReleased



boolean bon(int l, int r, int t, int b) {
  boolean ison = false;
  if ( mouseX>=l && mouseX<=r && mouseY>=t && mouseY<=b ) {
    ison = true;
  }
  return ison;
}