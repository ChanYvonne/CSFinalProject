class WorldOne extends World{
  static final int TILE_START_THOMAS = 4; // the players start where these are placed
  static final int TILE_END_THOMAS = 5; // this is where the ends are (white rectangle)
 
 // the game copies this into worldGrid each reset
 int[][] start_Grid = { {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
                         {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
                         {0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
                         {1, 1, 1, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
                         {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
                         {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0},
                         {0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0},
                         {0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0},
                         {1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 0, 0, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
                         {1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 0, 0, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
                         {1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 0, 0, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
                         {1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 0, 0, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1}};
                         
  
  WorldOne(){
    super();
    reload();
  }
  
  void reload() {
    
    for(int i=0; i < GRID_UNITS_WIDE; i++) {
      for(int ii=0; ii < GRID_UNITS_TALL; ii++) {
        if(worldGrid[ii][i] == TILE_START_THOMAS) { // player start position
          worldGrid[ii][i] = TILE_EMPTY; // put an empty tile in that spot
  
          // then update the player spot to the center of that tile
          theThomas.position.x = i*GRID_UNIT_SIZE+(GRID_UNIT_SIZE/2);
          theThomas.position.y = ii*GRID_UNIT_SIZE+(GRID_UNIT_SIZE/2);
        } else {
          worldGrid[ii][i] = start_Grid[ii][i];
        }
      }
    }
    
    
  }
  
  void render() { // draw the world
    background(209);
    
    for(int i=0; i < GRID_UNITS_WIDE; i++) { // for each column
      for(int ii=0; ii < GRID_UNITS_TALL; ii++) { // for each tile in that column
        switch(worldGrid[ii][i]) { // check which tile type it is
          case TILE_SOLID:
            stroke(0); // faint dark outline. set to 0 (black) to remove entirely.
            fill(0); // black
            break;
          case TILE_END_THOMAS:
            stroke(255);
            fill(255,118,118);
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