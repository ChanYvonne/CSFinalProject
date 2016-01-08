PShape Thomas;

void setup(){
  size(500,500);
  Thomas = createShape(RECT, 10,10,20,20);
  Thomas.setFill(color(0,0,225));
  Thomas.setStroke(false);
  Thomas.setVisible(true);
}

void draw(){
  shape(Thomas,25,25);
}