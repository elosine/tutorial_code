void setup() {
Serial.begin(9600);
}

void loop() {
int sensorValue = analogRead(2);
Serial.println(sensorValue);
delay(15);
}
