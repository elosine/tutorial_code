#include <CapacitiveSensor.h>

CapacitiveSensor   cs23 = CapacitiveSensor(2, 3);
boolean cs23g = true;
void setup() {
  Serial.begin(9600);
}

void loop() {
  long cs23v =  cs23.capacitiveSensor(80);
  if (cs23g) {
    if (cs23v > 230) {
      cs23g = false;
      Serial.println(cs23v);
    }
  }
  if (!cs23g) {
    if (cs23v < 60) {
      cs23g = true;
      Serial.println(cs23v);
    }
  }

  delay(15);
}
