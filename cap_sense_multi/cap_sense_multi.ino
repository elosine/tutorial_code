#include <CapacitiveSensor.h>

CapacitiveSensor   cs1 = CapacitiveSensor(6, 7);
CapacitiveSensor   cs2 = CapacitiveSensor(6, 8);
CapacitiveSensor   cs3 = CapacitiveSensoer(6, 9);
boolean cs1g = true;
boolean cs2g = true;
boolean cs3g = true;
void setup() {
  Serial.begin(9600);
}

void loop() {
  
  long cs1v =  cs1.capacitiveSensor(80);
  long cs2v =  cs2.capacitiveSensor(80);
  long cs3v =  cs3.capacitiveSensor(80);
  ////cs1////
  if (cs1g) {
    if (cs1v > 230) {
      cs1g = false;
      Serial.print("cs1:");
      Serial.println(1);
    }
  }
  if (!cs1g) {
    if (cs1v < 60) {
      cs1g = true;
      Serial.print("cs1:");
      Serial.println(0);
    }
  }
  ////cs2////
  if (cs2g) {
    if (cs2v > 230) {
      cs2g = false;
      Serial.print("cs2:");
      Serial.println(1);
    }
  }
  if (!cs2g) {
    if (cs2v < 60) {
      cs2g = true;
      Serial.print("cs2:");
      Serial.println(0);
    }
  }
  ////cs3////
  if (cs3g) {
    if (cs3v > 230) {
      cs3g = false;
      Serial.print("cs3:");
      Serial.println(1);
    }
  }
  if (!cs3g) {
    if (cs3v < 60) {
      cs3g = true;
      Serial.print("cs3:");
      Serial.println(0);
    }
  }

  delay(15);
  
}
