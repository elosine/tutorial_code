class PushMe{
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
char[] keys = {'1','2','3','4','5','6','7','8','9','0',
'q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p',
'a','s','d','f','g','h','j','k','l',
'z','x','c','v','b','n','m'};
String[]lbl;
  
  //Constructor
  PushMe(int anumbut, int axi, int ayi, int abw, int abh, int avh){
    numbut = anumbut;
    xi = axi;
    yi = ayi;
    bw = abw;
    bh = abh;
    vh = abh;
    
    
  }
}//end class PushMe