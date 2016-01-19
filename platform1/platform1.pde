// for storing and referencing animation frames for the player character
PImage thomas;
PImage chris;
PImage cursor;

// we use this to track how far the camera has scrolled left or right
float cameraOffsetX;

Thomas theThomas = new Thomas();
World theWorld = new World();
Keyboard theKeyboard = new Keyboard();
Chris theChris = new Chris();
Player currentPlayer = theThomas;

PFont font;

// we use these for keeping track of how long player has played
int levelStartTimeSec, levelCurrentTimeSec;
/////////''/
// by adding this to the player's y velocity every frame, we get gravity
final float GRAVITY_POWER = 0.5; // try making it higher or lower!

void setup() { // called automatically when the program starts
  size(1000,721); // how large the window/screen is for the level

  font = loadFont("Avenir-Oblique-20.vlw");

  thomas = loadImage("thomas.png");
  chris = loadImage("chris.png");
  cursor = loadImage("cursor.png");
  
  

  cameraOffsetX = 0.0;
  frameRate(24); // this means draw() will be called 24 times per second

  resetLevel(); // sets up player, level level, and timer
}

void resetLevel() {
  // multiple levels could be supported by copying in a different start grid

  theThomas.reset(); // reset everything about the player
  theChris.reset();

  theWorld.reload(); // reset world map

  // reset timer in corner
  levelCurrentTimeSec = levelStartTimeSec = millis()/1000; // dividing by 1000 to turn milliseconds into seconds
}

void switchPlayer(){ //changes the control of the player chronologically
  if (currentPlayer == theThomas){
    currentPlayer = theChris;
  }else if (currentPlayer == theChris){
    currentPlayer = theThomas;
  }
}

Boolean levelWonThomas() { // checks whether player has gotten to white rectangle
  PVector centerOfPlayer;
  // (remember that "position" is keeping track of bottom center of player)
  centerOfPlayer = new PVector(theThomas.position.x, theThomas.position.y-thomas.height/2);

  return (theWorld.worldSquareAt(centerOfPlayer)==5);
}

Boolean levelWonChris() { // checks whether player has gotten to white rectangle
  PVector centerOfPlayer;
  // (remember that "position" is keeping track of bottom center of player)
  centerOfPlayer = new PVector(theChris.position.x, theChris.position.y-chris.height/2);

  return (theWorld.worldSquareAt(centerOfPlayer)==6);
}

Boolean levelLostThomas(){ // checks whether player has fallen in the cracks aka died
  PVector bottomOfPlayer;
  bottomOfPlayer = new PVector(theThomas.position.x, theThomas.position.y-thomas.height);
  return theWorld.deathSquare(theThomas.position); 
}

Boolean levelLostChris(){ // checks whether player has fallen in the cracks aka died
  PVector bottomOfPlayer;
  bottomOfPlayer = new PVector(theChris.position.x, theChris.position.y-chris.height);
  return theWorld.deathSquare(theChris.position); 
}

/*
void checkForPlayerBumping(){  
  if(((theChris.getPosY() >= theThomas.getPosY() - thomas.height && theThomas.getPosY() >= theChris.getPosY()) ||
  (theThomas.getPosY() >= theChris.getPosY() - chris.height && theChris.getPosY() >= theThomas.getPosY())) &&
  (abs(theChris.getPosX() - theThomas.getPosX()) <= 0.5*(thomas.width + chris.width))){
    theChris.resetVelocity();
    theThomas.resetVelocity();
  }
}
*/

void outlinedText(String sayThis, float atX, float atY) {
  textFont(font); // use the font we loaded
  fill(0); // white for the upcoming text, drawn in each direction to make outline
  text(sayThis, atX-1, atY);
  text(sayThis, atX+1, atY);
  text(sayThis, atX, atY-1);
  text(sayThis, atX, atY+1);
  fill(255); // white for this next text, in the middle
  text(sayThis, atX, atY);
}

void updateCameraPosition() {
  int rightEdge = World.GRID_UNITS_WIDE*World.GRID_UNIT_SIZE-width;
  // the left side of the camera view should never go right of the above number
  // think of it as "total width of the level world" (World.GRID_UNITS_WIDE*World.GRID_UNIT_SIZE)
  // minus "width of the screen/window" (width)
  if (currentPlayer == theThomas){
    cameraOffsetX = theThomas.position.x-width/2;
  }else if (currentPlayer == theChris){
    cameraOffsetX = theChris.position.x-width/2;
  }
  if (cameraOffsetX < 0) {
    cameraOffsetX = 0;
  }

  if (cameraOffsetX > rightEdge) {
    cameraOffsetX = rightEdge;
  }
}

void draw() { // called automatically, 24 times per second because of setup()'s call to frameRate(24)
  pushMatrix(); // lets us easily undo the upcoming translate call
  translate(-cameraOffsetX, 0.0); // affects all upcoming graphics calls, until popMatrix

  updateCameraPosition();

  theWorld.render();
    
  if (levelLostThomas() == false || levelLostChris() == false){
    if (currentPlayer == theThomas){
      image(cursor, theThomas.position.x- 0.3*thomas.width, theThomas.position.y - 1.4*thomas.height);
      theThomas.inputCheck();
      theThomas.move();
      
    }
    if (currentPlayer == theChris){
      image(cursor, theChris.position.x-0.3*chris.width, theChris.position.y - 1.5*chris.height);
      theChris.inputCheck();
      theChris.move();
    }
    theThomas.draw();
    theChris.draw();
  }
  
  popMatrix(); // undoes the translate function from earlier in draw()

  if (focused == false) { // does the window currently not have keyboard focus?
    textAlign(CENTER);
    outlinedText("Click this area to play.\n\nUse arrows to move.\nSpacebar to jump.\nQ to switch characters.", width/2, height-120);
  } else {
    textAlign(RIGHT);
    if (levelWonThomas() == false && levelWonChris() == false &&
        (levelLostThomas() == false || levelLostChris() == false)) { // stop updating timer after player finishes
      levelCurrentTimeSec = millis()/1000; // dividing by 1000 to turn milliseconds into seconds
    }
    int minutes = (levelCurrentTimeSec-levelStartTimeSec)/60;
    int seconds = (levelCurrentTimeSec-levelStartTimeSec)%60;
    if (seconds < 10) { // pad the "0" into the tens position
      outlinedText(minutes +":0"+seconds, width-8, height-10);
    } else {
      outlinedText(minutes +":"+seconds, width-8, height-10);
    }

    if (levelWonThomas() && levelWonChris()) {
      textAlign(CENTER);
      outlinedText("You have finished the level!\nPress R to Reset.", width/2, height/2-12);
    }
    
    if (levelLostThomas() && levelLostChris()) {
      textAlign(CENTER);
      outlinedText("You have lost this level!\nPress R to Reset and try again.", width/2, height/2-12);
    }
  }
}

void keyPressed() {
  theKeyboard.pressKey(key, keyCode);
}

void keyReleased() {
  theKeyboard.releaseKey(key, keyCode);
}

void stop() { // automatically called when program exits.
  super.stop(); // tells program to continue doing its normal ending activity
}