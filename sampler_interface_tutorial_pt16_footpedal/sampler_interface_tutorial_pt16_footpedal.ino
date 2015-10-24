#include <CapacitiveSensor.h>

int nbts = 4;
int startpin = 2;
int bts[4];
boolean btgs[4];

CapacitiveSensor cs1 = CapacitiveSensor(6, 7);
CapacitiveSensor cs2 = CapacitiveSensor(6, 8);
CapacitiveSensor cs3 = CapacitiveSensor(6, 9);
boolean cs1g = true;
boolean cs2g = true;
boolean cs3g = true;

void setup() {
  Serial.begin(9600);
  for (int i = 0; i < nbts; i++) bts[i] = i + startpin;
  for (int i = 0; i < nbts; i++) btgs[i] = false;
  for (int i = 0; i < nbts; i++) pinMode(bts[i], INPUT_PULLUP);
}

void loop() {
  long cs1v = cs1.capacitiveSensor(80);
  long cs2v = cs2.capacitiveSensor(80);
  long cs3v = cs3.capacitiveSensor(80);

  for (int i = 0; i < nbts; i++) {
    if (!btgs[i]) {
      if ( digitalRead(bts[i]) == LOW ) {
        Serial.print("bt" + String(i) + ":");
        Serial.println(1);
        btgs[i] = true;
      }
    }
    else {
      if ( digitalRead(bts[i]) == HIGH ) {
        Serial.print("bt" + String(i) + ":");
        Serial.println(0);
        btgs[i] = false;
      }
    }

  }
  
  
  
  ////CS1////
  if (cs1g) {
    if (cs1v > 1000) {
      Serial.print("cs1:");
      Serial.println(1);
      cs1g = false;
    }
  }
  if (!cs1g) {
    if (cs1v < 300) {
      Serial.print("cs1:");
      Serial.println(0);
      cs1g = true;
    }
  }
  
  ////CS2////
  if (cs2g) {
    if (cs2v > 1000) {
      Serial.print("cs2:");
      Serial.println(1);
      cs2g = false;
    }
  }
  if (!cs2g) {
    if (cs2v < 300) {
      Serial.print("cs2:");
      Serial.println(0);
      cs2g = true;
    }
  }
  
  ////CS3////
  if (cs3g) {
    if (cs3v > 1000) {
      Serial.print("cs3:");
      Serial.println(1);
      cs3g = false;
    }
  }
  if (!cs3g) {
    if (cs3v < 300) {
      Serial.print("cs3:");
      Serial.println(0);
      cs3g = true;
    }
  }
  delay(15);
}
