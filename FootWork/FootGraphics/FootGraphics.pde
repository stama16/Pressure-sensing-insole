PImage bg;
int y;
import processing.serial.*;

int s1;
int s2;
int s3;
int s4;
int s5;
PShader blur;
Serial myPort;  // Create object from Serial class
int val;      // Data received from the serial port
int number=0;
int force;
Blob[] blobs = new Blob[5];
PShape foot;
int sample = 0;  
PrintWriter output;

void setup() {
  frameRate(50);
  size(480, 795);
  colorMode(HSB);
  
  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 9600);
  
  // The background image must be the same size as the parameters
  // into the size() method. In this program, the size of the image
  // is 640 x 360 pixels.
    blobs[0] = new Blob(270-100,100);
    blobs[1] = new Blob(270-100,290);
    blobs[2] = new Blob(375-100,290);
    blobs[3] = new Blob(475-100,320);
    blobs[4] = new Blob(385-100,660);
  
  //bg = loadImage("foot.png");
  //background(bg);
  foot = loadShape("foot.svg");
  
  int m = minute();  // Values from 0 - 59
  int h = hour();    // Values from 0 - 23
  int d = day();
  int mm = month();
  String fileName = "Gait_"+str(mm)+"_"+str(d)+"_"+str(h)+"_"+str(m)+".csv";
  output = createWriter(fileName); 
  output.println("Time, Sample number, Sensor1, Sensor2, Sensor3, Sensor4, Sensor5");
  output.flush(); // Writes the remaining data to the file
  
}

void draw() {
  background(51);
  shape(foot,-100,30,630,790);
  loadPixels();
  for (int x = 50; x < width-50; x++) {
    for (int y = 20; y < height-10; y++) {
      int index = x + y * width;
      float sum = 0;
      for (Blob b : blobs) {
        float d = dist(x, y, b.pos.x, b.pos.y);
        sum += 30 * b.r / d;
      }
      if(pixels[index] >= color(1,1,1))
      {
      pixels[index] = color(sum, 255, 255);
      }
    }
  }
      if ( myPort.available() >= 6) {  // If data is available,
   
    while(myPort.read()!=255);
    
    blobs[0].r = myPort.read();         // read it and store it in val
    blobs[1].r = myPort.read();
    blobs[2].r = myPort.read();
    blobs[3].r = myPort.read();
    blobs[4].r = myPort.read();
    String time = str(millis());
    myPort.clear();
    output.println(time +", "+str(sample)+", "+str(blobs[0].r)+", "+str(blobs[1].r)+", "+str(blobs[2].r)+", "+str(blobs[3].r)+", "+str(blobs[4].r));
    output.flush(); // Writes the remaining data to the file
    
    sample++;
 

  }

  updatePixels();
  println(frameRate);
  for (Blob b : blobs) {
    b.update();
    b.show();
  }
 
  //float d = map(98, 0, 98, 0, 100);
  //float c;
  
  //noStroke();
  //c = map(s1, 0, 98, 0, 255);
  //fill(c, 255-(c), 0);
  //ellipse(270, 130, s1, s1);
  
  //c = map(s2, 0, 98, 0, 255);
  //fill(c, 255-(c), 0);
  //ellipse(270, 270, s2, s2);
  
  //c = map(s3, 0, 98, 0, 255);
  //fill(c, 255-(c), 0);
  //ellipse(370, 270, s3, s3);
  
  //c = map(s4, 0, 98, 0, 255);
  //fill(c, 255-(c), 0);
  //ellipse(475, 300, s4, s4);
  
  //c = map(s5, 0, 98, 0, 255);
  //fill(c, 255-(c), 0);
  //rect(370-(s5/10), 610-(s5/10), s5, s5);
  
  
}
