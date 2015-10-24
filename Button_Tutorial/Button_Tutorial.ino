int bt1 = 3;
boolean bt1g;


void setup() {
  Serial.begin(9600);
  pinMode(bt1, INPUT_PULLUP);
  bt1g = false;
}

void loop() {
  int bt1val = digitalRead(bt1);
  if (!bt1g) {
    if (bt1val == 0) {
      Serial.println(bt1val);
      bt1g = true;
    }
  }
  else {
    if (bt1val == 1) {
      Serial.println(bt1val);
      bt1g = false;
    }
  }
  delay(15);
}
