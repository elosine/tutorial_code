#include <CapacitiveSensor.h>

CapacitiveSensor cs1 = CapacitiveSensor(6, 7);
CapacitiveSensor cs2 = CapacitiveSensor(6, 8);
CapacitiveSensor cs3 = CapacitiveSensor(6, 9);
boolean cs1g = true;
boolean cs2g = true;
boolean cs3g = true;

void setup() {
  Serial.begin(9600);
}

void loop() {
  long cs1v = cs1.capacitiveSensor(80);
  long cs2v = cs2.capacitiveSensor(80);
  long cs3v = cs3.capacitiveSensor(80);
  
  ////CS1////
  if (cs1g) {
    if (cs1v > 1000) {
      Serial.print("cs1:");
      Serial.println(cs1v);
      cs1g = false;
    }
  }
  if (!cs1g) {
    if (cs1v < 300) {
      Serial.print("cs1:");
      Serial.println(cs1v);
      cs1g = true;
    }
  }
  
  ////CS2////
  if (cs2g) {
    if (cs2v > 1000) {
      Serial.print("cs2:");
      Serial.println(cs2v);
      cs2g = false;
    }
  }
  if (!cs2g) {
    if (cs2v < 300) {
      Serial.print("cs2:");
      Serial.println(cs2v);
      cs2g = true;
    }
  }
  
  ////CS3////
  if (cs3g) {
    if (cs3v > 1000) {
      Serial.print("cs3:");
      Serial.println(cs3v);
      cs3g = false;
    }
  }
  if (!cs3g) {
    if (cs3v < 300) {
      Serial.print("cs3:");
      Serial.println(cs3v);
      cs3g = true;
    }
  }
  delay(15);

}
