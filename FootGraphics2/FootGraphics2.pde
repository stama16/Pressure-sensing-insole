PImage bg;
int y;
HScrollbar hs1;
HScrollbar hs2;
import processing.serial.*;
Table table;

int [] sensorAvg = new int[5];
int [] sensorAvgCurrent = new int[5];

PShader blur;
Serial myPort;  // Create object from Serial class
int val;      // Data received from the serial port
int number=0;
int force;
Blob[] blobs = new Blob[5];
PShape foot;
int sample = 0;  
PrintWriter output;
int rows;
int newScrollBarPos;
int newScrollBarPos2;

String fileName;

void setup() {
  frameRate(50);
  size(800, 795);
  colorMode(HSB);
  
  selectInput("Select a file to process:", "fileSelected");
  
  while(fileName == null)
  {
   delay(500);
   println("here");
  }
  //String portName = Serial.list()[0];
  //myPort = new Serial(this, portName, 9600);
  //selectInput("Select a file to process:", "fileSelected");

    blobs[0] = new Blob(270-100,100);
    blobs[1] = new Blob(270-100,290);
    blobs[2] = new Blob(375-100,290);
    blobs[3] = new Blob(475-100,320);
    blobs[4] = new Blob(385-100,660);

  foot = loadShape("foot.svg");
  

  hs1 = new HScrollbar(0, height-20, width, 16, 16);
  hs2 = new HScrollbar(0, height-60, width, 16, 16);
  table = loadTable(fileName, "csv");
  println(table.getRowCount() + " total rows in table");
  println(table.getColumnCount());
  rows = table.getRowCount();
  
    textSize(16);
    
    long sum = 0L;
    
    for(int i = 0; i < 5; i++)
    {
    sum = 0L;
    for (TableRow row : table.rows()) {
    sum += int(row.getFloat(i+2));  
    }
    sensorAvg[i] = int(sum/rows);
    }
    
   
}

void draw() {
  background(51);
  frameRate(30);
  shape(foot,-100,30,630,790);
  loadPixels();
  for (int x = 50; x < 480-50; x++) {
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
  
    float pos = hs1.getPos();
    float pos2 = hs2.getPos();
    newScrollBarPos = int(map(pos, 0,width , 1,rows));
    newScrollBarPos2 = int(map(pos2, 0,width , 1,rows));
    
    blobs[0].r = table.getFloat(newScrollBarPos,2);         // read it and store it in val
    blobs[1].r = table.getFloat(newScrollBarPos,3);
    blobs[2].r = table.getFloat(newScrollBarPos,4);
    blobs[3].r = table.getFloat(newScrollBarPos,5);
    blobs[4].r = table.getFloat(newScrollBarPos,6);
    
    
    
    //println(newScrollBarPos);
    //println(blobs[4].r);
    long sum2 = 0L;
    
    for(int i = 0; i < 5; i++)
    {
    sum2 = 0L;
    for (int ii=newScrollBarPos2; ii<=newScrollBarPos; ii++) {
    sum2 += int(table.getFloat(ii,i+2));  
    }
    sensorAvgCurrent[i] = int(sum2/((newScrollBarPos - newScrollBarPos2)+1));
    }

  updatePixels();
  //println(frameRate);
  for (Blob b : blobs) {
    b.update();
    b.show();
    
    hs1.update();
    hs1.display();
    
    hs2.update();
    hs2.display();
    
    
    fill(255);
    text("Average from time " +str((table.getFloat(newScrollBarPos2,0)/1000))+" to time "+"Time"+str((table.getFloat(newScrollBarPos,0)/1000))+"s",440,500);
    text("S1:"+" "+str(sensorAvgCurrent[0])+"N",440,540);
    
    text("S2:"+" "+str(sensorAvgCurrent[1])+"N",440,580);
    
    text("S3:"+" "+str(sensorAvgCurrent[2])+"N",440,620);
    
    text("S4:"+" "+str(sensorAvgCurrent[3])+"N",440,660);
    
    text("S5:"+" "+str(sensorAvgCurrent[4])+"N",440,700);
    

    
  }

}

void fileSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + selection.getAbsolutePath());
    fileName = selection.getAbsolutePath();
  }
}
