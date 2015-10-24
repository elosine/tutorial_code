import processing.serial.*;

Serial ino;
String smsg;
int bt1v= 0;

void setup() {
  size(500, 500);
  //println( Serial.list() );
  String portname = Serial.list()[5];
  ino = new Serial(this, portname, 9600);
}

void draw() {
  if(bt1v ==0)background(0);
  if(bt1v == 1)background(255);
  if ( ino.available() > 0 ) {
    smsg = ino.readString();
    String[] mt1 = split(smsg, '\r');
    mt1 = shorten(mt1);
    for (int i=0; i<mt1.length; i++) {
      String[] mt2 = split(mt1[i], ":");
      //bt1
      if( mt2[0].equals("bt1") ){
        bt1v = int( mt2[1] );
      }
      
    }
  }
}