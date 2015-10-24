

void setup(){
  size(800, 600);
}

void draw(){
  background(0);
  stroke(0, 255, 0);
  strokeWeight(4);
  fill(0, 0, 255);
  //noFill();
  ellipse(width/2, height/2, width, height);
  
 // rectMode(CENTER);
  noStroke();
  fill(255, 255, 0);
  rect(mouseX, mouseY, 40, 40);
  
 // println(frameRate);
  
  stroke(255);
  strokeWeight(2);
  line(200, 300, 400, 300);
  
}

void mousePressed(){
  println("hello");
}

void keyPressed(){
  if(key=='a') println("goodbye");
}
