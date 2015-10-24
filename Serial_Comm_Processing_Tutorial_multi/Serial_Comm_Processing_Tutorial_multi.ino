int nbts = 3;
int startpin = 2;
int bts[3];
boolean btgs[3];


void setup() {
  Serial.begin(9600);
  for (int i = 0; i < nbts; i++) bts[i] = i + startpin;
  for (int i = 0; i < nbts; i++) btgs[i] = false;
  for (int i = 0; i < nbts; i++) pinMode(bts[i], INPUT_PULLUP);
}

void loop() {
  for (int i = 0; i < nbts; i++) {
    if (!btgs[i]) {
      if ( digitalRead(bts[i])==LOW ) {
        Serial.print("bt" + String(i) + ":");
        Serial.println(1);
        btgs[i] = true;
      }
    }
    else {
      if ( digitalRead(bts[i])==HIGH ) {
        Serial.print("bt" + String(i) + ":");
        Serial.println(0);
        btgs[i] = false;
      }
    }
    
  }
  delay(15);
}
