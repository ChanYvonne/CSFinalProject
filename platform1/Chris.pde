class Chris extends Player {
  
  final float JUMP_POWER = 10.0; // how hard the player jolts upward on jump
  final float RUN_SPEED = 5.0; // force of player movement on ground, in pixels/cycle
  final float AIR_RUN_SPEED = 2.0; // like run speed, but used for control while in the air
  final float SLOWDOWN_PERC = 0.6; // friction from the ground. multiplied by the x speed each frame.
  final float AIR_SLOWDOWN_PERC = 0.85; // resistance in the air, otherwise air control enables crazy speeds
  final float RUN_ANIMATION_DELAY = 3; // how many game cycles pass between animation updates?
  final float TRIVIAL_SPEED = 1.0; // if under this speed, the player is drawn as standing still
  
  Chris() { // constructor, gets called automatically when the Thomas instance is created
    super();
  }
  
  void checkForFalling() {
    // If we're standing on an empty tile or end tile, we're not standing on anything. Fall!
    if(theWorld.worldSquareAt(position)==World.TILE_EMPTY ||
       theWorld.worldSquareAt(position)==World.TILE_END_CHRIS){
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
  
  /*
   || 
        theWorld.bottomOfSquare(position) == theWorld.topOfSquare(theChris.position) ||
        theWorld.topOfSquare(position) == theWorld.bottomOfSquare(theChris.position) ||
        theWorld.leftOfSquare(position) == theWorld.rightOfSquare(theChris.position) ||
        theWorld.rightOfSquare(position) == theWorld.leftOfSquare(theChris.position)
  */

  void checkForWallBumping() {
    int chrisWidth = chris.width; // think of image size of player standing as the player's physical size
    int chrisHeight = chris.height;
    int wallProbeDistance = int(chrisWidth*0.3);
    int ceilingProbeDistance = int(chrisHeight*0.95);
    
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
    
    // used as probes to detect running into walls, ceiling
    PVector leftSideHigh = new PVector();
    PVector rightSideHigh = new PVector();
    PVector leftSideLow = new PVector();
    PVector rightSideLow = new PVector();
    PVector topSide = new PVector();

    // update wall probes
    leftSideHigh.x = leftSideLow.x = position.x - wallProbeDistance; // left edge of player
    rightSideHigh.x = rightSideLow.x = position.x + wallProbeDistance; // right edge of player
    leftSideLow.y = rightSideLow.y = position.y-0.2*chrisHeight; // shin high
    leftSideHigh.y = rightSideHigh.y = position.y-0.8*chrisHeight; // shoulder high

    topSide.x = position.x; // center of player
    topSide.y = position.y-ceilingProbeDistance; // top of guy
    
    // the following conditionals just check for collisions with each bump probe
    // depending upon which probe has collided, we push the player back the opposite direction
    
    if( theWorld.worldSquareAt(topSide)==World.TILE_SOLID) {
      if(theWorld.worldSquareAt(position)==World.TILE_SOLID) {
        position.sub(velocity);
        velocity.x=0.0;
        velocity.y=0.0;
      } else {
        position.y = theWorld.bottomOfSquare(topSide)+ceilingProbeDistance;
        if(velocity.y < 0) {
          velocity.y = 0.0;
        }
      }
    }
    
    if( theWorld.worldSquareAt(leftSideLow)==World.TILE_SOLID) {
      position.x = theWorld.rightOfSquare(leftSideLow)+wallProbeDistance;
      if(velocity.x < 0) {
        velocity.x = 0.0;
      }
    }
   
    if( theWorld.worldSquareAt(leftSideHigh)==World.TILE_SOLID) {
      position.x = theWorld.rightOfSquare(leftSideHigh)+wallProbeDistance;
      if(velocity.x < 0) {
        velocity.x = 0.0;
      }
    }
   
    if( theWorld.worldSquareAt(rightSideLow)==World.TILE_SOLID) {
      position.x = theWorld.leftOfSquare(rightSideLow)-wallProbeDistance;
      if(velocity.x > 0) {
        velocity.x = 0.0;
      }
    }
   
    if( theWorld.worldSquareAt(rightSideHigh)==World.TILE_SOLID) {
      position.x = theWorld.leftOfSquare(rightSideHigh)-wallProbeDistance;
      if(velocity.x > 0) {
        velocity.x = 0.0;
      }
    }
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

  void draw() {
    int chrisWidth = chris.width;
    int chrisHeight = chris.height;
      
    if(velocity.x<-TRIVIAL_SPEED) {
      facingRight = false;
    } else if(velocity.x>TRIVIAL_SPEED) {
      facingRight = true;
    }
    
    pushMatrix(); // lets us compound/accumulate translate/scale/rotate calls, then undo them all at once
    translate(position.x,position.y);
    if(facingRight==false) {
      scale(-1,1); // flip horizontally by scaling horizontally by -100%
    }
    translate(-chrisWidth/2,-chrisHeight); // drawing images centered on character's feet
    image(chris, 0, 0);
    popMatrix(); // undoes all translate/scale/rotate calls since the pushMatrix earlier in this function
  }
}