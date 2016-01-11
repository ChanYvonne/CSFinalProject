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

  void checkForFalling() {
    // If we're standing on an empty tile or end tile, we're not standing on anything. Fall!
    if(theWorld.worldSquareAt(position)==World.TILE_EMPTY ||
       theWorld.worldSquareAt(position)==World.TILE_END){
       isOnGround=false;
    }
    
    if(isOnGround==false) { // not on ground?    
      if(theWorld.worldSquareAt(position)==World.TILE_SOLID) { // landed on solid square?
        isOnGround = true;
        position.y = theWorld.topOfSquare(position);
        velocity.y = 0.0;
      } else { // fall
        velocity.y += GRAVITY_POWER;
      }
    }
  }

  void move() {
    position.add(velocity);
    
    checkForWallBumping();
    
    checkForFalling();
  }
  
  abstract void draw();
}