# cs50projects
Final submissions for Harvard's CS50 Introduction to Game Development course.
Below are HW-specific notes/logs for reference and noting the modifications made to the source material. All projects are in Lua intended for execution with LOVE2D. Youtube demo links are included at the bottom of each summary.

--- 0: Pong
- Enabled right-side paddle to be AI-controlled, automatically tracking the ball to reflect it
- (no Youtube demo recorded)

--- 1: Flappy Bird
- Randomized vertical gaps between pipes
- Randomized interval at which pipes spawn
- Implemented 3 different medal variants to be awarded to player upon death based on score
- Implemented pause feature
- https://youtu.be/ufAmRaZgQ_w

--- 2: Breakout
- Added a powerup that spawns after enough points earned, and will spawn two more balls upon consumption
- Paddle size now grows if accumulated score reaches a certain amount and shrinks if hearts are lost
- Locked block now spawns randomly and key powerup will only spawn after enough points earned (consumption required to break locked block)
- https://youtu.be/5R8Fee260us

--- 3: Match 3
- Matching tiles now extends the timer at +1 seconds per tile matched
- Base color tiles (no shape variants) are now the only variant in the first level, and shape variants in later levels are worth more points
- Shiny variants now also randomly spawn and will break the entire row if included in a match
- Swapping is now only permitted when it results in a match; if no matches are possible, the board auto-resets
- https://youtu.be/kSlXXCh9s4o

--- 4: Mario
- Player can no longer spawn and drop into empty space (and die)
- Locked block and accompanying key now spawn at random locations in the level, with the key required to be in possession to break the locked block
- Breaking the locked block also spawns the goal post at the end of the level
- Coming into contact with the goal post moves to the next newly generated level, persisting the player's score
- https://youtu.be/3Zbm8s7aqiM

--- 5: Zelda
- Hearts now drop randomly from killed enemies
- Pots will randomly spawn in rooms which the player can pick up (displayed as the player holding the pot above them)
- A held pot can be thrown in the direction the player is facing, and will only break when (a) traveling more than 4 tiles, (b) hitting an enemy, or (c) hitting the room boundary
- A thrown pot will also do damage to enemies upon contact, and break
- https://youtu.be/rQf7_CQF3O0

> Best practice to reduce function redundancies (i.e. consolidate update checks)

--- 6: Angry Birds
- Launched player Alien can now split into three total Aliens midair (if not already collided with anything) by pressing the spacebar
- https://youtu.be/aAN8zPtvVSo

--- 7: Pokemon
- Implemented a Menu to appear after the player's Pokemon levels up, displaying the individual stat increases for it
- https://youtu.be/Vm-0AhfwS7g

--- 8: Helicopter 3D
- Gems now spawn in similarly to Coins, but less frequently and are worth more
- Scroll speed now resets upon restarting the level, instead of retaining speed increases from the previous run (scroll speed increases as the level progresses to provide for difficulty)
- https://youtu.be/EDH365ECvGA

--- 9: Dreadhalls
- Holes will now spawn in a given level map that the player can fall through (and can jump over), usually about 3-4 holes per level
- Falling through a hole will now take the player to a Game Over screen - they can restart from there as well
- The player's cleared level count is now displayed on screen, and will reset to 0 if they fall through a hole
- https://youtu.be/YiQ0rPXif8o

--- 10: Portal
- Created a level for the player to engage with
- Added in an FPSController to allow for player input and level navigation
- Added in a game object (invisible) at the end to act as a trigger zone to end the level
- "You Won" is displayed if the player sets off the above level clear game object
- https://youtu.be/tKUzMKKZIKk

--- 11: Final Project
- Please refer to the folder named "final" for a full README and for the project files!
- https://youtu.be/5XnJV4FXgsg
