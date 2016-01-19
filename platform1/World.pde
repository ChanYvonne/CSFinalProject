 class World {
  static final int TILE_EMPTY = 0;
  static final int TILE_SOLID = 1;
  static final int TILE_START_THOMAS = 4; // the players start where these are placed
  static final int TILE_START_CHRIS = 3;
  static final int TILE_END_THOMAS = 5; // this is where the ends are (white rectangle)
  static final int TILE_END_CHRIS = 6;
  
  static final int GRID_UNIT_SIZE = 60; // size, in pixels, of each world unit square
  // if the above number becomes too small, how the player's wall bumping is detected may need to be updated

  // these next 2 numbers need to match the dimensions of the example level grid below
  static final int GRID_UNITS_WIDE = 37;
  static final int GRID_UNITS_TALL = 12;

  int[][] worldGrid = new int[GRID_UNITS_TALL][GRID_UNITS_WIDE]; // the game checks this one during play
  
  // the game copies this into worldGrid each reset
  int[][] start_Grid = { {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
                         {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
                         {1, 1, 1, 1, 0, 0, 1, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
                         {0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 1, 1, 1, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
                         {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
                         {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0},
                         {0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0},
                         {0, 3, 4, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 1, 1, 0, 0},
                         {1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
                         {1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
                         {1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6, 1, 5, 0},
                         {1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1}};
 /* int[][] start_Grid = { {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
                         {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
                         {1, 1, 1, 1, 0, 0, 1, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
                         {0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 1, 1, 1, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
                         {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
                         {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0},
                         {0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0},
                         {0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 1, 1, 0, 0},
                         {0, 3, 4, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
                         {1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
                         {1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6, 1, 5, 0},
                         {1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1}};
  */
  // try changing numbers in that grid to make the level different! Look for the "static final int TILE_" lines
  // up above in this same file for a key of what each number corresponds to.  
  World() { // this gets called when World is created.
  }
  
  /*
  //returns coordinates of Player's starting point
  int yToBegin(int[][] start_Grid) {
    int ycor = 0;
    for (int i = 0; i <start_Grid.length; i++){
      for (int x = 0; x < start_Grid[i].length; x++){
        if (start_Grid[i][x] == 4){
          ycor = i;
        }
      }
    }
    return ycor;
  }
  int xToBegin(int[][] start_Grid) {
    int xcor = 0;
    for (int i = 0; i <start_Grid.length; i++){
      for (int x = 0; x < start_Grid[i].length; x++){
        if (start_Grid[i][x] == 4){
          xcor = x;
        }
      }
    }
    return xcor;
  }
  */
  float tempGRID_UNIT_SIZE(){
    return (float)(GRID_UNIT_SIZE);  
  }

  // returns what type of tile is at a given pixel coordinate
  int worldSquareAt(PVector thisPosition) {
    float gridSpotX = thisPosition.x/GRID_UNIT_SIZE;
    float gridSpotY = thisPosition.y/GRID_UNIT_SIZE;
  
    // first a boundary check, to avoid looking outside the grid
    // if check goes out of bounds, treat it as a solid tile (wall)
    if(gridSpotX<0) {
      return TILE_SOLID; 
    }
    if(gridSpotX>=GRID_UNITS_WIDE) {
      return TILE_SOLID; 
    }
    if(gridSpotY<0) {
      return TILE_SOLID; 
    }
    if(gridSpotY>=GRID_UNITS_TALL) {
      return TILE_SOLID;
    }
    
    return worldGrid[int(gridSpotY)][int(gridSpotX)];
  }
  
  // changes the tile at a given pixel coordinate to be a new tile type
  void setSquareAtToThis(PVector thisPosition, int newTile) {
    int gridSpotX = int(thisPosition.x/GRID_UNIT_SIZE);
    int gridSpotY = int(thisPosition.y/GRID_UNIT_SIZE);
  
    if(gridSpotX<0 || gridSpotX>=GRID_UNITS_WIDE || 
       gridSpotY<0 || gridSpotY>=GRID_UNITS_TALL) {
      return; // can't change grid units outside the grid
    }
    
    worldGrid[gridSpotY][gridSpotX] = newTile;
  }
  
  boolean deathSquare(PVector thisPosition){ //checks if player will die at this square 
    int gridSpotY = int(thisPosition.y/GRID_UNIT_SIZE);
    return gridSpotY == start_Grid.length;
  }
  
  
  // these helper functions help us correct for the player moving into a world tile
  float topOfSquare(PVector thisPosition) {
    int thisY = int(thisPosition.y);
    thisY /= GRID_UNIT_SIZE;
    return float(thisY*GRID_UNIT_SIZE);
  }
  float bottomOfSquare(PVector thisPosition) {
    if(thisPosition.y<0) {
      return 0;
    }
    return topOfSquare(thisPosition)+GRID_UNIT_SIZE;
  }
  float leftOfSquare(PVector thisPosition) {
    int thisX = int(thisPosition.x);
    thisX /= GRID_UNIT_SIZE;
    return float(thisX*GRID_UNIT_SIZE);
  }
  float rightOfSquare(PVector thisPosition) {
    if(thisPosition.x<0) {
      return 0;
    }
    return leftOfSquare(thisPosition)+GRID_UNIT_SIZE;
  }
  
  //helps ensure players cannot trample other players
  float bottomOfPlayer(Player P1){
    return P1.position.y + theWorld.tempGRID_UNIT_SIZE();
  }
  
  float topOfPlayer(Player P1){
    return P1.position.y;
  }
  
  float leftOfPlayer(Player P1){
    return P1.position.x;
  }
  
  float rightOfPlayer(Player P1){
    return P1.position.x + theWorld.tempGRID_UNIT_SIZE();
  }
  
  void reload() {
    
    for(int i=0;i<GRID_UNITS_WIDE;i++) {
      for(int ii=0;ii<GRID_UNITS_TALL;ii++) {
        if(start_Grid[ii][i] == TILE_START_THOMAS) { // player start position
          worldGrid[ii][i] = TILE_EMPTY; // put an empty tile in that spot
  
          // then update the player spot to the center of that tile
          theThomas.position.x = i*GRID_UNIT_SIZE+(GRID_UNIT_SIZE/2);
          theThomas.position.y = ii*GRID_UNIT_SIZE+(GRID_UNIT_SIZE/2);
        } else {
          worldGrid[ii][i] = start_Grid[ii][i];
        }
      }
    }
    
    for(int i=0;i<GRID_UNITS_WIDE;i++) {
      for(int ii=0;ii<GRID_UNITS_TALL;ii++) {
        if(start_Grid[ii][i] == TILE_START_CHRIS) { // player start position
          worldGrid[ii][i] = TILE_EMPTY; // put an empty tile in that spot
  
          // then update the player spot to the center of that tile
          theChris.position.x = i*GRID_UNIT_SIZE+(GRID_UNIT_SIZE/2);
          theChris.position.y = ii*GRID_UNIT_SIZE+(GRID_UNIT_SIZE/2);
        } else {
          worldGrid[ii][i] = start_Grid[ii][i];
        }
      }
    }
    
  }
  
  void render() { // draw the world
    background(209);
    
    for(int i=0;i<GRID_UNITS_WIDE;i++) { // for each column
      for(int ii=0;ii<GRID_UNITS_TALL;ii++) { // for each tile in that column
        switch(worldGrid[ii][i]) { // check which tile type it is
          case TILE_SOLID:
            stroke(0); // faint dark outline. set to 0 (black) to remove entirely.
            fill(0); // black
            break;
          case TILE_END_THOMAS:
            stroke(255);
            fill(255,225,222);
            break;
          case TILE_END_CHRIS:
            stroke(255);
            fill(255,201,157);
            break;
          default:
            stroke(209); // faint light outline. set to 209 (same gray as background) to remove entirely.
            fill(209); // gray
            break;
        }
        // then draw a rectangle
        rect(i*GRID_UNIT_SIZE,ii*GRID_UNIT_SIZE, // x,y of top left corner to draw rectangle
             GRID_UNIT_SIZE-1,GRID_UNIT_SIZE-1); // width, height of rectangle
        
      }
    }
  }
}