int fsr = 0;
int fsrv;

void setup(){
  Serial.begin(9600);
}

void loop(){
  fsrv = analogRead(fsr);
  Serial.println(fsrv);
  delay(15);
}
