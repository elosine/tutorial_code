class PushMe {
  //Constructor Variables
  int numbut, xi, yi, bw, bh, vh;
  String lblS;
  //Class Variables
  int[] l, r, t, b;
  int pgap = 3;
  int gap = 30;
  int[] btrig, mo;
  PImage[] icons;
  String[] iconpaths;
  char[] keys = {'1', '2', '3', '4', '5', '6', '7', '8', '9', '0', 
    'q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p', 
    'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l', 
    'z', 'x', 'c', 'v', 'b', 'n', 'm'};
  String[]lbl;

  //Constructor
  PushMe(int anumbut, int axi, int ayi, int abw, int abh, int avh, String alblS) {
    numbut = anumbut;
    xi = axi;
    yi = ayi;
    bw = abw;
    bh = abh;
    vh = avh;
    lblS = alblS;

    //Set Up Instance
    icons = new PImage[iconpaths.length];
    for (int i=0; i<icons.length; i++) icons[i] = loadImage(iconpaths[i]);
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
  }//end Constructor

  void drw() {
    noStroke();
    for (int i=0; i<numbut; i++) {
      if (btrig[i] == 1) fill(255, 255, 0);
      else fill(153, 255, 0);
      if (mo[i] == 1) { //mouse over
        rect(l[i] - pgap, t[i] - pgap, bw+(pgap*2), bh+(pgap*2));
        image(icons[i%icons.length], l[i] - pgap + 5, t[i] - pgap + 5, bw+(pgap*2)-10, bh+(pgap*2)-10 );
      } // end if (mo[i] == 1) {
      else {
        rect(l[i], t[i], bw, bh);
        image(icons[i%icons.length], l[i]+5, t[i]+5, bw-10, bh-10);
      } //end else if (mo[i] == 1) {
      text( lbl[i%lbl.length], l[i], t[i]-5 );
    }//end for (int i=0; i<numbut; i++)
  }//end void drw

  void msprs() {
    for (int i=0; i<numbut; i++) {
      if ( bon(l[i], r[i], t[i], b[i]) ) {
        OscMessage msg1 = new OscMessage("/playbuf");
        msg1.add(i);
        osc.send(msg1, sc);
        btrig[i] = 1;
      }
    }
  }//end void msprs()

  void msrel() {
    for (int i=0; i<numbut; i++) {
      if ( bon(l[i], r[i], t[i], b[i]) ) {
        btrig[i] = 0;
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
      if (key == keys[i]) {
        OscMessage msg1 = new OscMessage("/playbuf");
        msg1.add(i);
        osc.send(msg1, sc);
        btrig[i%numbut] = 1;
      }
    }
  }//end void keyprs()

  void keyrel() {
    for (int i=0; i<keys.length; i++) {
      if (key == keys[i]) {
        btrig[i%numbut] = 0;
      }
    }
  }//end void keyrel()
}//end class PushMe