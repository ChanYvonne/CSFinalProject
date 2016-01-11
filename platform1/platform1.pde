// for storing and referencing animation frames for the player character
PImage thomas;


// we use this to track how far the camera has scrolled left or right
float cameraOffsetX;

Player thePlayer = new Player();
World theWorld = new World();
Keyboard theKeyboard = new Keyboard();

PFont font;

// we use these for keeping track of how long player has played
int gameStartTimeSec, gameCurrentTimeSec;

// by adding this to the player's y velocity every frame, we get gravity
final float GRAVITY_POWER = 0.5; // try making it higher or lower!

void setup() { // called automatically when the program starts
  size(1000,710); // how large the window/screen is for the game

  font = loadFont("Avenir-Oblique-20.vlw");

  thomas = loadImage("thomas.png");

  cameraOffsetX = 0.0;
  frameRate(24); // this means draw() will be called 24 times per second

  resetGame(); // sets up player, game level, and timer
}

void resetGame() {
  // multiple levels could be supported by copying in a different start grid

  thePlayer.reset(); // reset everything about the player

  theWorld.reload(); // reset world map

  // reset timer in corner
  gameCurrentTimeSec = gameStartTimeSec = millis()/1000; // dividing by 1000 to turn milliseconds into seconds
}

Boolean gameWon() { // checks whether player has gotten to white rectangle
  PVector centerOfPlayer;
  // (remember that "position" is keeping track of bottom center of player)
  centerOfPlayer = new PVector(thePlayer.position.x, thePlayer.position.y-thomas.height/2);

  return (theWorld.worldSquareAt(centerOfPlayer)==5);
}

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
  // think of it as "total width of the game world" (World.GRID_UNITS_WIDE*World.GRID_UNIT_SIZE)
  // minus "width of the screen/window" (width)

  cameraOffsetX = thePlayer.position.x-width/2;
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

  thePlayer.inputCheck();
  thePlayer.move();
  thePlayer.draw();

  popMatrix(); // undoes the translate function from earlier in draw()

  if (focused == false) { // does the window currently not have keyboard focus?
    textAlign(CENTER);
    outlinedText("Click this area to play.\n\nUse arrows to move.\nSpacebar to jump.", width/2, height-90);
  } else {
    textAlign(RIGHT);
    if (gameWon() == false) { // stop updating timer after player finishes
      gameCurrentTimeSec = millis()/1000; // dividing by 1000 to turn milliseconds into seconds
    }
    int minutes = (gameCurrentTimeSec-gameStartTimeSec)/60;
    int seconds = (gameCurrentTimeSec-gameStartTimeSec)%60;
    if (seconds < 10) { // pad the "0" into the tens position
      outlinedText(minutes +":0"+seconds, width-8, height-10);
    } else {
      outlinedText(minutes +":"+seconds, width-8, height-10);
    }

    if (gameWon()) {
      textAlign(CENTER);
      outlinedText("You have finished the level!\nPress R to Reset.", width/2, height/2-12);
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