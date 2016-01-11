static abstract class Player {
  PVector position,velocity; // PVector contains two floats, x and y

  Boolean isOnGround; // used to keep track of whether the player is on the ground. useful for control and animation.
  Boolean facingRight; // used to keep track of which direction the player last moved in. used to flip player image.
  int animDelay; // countdown timer between animation updates
  int animFrame; // keeps track of which animation frame is currently shown for the player
  
  static final float JUMP_POWER; // how hard the player jolts upward on jump
  static final float RUN_SPEED; // force of player movement on ground, in pixels/cycle
  static final float AIR_RUN_SPEED; // like run speed, but used for control while in the air
  static final float SLOWDOWN_PERC; // friction from the ground. multiplied by the x speed each frame.
  static final float AIR_SLOWDOWN_PERC; // resistance in the air, otherwise air control enables crazy speeds
  static final int RUN_ANIMATION_DELAY; // how many game cycles pass between animation updates?
  static final float TRIVIAL_SPEED; // if under this speed, the player is drawn as standing still
  
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
  
  void inputCheck() {
    // keyboard flags are set by keyPressed/keyReleased in the main .pde
    
    float speedHere = (isOnGround ? RUN_SPEED : AIR_RUN_SPEED);
    float frictionHere = (isOnGround ? SLOWDOWN_PERC : AIR_SLOWDOWN_PERC);
    
    if(theKeyboard.holdingLeft) {
      velocity.x -= speedHere;
    } else if(theKeyboard.holdingRight) {
      velocity.x += speedHere;
    } 
    velocity.x *= frictionHere; // causes player to constantly lose speed
    
    if(isOnGround) { // player can only jump if currently on the ground
      if(theKeyboard.holdingSpace || theKeyboard.holdingUp) { // either up arrow or space bar cause the player to jump
        velocity.y = -JUMP_POWER; // adjust vertical speed
        isOnGround = false; // mark that the player has left the ground, i.e. cannot jump again for now
      }
    }
  }
  
  abstract void checkForWallBumping() {
    /* Because of how we draw the player, "position" is the center of the feet/bottom
     * To detect and handle wall/ceiling collisions, we create 5 additional positions:
     * leftSideHigh - left of center, at shoulder/head level
     * leftSideLow - left of center, at shin level
     * rightSideHigh - right of center, at shoulder/head level
     * rightSideLow - right of center, at shin level
     * topSide - horizontal center, at tip of head
     * These 6 points - 5 plus the original at the bottom/center - are all that we need
     * to check in order to make sure the player can't move through blocks in the world.
     * This works because the block sizes (World.GRID_UNIT_SIZE) aren't small enough to
     * fit between the cracks of those collision points checked.
     */
  };

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