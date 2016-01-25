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
  
  //abstract void checkForPlayerBumping(Player p2);

  void checkForPlayerBumping(){
  
    int chrisWidth = chris.width; // think of image size of player standing as the player's physical size
    int chrisHeight = chris.height;
    int chriswallProbeDistance = int(chrisWidth*0.5);
    PVector chrisleftSideHigh = new PVector();
    PVector chrisrightSideHigh = new PVector();
    PVector chrisleftSideLow = new PVector();
    PVector chrisrightSideLow = new PVector();
    PVector christopSide = new PVector();
    PVector chrisbottomSide = new PVector();

  // update wall probes
  chrisleftSideHigh.x = chrisleftSideLow.x = theChris.getPosX() - chriswallProbeDistance; // left edge of player
  chrisrightSideHigh.x = chrisrightSideLow.x = theChris.getPosX() + chriswallProbeDistance; // right edge of player
  chrisleftSideLow.y = chrisrightSideLow.y = theChris.getPosY(); // shin high
  chrisleftSideHigh.y = chrisrightSideHigh.y = theChris.getPosY()-chrisHeight; // shoulder high

  christopSide.x = chrisbottomSide.x = theChris.getPosX(); // center of player
  christopSide.y = theChris.getPosY()-chrisHeight; // top of guy
  chrisbottomSide.y = theChris.getPosY()+chrisHeight;
  
  int thomasWidth = thomas.width; // think of image size of player standing as the player's physical size
  int thomasHeight = thomas.height;
  int thomaswallProbeDistance = int(thomasWidth*0.5);
  PVector thomasleftSideHigh = new PVector();
  PVector thomasrightSideHigh = new PVector();
  PVector thomasleftSideLow = new PVector();
  PVector thomasrightSideLow = new PVector();
  PVector thomastopSide = new PVector();
  PVector thomasbottomSide = new PVector();

  // update wall probes
  thomasleftSideHigh.x = thomasleftSideLow.x = theThomas.getPosX() - thomaswallProbeDistance; // left edge of player
  thomasrightSideHigh.x = thomasrightSideLow.x = theThomas.getPosX() + thomaswallProbeDistance; // right edge of player
  thomasleftSideLow.y = thomasrightSideLow.y = theThomas.getPosY(); // shin high
  thomasleftSideHigh.y = thomasrightSideHigh.y = theThomas.getPosY()-thomasHeight; // shoulder high

  thomastopSide.x = thomasbottomSide.x = theThomas.getPosX(); // center of player
  thomastopSide.y = theThomas.getPosY()-thomasHeight; // top of guy
  thomasbottomSide.y = theThomas.getPosY()+thomasHeight;
  
  // the following conditionals just check for collisions with each bump probe
  // depending upon which probe has collided, we push the player back the opposite direction
  
  //topside
  if(christopSide.y <= thomasbottomSide.y && chrisbottomSide.y <= thomasbottomSide.y + chrisHeight &&
    chrisleftSideLow.x >= thomasleftSideLow.x - chrisWidth && chrisrightSideLow.x <= thomasrightSideLow.x + chrisWidth) {
    /*
    if(theChris.getPosY() <= theThomas.getPosY()){
      theChris.setPosX(theChris.getPosX() - theChris.getVelocityX());
      theChris.setPosY(theChris.getPosY() - theChris.getVelocityY());
      theChris.resetVelocity();
    } else {
    */
      theChris.setPosY(thomasbottomSide.y + chriswallProbeDistance);
      if(theChris.getVelocityY() < 0){
        theChris.resetVelocityY();
      }
    //}
  }
  
  //bottomSide
  if(chrisbottomSide.y >= thomastopSide.y && christopSide.y >= thomastopSide.y - chrisHeight &&
    chrisleftSideLow.x >= thomasleftSideLow.x - chrisWidth && chrisrightSideLow.x <= thomasrightSideLow.x + chrisWidth) {
    /*
    if(theChris.getPosY() <= theThomas.getPosY()){
      theChris.setPosX(theChris.getPosX() - theChris.getVelocityX());
      theChris.setPosY(theChris.getPosY() - theChris.getVelocityY());
      theChris.resetVelocity();
    } else {
    */
      theChris.setPosY(thomastopSide.y - chriswallProbeDistance);
      if(theChris.getVelocityY() < 0){
        theChris.resetVelocityY();
      }
    //}
  }
  
  //left side low matching
  if(chrisleftSideLow.x <= thomasrightSideLow.x && chrisrightSideLow.x <= thomasrightSideLow.x + chrisWidth &&
    chrisleftSideHigh.y >= thomastopSide.y && chrisleftSideLow.y <= thomasbottomSide.y) {
    theChris.setPosX(thomasrightSideHigh.x+chriswallProbeDistance);
    if(theChris.getVelocityX() < 0) {
      theChris.setPosX(theChris.getPosX() - theChris.getVelocityX());
      theChris.setPosY(theChris.getPosY() - theChris.getVelocityY());
      theChris.resetVelocity();
    }
  }
 
 // left side high
  if(chrisleftSideLow.x <= thomasrightSideLow.x && chrisrightSideLow.x <= thomasrightSideLow.x + chrisWidth &&
    chrisleftSideHigh.y >= thomastopSide.y && chrisleftSideLow.y <= thomasbottomSide.y ) {
    theChris.setPosX(thomasrightSideHigh.x+chriswallProbeDistance);
    if(theChris.getVelocityX() < 0) {
      theChris.setPosX(theChris.getPosX() - theChris.getVelocityX());
      theChris.setPosY(theChris.getPosY() - theChris.getVelocityY());
      theChris.resetVelocityX();
      theChris.resetVelocityY();
    }
  }
 
 // right side low
  if(chrisrightSideLow.x >= thomasleftSideLow.x && chrisleftSideLow.x >= thomasleftSideLow.x - chrisWidth &&
    chrisrightSideHigh.y >= thomastopSide.y && chrisrightSideLow.y <= thomasbottomSide.y) {
    theChris.setPosX(thomasleftSideHigh.x-chriswallProbeDistance);
    if(theChris.getVelocityX() > 0) {
      theChris.setPosX(theChris.getPosX() - theChris.getVelocityX());
      theChris.setPosY(theChris.getPosY() - theChris.getVelocityY());
      theChris.resetVelocityX();
      theChris.resetVelocityY();
    }
  }
 
 // right side high
  if(chrisrightSideLow.x >= thomasleftSideLow.x && chrisleftSideLow.x >= thomasleftSideLow.x - chrisWidth &&
    chrisrightSideHigh.y >= thomastopSide.y && chrisrightSideLow.y <= thomasbottomSide.y) {
    theChris.setPosX(thomasleftSideHigh.x-chriswallProbeDistance);
    if(theChris.getVelocityX() > 0) {
      theChris.setPosX(theChris.getPosX() - theChris.getVelocityX());
      theChris.setPosY(theChris.getPosY() - theChris.getVelocityY());
      theChris.resetVelocityX();
      theChris.resetVelocityY();
    }
  }
  
  /*
  if(((theChris.getPosY() > theThomas.getPosY() - thomas.height && theThomas.getPosY() > theChris.getPosY()) ||
  (theThomas.getPosY() > theChris.getPosY() - chris.height && theChris.getPosY() > theThomas.getPosY())) &&
  (abs(theChris.getPosX() - theThomas.getPosX()) < 0.5*(thomas.width + chris.width))){
    theChris.setPosX(theChris.getPosX() - theChris.getVelocityX());
    theChris.setPosY(theChris.getPosY() - theChris.getVelocityY());
    theChris.resetVelocity();
    theChris.isOnGround = true;
  }
  */
  
  }

  
  void move() {
    position.add(velocity);
    
    checkForWallBumping();
    
    checkForPlayerBumping();
    
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