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
  
  float getPosX(){
    return position.x;
  }
  
  float getPosY(){
    return position.y;
  }
  
  void resetVelocity(){
    velocity.x = 0;
    velocity.y = 0;
  }
  
  void resetVelocityX(){
    velocity.x = 0;
  }
  
  void resetVelocityY(){
    velocity.y = 0;
  }
  
  float getVelocityX(){
    return velocity.x;
  }
  
  float getVelocityY(){
    return velocity.y;
  }
  
  PVector getVelocity(){
    return velocity;
  }
  
  void setPosX(float num){
    position.x = num;
  }
  
  void setPosY(float num){
    position.y = num;
  }
    
  abstract void inputCheck();
  
  abstract void checkForWallBumping();

  abstract void checkForFalling();
  
  void checkForPlayerBumping(){
  
    int chrisWidth = chris.width; // think of image size of player standing as the player's physical size
    int chrisHeight = chris.height;
    int chriswallProbeDistance = int(chrisWidth*0.5);
    PVector chrisleftSideHigh = new PVector();
    PVector chrisrightSideHigh = new PVector();
    PVector chrisleftSideLow = new PVector();
    PVector chrisrightSideLow = new PVector();
    PVector christopSide = new PVector();
  
    // update wall probes
    chrisleftSideHigh.x = chrisleftSideLow.x = theChris.getPosX() - chriswallProbeDistance; // left edge of player
    chrisrightSideHigh.x = chrisrightSideLow.x = theChris.getPosX() + chriswallProbeDistance; // right edge of player
    chrisleftSideLow.y = chrisrightSideLow.y = theChris.getPosY(); // shin high
    chrisleftSideHigh.y = chrisrightSideHigh.y = theChris.getPosY()-chrisHeight; // shoulder high
  
    christopSide.x = theChris.getPosX(); // center of player
    christopSide.y = theChris.getPosY()-chrisHeight; // top of guy
    
    int thomasWidth = thomas.width; // think of image size of player standing as the player's physical size
    int thomasHeight = thomas.height;
    int thomaswallProbeDistance = int(thomasWidth*0.5);
    PVector thomasleftSideHigh = new PVector();
    PVector thomasrightSideHigh = new PVector();
    PVector thomasleftSideLow = new PVector();
    PVector thomasrightSideLow = new PVector();
    PVector thomastopSide = new PVector();
  
    // update wall probes
    thomasleftSideHigh.x = thomasleftSideLow.x = theThomas.getPosX() - thomaswallProbeDistance; // left edge of player
    thomasrightSideHigh.x = thomasrightSideLow.x = theThomas.getPosX() + thomaswallProbeDistance; // right edge of player
    thomasleftSideLow.y = thomasrightSideLow.y = theThomas.getPosY(); // shin high
    thomasleftSideHigh.y = thomasrightSideHigh.y = theThomas.getPosY()-thomasHeight; // shoulder high
  
    thomastopSide.x = theThomas.getPosX(); // center of player
    thomastopSide.y = theThomas.getPosY()-thomasHeight; // top of guy
    
    // the following conditionals just check for collisions with each bump probe
    // depending upon which probe has collided, we push the player back the opposite direction
    
    //left side low of Chris
    if(theChris.getVelocityX() < 0) {
      if(chrisleftSideLow.x <= thomasrightSideLow.x && chrisleftSideLow.y >= thomastopSide.y
      && chrisrightSideLow.x >= thomasleftSideLow.x && chrisleftSideHigh.y <= theThomas.getPosY()) {
      //theChris.setPosX(thomasrightSideHigh.x+chriswallProbeDistance);
        theChris.setPosX(theChris.getPosX() - theChris.getVelocityX());
        theChris.setPosY(theChris.getPosY() - theChris.getVelocityY());
        theChris.resetVelocityX();
        theChris.resetVelocityY();
        theChris.isOnGround = true;
      } else{
        theChris.checkForFalling();
      }
    }
    
    
   // left side high of Chris
    if(theThomas.getVelocityX() > 0) {
      if(chrisrightSideHigh.x >= thomasleftSideLow.x && chrisrightSideHigh.y <= theThomas.getPosY()
      && chrisleftSideLow.x <= thomasrightSideLow.x && chrisleftSideLow.y >= thomastopSide.y) {
        theThomas.setPosX(theThomas.getPosX() - theThomas.getVelocityX());
        theThomas.setPosY(theThomas.getPosY() - theThomas.getVelocityY());
        theThomas.resetVelocityX();
        theThomas.resetVelocityY();
        theThomas.isOnGround = true;
      } else {
        theThomas.checkForFalling();
      }
    }
   
   // right side high of Chris
    if(theThomas.getVelocityX() < 0) {
      if(chrisleftSideHigh.x <= thomasrightSideLow.x && chrisleftSideHigh.y <= theThomas.getPosY()
      && chrisrightSideLow.x >= thomasleftSideLow.x && chrisleftSideLow.y >= thomastopSide.y) {
        theThomas.setPosX(theThomas.getPosX() - theThomas.getVelocityX());
        theThomas.setPosY(theThomas.getPosY() - theThomas.getVelocityY());
        theThomas.resetVelocityX();
        theThomas.resetVelocityY();
        theThomas.isOnGround = true;
      } else{
        theThomas.checkForFalling();
      }
    }
   
   // right side low of Chris
    if(theChris.getVelocityX() > 0) {
      if(chrisrightSideLow.x >= thomasleftSideLow.x && chrisrightSideLow.y >= thomastopSide.y
      && chrisleftSideHigh.x <= thomasrightSideLow.x && chrisleftSideHigh.y <= theThomas.getPosY()) {      
        theChris.setPosX(theChris.getPosX() - theChris.getVelocityX());
        theChris.setPosY(theChris.getPosY() - theChris.getVelocityY());
        theChris.resetVelocityX();
        theChris.resetVelocityY();
        theChris.isOnGround = true;
      } else{
        theChris.checkForFalling();
      }
    }
   
  }

  void move() {
    position.add(velocity);
    checkForPlayerBumping();
    checkForWallBumping();
  }
  
  abstract void draw();
}