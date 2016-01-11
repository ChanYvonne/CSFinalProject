abstract class Player {
  PVector position,velocity; // PVector contains two floats, x and y

  Boolean isOnGround; // used to keep track of whether the player is on the ground. useful for control and animation.
  Boolean facingRight; // used to keep track of which direction the player last moved in. used to flip player image.
  int animDelay; // countdown timer between animation updates
  int animFrame; // keeps track of which animation frame is currently shown for the player
  
  static float JUMP_POWER = 11.0; // how hard the player jolts upward on jump
  static float RUN_SPEED = 5.0; // force of player movement on ground, in pixels/cycle
  static float AIR_RUN_SPEED = 2.0; // like run speed, but used for control while in the air
  static float SLOWDOWN_PERC = 0.6; // friction from the ground. multiplied by the x speed each frame.
  static float AIR_SLOWDOWN_PERC = 0.85; // resistance in the air, otherwise air control enables crazy speeds
  static int RUN_ANIMATION_DELAY = 3; // how many game cycl finales pass between animation updates?
  float TRIVIAL_SPEED; // if under this speed, the player is drawn as standing still
  
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
        isOnGround = false; // mark that the player has left the ground, i.e.cannot jump again for now
      }
    }
  }
  
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