class PushMe {
  //Constructor Variables
  int ix, numbut, xi, yi, bw, bh, vh;
  String lblS, clrS, keysS, oscadrS;
  int togon;
  int inum; //initial number of the buttons
  //Class Variables
  int[] l, r, t, b;
  int pgap = 3;
  int gap = 30;
  int[] btrig, mo;
  PImage[] icons;
  String[] iconpaths;
  char[] keys;
  String[]lbl;
  boolean images = false;
  String[]clrs;
  int[] tog;
  String[] oscadr;


  //Constructor
  PushMe(int aix, int anumbut, int axi, int ayi, int abw, int abh, int avh, 
    String alblS, String aclrS, String akeysS, String aoscadrS, int atogon, int ainum) {
    ix = aix;
    numbut = anumbut;
    xi = axi;
    yi = ayi;
    bw = abw;
    bh = abh;
    vh = avh;
    lblS = alblS;
    clrS = aclrS;
    keysS = akeysS;
    oscadrS = aoscadrS;
    togon = atogon;
    inum = ainum;

    //Set Up Instance
    // icons = new PImage[iconpaths.length];
    //  for (int i=0; i<icons.length; i++) icons[i] = loadImage(iconpaths[i]);
    if (vh==0) {
      l = new int[numbut];
      for (int i=0; i<numbut; i++) l[i] = xi + ( (bw+gap)*i );
      r = new int[numbut];
      for (int i=0; i<numbut; i++) r[i] = l[i]+bw;
      t = new int[numbut];
      for (int i=0; i<numbut; i++) t[i] = yi;
      b = new int[numbut];
      for (int i=0; i<numbut; i++) b[i] = yi+bh;
    } //end if vh==0
    else {
      l = new int[numbut];
      for (int i=0; i<numbut; i++) l[i] = xi ;
      r = new int[numbut];
      for (int i=0; i<numbut; i++) r[i] = l[i]+bw;
      t = new int[numbut];
      for (int i=0; i<numbut; i++) t[i] = yi + ( (bh+gap)*i );
      b = new int[numbut];
      for (int i=0; i<numbut; i++) b[i] = yi + ( (bh+gap)*i ) + bh;
    }//end else if vh==1

    btrig = new int[numbut];
    for (int i=0; i<numbut; i++) btrig[i] = 0;
    mo = new int[numbut];
    for (int i=0; i<numbut; i++) mo[i] = 0;
    tog = new int[numbut];
    for (int i=0; i<numbut; i++) tog[i] = 0;

    lbl = split(lblS, ':');
    clrs = split(clrS, ':');
    String[] keystmp = split(keysS, ':');
    keys = new char[keystmp.length];
    for (int i=0; i<keystmp.length; i++) keys[i] = keystmp[i].charAt(0);
    printArray(keys);
    oscadr = split(oscadrS, ':');
  }//end Constructor

  void drw() {
    noStroke();
    for (int i=0; i<numbut; i++) {
      if (btrig[i] == 1) fill(255, 255, 0);
      else fill (unhex(clrs[i%clrs.length]));

      if (mo[i] == 1) { //mouse over
        rect(l[i] - pgap, t[i] - pgap, bw+(pgap*2), bh+(pgap*2));
        if (images)image(icons[i%icons.length], l[i] - pgap + 5, t[i] - pgap + 5, bw+(pgap*2)-10, bh+(pgap*2)-10 );
      } // end if (mo[i] == 1) {
      else {
        rect(l[i], t[i], bw, bh);
        if (images) image(icons[i%icons.length], l[i]+5, t[i]+5, bw-10, bh-10);
      } //end else if (mo[i] == 1) {
      text( lbl[i%lbl.length], l[i], t[i]-5 );
    }//end for (int i=0; i<numbut; i++)
  }//end void drw

  void msprs() {
    for (int i=0; i<numbut; i++) {
      if ( bon(l[i], r[i], t[i], b[i]) ) {
        if (togon==0) {
          OscMessage msg1 = new OscMessage(oscadr[i%oscadr.length]);
          msg1.add(ix);
          msg1.add(i+inum);
          msg1.add(lbl[i%lbl.length]);
          msg1.add(1);
          osc.send(msg1, sc);
          btrig[i] = 1;
        }//
        else {
          tog[i] = (tog[i]+1)%2;
          if (tog[i]==1) {
            OscMessage msg1 = new OscMessage(oscadr[i%oscadr.length]);
            msg1.add(ix);
            msg1.add(i+inum);
            msg1.add(lbl[i%lbl.length]);
            msg1.add(1);
            osc.send(msg1, sc);
            btrig[i] = 1;
          }//
          else {
            OscMessage msg1 = new OscMessage(oscadr[i%oscadr.length]);
            msg1.add(ix);
            msg1.add(i+inum);
            msg1.add(lbl[i%lbl.length]);
            msg1.add(0);
            osc.send(msg1, sc);
            btrig[i] = 0;
          }
        }
      }
    }
  }//end void msprs()

  void msrel() {
    for (int i=0; i<numbut; i++) {
      if ( bon(l[i], r[i], t[i], b[i]) ) {
        if (togon==0) {
          OscMessage msg2 = new OscMessage(oscadr[i%oscadr.length]);
          msg2.add(ix);
          msg2.add(i+inum);
          msg2.add(lbl[i%lbl.length]);
          msg2.add(0);
          osc.send(msg2, sc);
          btrig[i] = 0;
        }//
      }
    }
  }//end void msrel()

  void msmvd() {
    for (int i=0; i<numbut; i++) {
      if ( bon(l[i], r[i], t[i], b[i]) ) {
        mo[i] = 1;
      } //
      else mo[i]=0;
    }
  }//end void msmvd()

  void keyprs() {
    for (int i=0; i<keys.length; i++) {
      if (key == keys[i%keys.length]) {
        if (togon==0) {
          OscMessage msg3 = new OscMessage(oscadr[i%oscadr.length]);
          msg3.add(ix);
          msg3.add(i+inum);
          msg3.add(lbl[i%lbl.length]);
          msg3.add(1);
          osc.send(msg3, sc);
          btrig[i%numbut] = 1;
        }////
        else {
          tog[i%numbut] = (tog[i%numbut]+1)%2;
          if (tog[i%numbut]==1) {
            OscMessage msg1 = new OscMessage(oscadr[i%oscadr.length]);
            msg1.add(ix);
            msg1.add((i%numbut)+inum);
            msg1.add(lbl[i%lbl.length]);
            msg1.add(1);
            osc.send(msg1, sc);
            btrig[i%numbut] = 1;
          }//
          else {
            OscMessage msg1 = new OscMessage(oscadr[i%oscadr.length]);
            msg1.add(ix);
            msg1.add((i%numbut)+inum);
            msg1.add(lbl[i%lbl.length]);
            msg1.add(0);
            osc.send(msg1, sc);
            btrig[i%numbut] = 0;
          }
        }
      }
    }
  }//end void keyprs()

  void keyrel() {
    for (int i=0; i<keys.length; i++) {
      if (key == keys[i%keys.length]) {
        if (togon==0) {
          OscMessage msg4 = new OscMessage(oscadr[i%oscadr.length]);
          msg4.add(ix);
          msg4.add((i%numbut)+inum);
          msg4.add(lbl[i%lbl.length]);
          msg4.add(0);
          osc.send(msg4, sc);
          btrig[i%numbut] = 0;
        }//
      }
    }
  }//end void keyrel()
}//end class PushMe