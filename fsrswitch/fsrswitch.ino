int fsr = 0;
int fsrv;
boolean fsrg = true;

void setup() {
  Serial.begin(9600);
}

void loop() {
  fsrv = analogRead(fsr);
  if (fsrg) {
    if (fsrv > 600) {
      fsrg = false;
      Serial.print("fsr1on:");
      Serial.println(fsrv);
    }
  }
  if(!fsrg){
    if(fsrv<300){
      fsrg = true;
      Serial.print("fsr1off:");
      Serial.println(fsrv);
    }
  }
  delay(15);
}
