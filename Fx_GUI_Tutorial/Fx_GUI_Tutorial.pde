import netP5.*;
import oscP5.*;
import processing.serial.*;

OscP5 osc;
NetAddress sc;
int numbut = 15;
int xi = 20;
int yi = 40;
int[] l, r, t, b;
int bw = 120;
int bh = 30;
int pgap = 3;
int gap = 10;
int[] btrig, mo;
PImage[] icons;
String[] iconpaths = { "CYMBALS-HI-HAT-14-FIXED-BRILLIANT-SIDE.jpg", 
  "rockstart-kick-drum-colour.png", "snare-topedge-mm.jpg" };
char[] keys = {'q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p'};
String[]lbl = {"hatC", "Kick", "Snare"};

PFont font1;
int vh = 1;

void setup() {
  size(1000, 300);
  osc = new OscP5(this, 12321);
  sc = new NetAddress("127.0.0.1", 57120);

  font1 = createFont("Monaco-14.vlw", 14);
  textFont(font1);

  icons = new PImage[iconpaths.length];
  for (int i=0; i<icons.length; i++) icons[i] = loadImage(iconpaths[i]);
  if (vh==0) {
    l = new int[numbut];
    for (int i=0; i<numbut; i++) l[i] = xi + ( (bw+gap)*i );
    r = new int[numbut];
    for (int i=0; i<numbut; i++) r[i] = l[i]+bh;
    t = new int[numbut];
    for (int i=0; i<numbut; i++) t[i] = yi;
    b = new int[numbut];
    for (int i=0; i<numbut; i++) b[i] = yi+bh;
  } //end if vh==0
  else {
    l = new int[numbut];
    for (int i=0; i<numbut; i++) l[i] = xi ;
    r = new int[numbut];
    for (int i=0; i<numbut; i++) r[i] = l[i]+sz1;
    t = new int[numbut];
    for (int i=0; i<numbut; i++) t[i] = yi + ( (sz1+gap)*i );
    b = new int[numbut];
    for (int i=0; i<numbut; i++) b[i] = yi + ( (sz1+gap)*i ) + sz1;
  }//end else if vh==1


  btrig = new int[numbut];
  for (int i=0; i<numbut; i++) btrig[i] = 0;

  mo = new int[numbut];
  for (int i=0; i<numbut; i++) mo[i] = 0;
}

void draw() {
  background(0);
  noStroke();
  for (int i=0; i<numbut; i++) {
    if (btrig[i] == 1) fill(255, 255, 0);
    else fill(153, 255, 0);
    if (mo[i] == 1) { //mouse over
      rect(l[i] - ((sz2-sz1)/2), t[i] - ((sz2-sz1)/2), sz2, sz2);
      image(icons[i%icons.length], l[i] - ((sz2-sz1)/2) + 5, t[i] - ((sz2-sz1)/2) + 5, sz2-10, sz2-10 );
    } // end if (mo[i] == 1) {
    else {
      rect(l[i], t[i], sz1, sz1);
      image(icons[i%icons.length], l[i]+5, t[i]+5, sz1-10, sz1-10);
    } //end else if (mo[i] == 1) {
    text( lbl[i%lbl.length], l[i], t[i]-5 );
  }//end for (int i=0; i<numbut; i++)
}

void mousePressed() {
  for (int i=0; i<numbut; i++) {
    if ( bon(l[i], r[i], t[i], b[i]) ) {
      OscMessage msg1 = new OscMessage("/playbuf");
      msg1.add(i);
      osc.send(msg1, sc);
      btrig[i] = 1;
    }
  }
}

void mouseReleased() {
  for (int i=0; i<numbut; i++) {
    if ( bon(l[i], r[i], t[i], b[i]) ) {
      btrig[i] = 0;
    }
  }
}

void mouseMoved() {
  for (int i=0; i<numbut; i++) {
    if ( bon(l[i], r[i], t[i], b[i]) ) {
      mo[i] = 1;
    } //
    else mo[i]=0;
  }
}

void keyPressed() {
  for (int i=0; i<keys.length; i++) {
    if (key == keys[i]) {
      OscMessage msg1 = new OscMessage("/playbuf");
      msg1.add(i);
      osc.send(msg1, sc);
      btrig[i%numbut] = 1;
    }
  }
}

void keyReleased() {
  for (int i=0; i<keys.length; i++) {
    if (key == keys[i]) {
      btrig[i%numbut] = 0;
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