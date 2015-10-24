void setup() {
  // open the serial connection at 
  // 9600 BAUD
  Serial.begin(9600); 
}
 
 
void loop() {
  // store the value read from pin 2
  // into a variable
  int sensorValue = analogRead(2);
  // print that variable over the serial connection
  Serial.println(sensorValue);
  delay(15);
}
