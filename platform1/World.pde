abstract class World {
  
  static final int TILE_EMPTY = 0;
  static final int TILE_SOLID = 1;
  
  // these next 2 numbers need to match the dimensions of the example level grid below
  static final int GRID_UNITS_WIDE = 40;
  static final int GRID_UNITS_TALL = 12;
  
  static final int GRID_UNIT_SIZE = 60; // size, in pixels, of each world unit square
  // if the above number becomes too small, how the player's wall bumping is detected may need to be updated
  
  int[][] worldGrid;
  
 

  // try changing numbers in that grid to make the level different! Look for the "static final int TILE_" lines
  // up above in this same file for a key of what each number corresponds to.  
  World() { // this gets called when World is created.
    worldGrid = new int[GRID_UNITS_TALL][GRID_UNITS_WIDE]; // the game checks this one during play
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
  };
  
  
  boolean deathSquare(PVector thisPosition){ //checks if player will die at this square 
    int gridSpotY = int(thisPosition.y/GRID_UNIT_SIZE);
    return gridSpotY == worldGrid.length;
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
  
  /*
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
  */
  
  abstract void reload();
  
  abstract void render();

}