# CSFinalProject

This is a basic one-level platformer game, very similar to the game Thomas Was Alone. There are two characters to control, who must each get to their respective rectangles at the end to finish the level. 
You control the characters using the direction arrow keys on your keyboard. 
The spacebar allows the characters to jump. 
Pressing "Q" allows the user to switch between characters.

1/19/16
Yvonne - began creating a title screen and couldn't get characters not to overlap each other :c

1/20/16
Yvonne - Continued working on title screen
       - Encountered a problem with players, they can't move left/right!
Vandana - still working on character collisions: making the variables used in WallBumping accessible to use for PlayerBumping

1/21/16
Yvonne - Continued working on title screen
       - Can't fix the bug with characters :(
Vandana - still working on character collisions: tried putting it in platform1, Player, Thomas/Chris but running into problems each time (e.g. NullPointerException)
 
1/22/16
Yvonne - Continued looking for the problem with character movement
Vandana - also looking for the problem: why can't characters move laterally?

1/24/16
Vandana - solved problem with character movement, continuing to work on character collisions
Yvonne & Vandana - Worked on character collisions - why is this so much harder than it seems?!?!?!

1/25/16
Vandana - figured out why character collisions aren't working, made some progress in fixing it.  Basically, one character jumps on top of another and recognizes that it should not overlap.  But then checkForWallBumping() executes again and the player no longer recognizes that it should not overlap with the other, because isOnGround gets set to false.  So then it falls, and gets confused because checkForPlayerBumping() tells it it is wrong from all directions.  Not sure how to fix this.