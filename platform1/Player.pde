abstract class Player {
  PVector position,velocity; // PVector contains two floats, x and y

  Boolean isOnGround; // used to keep track of whether the player is on the ground. useful for control and animation.
  Boolean facingRight; // used to keep track of which direction the player last moved in. used to flip player image.
  int animDelay; // countdown timer between animation updates
  int animFrame; // keeps track of which animation frame is currently shown for the player
  
  Player() { // constructor, gets called automatically when the Player instance is created
    isOnGround = false;
    facingRight = true;
    position = new PVector();
    velocity = new PVector();
    reset();
  }
  
  void reset() {
    animDelay = 0;
    animFrame = 0;
    velocity.x = 0;
    velocity.y = 0;
  }
    
  abstract void inputCheck();
  
  abstract void checkForWallBumping();

  abstract void checkForFalling();

  void move() {
    position.add(velocity);
    
    checkForWallBumping();
    
    checkForFalling();
  }
  
  /*
  void checkForPlayerBumping(){ //so that the players won't trample each other
    int thomasWidth = thomas.width; // think of image size of player standing as the player's physical size
    int thomasHeight = thomas.height;
    int wallProbeDistance = int(thomasWidth*0.2);
    int ceilingProbeDistance = int(thomasHeight*0.95);
    
    // used as probes to detect running into walls, ceiling
    PVector leftSideHigh,rightSideHigh,leftSideLow,rightSideLow,topSide;
     leftSideHigh = new PVector();
     rightSideHigh = new PVector();
     leftSideLow = new PVector();
     rightSideLow = new PVector();
     topSide = new PVector();
 
     // update wall probes
     leftSideHigh.x = leftSideLow.x = position.x - wallProbeDistance; // left edge of player
     rightSideHigh.x = rightSideLow.x = position.x + wallProbeDistance; // right edge of player
     leftSideLow.y = rightSideLow.y = position.y-0.2*thomasHeight; // shin high
     leftSideHigh.y = rightSideHigh.y = position.y-0.8*thomasHeight; // shoulder high
 
     topSide.x = position.x; // center of player
     topSide.y = position.y-ceilingProbeDistance; // top of guy
  }
  */

  
  abstract void draw();
}