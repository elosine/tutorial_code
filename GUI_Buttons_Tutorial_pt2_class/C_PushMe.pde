class PushMe {
  //Constructor Variables
  int numbut, xi, yi, bw, bh, hv;
  //Class Variables
  int[] l, r, t, b;
  int pigap = 3;
  int gap = 30;
  int[] btrig, mo;
  PImage[] icons;
  String[] iconpaths = { "CYMBALS-HI-HAT-14-FIXED-BRILLIANT-SIDE.jpg", 
    "rockstart-kick-drum-colour.png", "snare-topedge-mm.jpg" };
  char[] keys = {'q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p'};
  String[]lbl = {"hatC", "Kick", "Snare"};

  //Constructor
  PushMe(int anumbut, int axi, int ayi, int abw, int abh, int ahv) {
    numbut = anumbut;
    xi = axi;
    yi = ayi;
    bw = abw;
    bh = abh;
    hv = ahv;

    //  icons = new PImage[iconpaths.length];
    // for (int i=0; i<icons.length; i++) icons[i] = loadImage(iconpaths[i]);

    l = new int[numbut];
    r = new int[numbut];
    t = new int[numbut];
    b = new int[numbut];

    if (hv ==0) {
      for (int i=0; i<numbut; i++) {
        l[i] = xi + ( (bw+gap)*i );
        r[i] = l[i]+bw;
        t[i] = yi;
        b[i] = yi+bh;
      }
    } //
    if (hv==1) {
      for (int i=0; i<numbut; i++) {
        l[i] = xi;
        r[i] = xi+bw;
        t[i] = yi + ( (bh+gap)*i );
        b[i] = yi+t[i]+bh;
      }
    }

    btrig = new int[numbut];
    for (int i=0; i<numbut; i++) btrig[i] = 0;
    mo = new int[numbut];
    for (int i=0; i<numbut; i++) mo[i] = 0;
  }

  void drw() {
    noStroke();
    for (int i=0; i<numbut; i++) {
      if (btrig[i] == 1) fill(255, 255, 0);
      else fill(153, 255, 0);
      if (mo[i] == 1) { //moused over behavior
        rect( l[i] - pigap, t[i] - pigap, bw+(pigap*2), bh+(pigap*2) );
       // image(icons[i%icons.length], l[i] - pigap + 5, t[i] - pigap + 5, bw+(pigap*2)-10, bh+(pigap*2)-10 );
      } //
      else { //not moused over behavior
        rect(l[i], t[i], bw, bh);
       // image(icons[i%icons.length], l[i]+5, t[i]+5, bw-10, bh-10);
      }
      text( lbl[i%lbl.length], l[i], t[i]-5 );
    }
  }

  void msprs() {
    for (int i=0; i<numbut; i++) {
      if ( bon(l[i], r[i], t[i], b[i]) ) {
        OscMessage msg1 = new OscMessage("/playbuf");
        msg1.add(i);
        osc.send(msg1, sc);
        btrig[i] = 1;
      }
    }
  }

  void msrel() {
    for (int i=0; i<numbut; i++) {
      if ( bon(l[i], r[i], t[i], b[i]) ) {
        btrig[i] = 0;
      }
    }
  }

  void msmvd() {
    for (int i=0; i<numbut; i++) {
      if ( bon(l[i], r[i], t[i], b[i]) ) {
        mo[i] = 1;
      } //
      else mo[i]=0;
    }
  }

  void keyprs() {
    for (int i=0; i<keys.length; i++) {
      if (key == keys[i]) {
        OscMessage msg1 = new OscMessage("/playbuf");
        msg1.add(i);
        osc.send(msg1, sc);
        btrig[i%numbut] = 1;
      }
    }
  }

  void keyrel() {
    for (int i=0; i<keys.length; i++) {
      if (key == keys[i]) {
        btrig[i%numbut] = 0;
      }
    }
  }
}//end class PushMe