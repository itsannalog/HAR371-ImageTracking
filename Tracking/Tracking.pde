import gab.opencv.*; 
import processing.video.*;
OpenCV cv;
Capture webcam;
ArrayList<Contour> blobs;

float count = 0;
color red = color(235, 64, 52);
color green = color(52, 235, 171);
color blue = color(52, 195, 235);

void setup() {
  size(640,480);
  String[] inputs = Capture.list();
  printArray(inputs);
  cv = new OpenCV(this, width,height);
  webcam = new Capture(this, inputs[1]);
  webcam.start();
}

void draw(){
    blobs();
}

void blobs(){
  if (webcam.available()) {
    // read the webcam and load the frame into OpenCV
    webcam.read();
    cv.loadImage(webcam);
    PImage img = cv.getSnapshot();
    img.filter(BLUR, 3);
    cv.findCannyEdges(20, 75);
    img = cv.getSnapshot();
    image(img, 0,0);
    
    
    int threshold = 100;
    cv.threshold(threshold);
    cv.dilate();
    cv.erode();
    image(cv.getOutput(), 0,0);
    
    blobs = cv.findContours();
    stroke(255,150,0);
    strokeWeight(3);
    float depth = map(blobs.size(), 0, 400, 0, 150);
    if (depth < 50) fill(green);
    else if (depth < 100) fill(red);
    else fill(blue);
    
    for (Contour blob : blobs) {
      
      if (blob.area() < 3000) {
        continue;
      }
      
      beginShape();
      for (PVector pt : blob.getPolygonApproximation().getPoints()) {
        vertex(pt.x, pt.y);
      }
      endShape(CLOSE);
    }
  
  }
}
