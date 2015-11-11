int led1 = 4;
int led2 = 5;
int bt1 = 8;
int bt2 = 9;
boolean bt1g = true;
boolean bt2g = true;
int bt2t = 0;

void setup() {
  Serial.begin(9600);
  pinMode(led1, OUTPUT);
  pinMode(led2, OUTPUT);
  pinMode(bt1, INPUT_PULLUP);
  pinMode(bt2, INPUT_PULLUP);
}

void loop() {
  ////BT1//// - Momentary Switch

  //IF bt1 is on
  if ( bt1g ) {
    if ( digitalRead(bt1) == LOW ) {
      digitalWrite(led1, HIGH);
      Serial.print("bt1:");
      Serial.println(1);
      bt1g = false;
    }
  }
  //If bt1 is off
  if (!bt1g) {
    if ( digitalRead(bt1) == HIGH ) {
      digitalWrite(led1, LOW);
      Serial.print("bt1:");
      Serial.println(0);
      bt1g = true;
    }
  }
  
  
  ////BT2//// - Toggle Switch

  //IF bt2 is on
  if ( bt2g ) { 
    if ( digitalRead(bt2) == LOW ) { 
      bt2t = (bt2t + 1)%2; //toggles bt2t between 0 & 1
      Serial.print("bt2:");
      Serial.println(bt2t);
      bt2g = false;
    }
  }
  //If bt2 is off
  if (!bt2g) {
    if ( digitalRead(bt2) == HIGH ) {
     // Serial.print("bt2:");
      //Serial.println(0);
      bt2g = true;
    }
  }
  
  //toggle led2 on and off w/bt2 button
  if(bt2t == 0) digitalWrite(led2, LOW);
  if(bt2t == 1) digitalWrite(led2, HIGH);
  
  delay(15);
}









