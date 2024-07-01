# cs50projects
Final submissions for Harvard's CS50 Introduction to Game Development course.
Below are HW-specific notes/logs for reference and noting the modifications made to the source material. All projects are in Lua intended for execution with LOVE2D.

--- 0: Pong
- Enabled right-side paddle to be AI-controlled, automatically tracking the ball to reflect it

--- 1: Flappy Bird
- Randomized vertical gaps between pipes
- Randomized interval at which pipes spawn
- Implemented 3 different medal variants to be awarded to player upon death based on score
- Implemented pause feature

--- 2: Breakout
- Added a powerup that spawns after enough points earned, and will spawn two more balls upon consumption
- Paddle size now grows if accumulated score reaches a certain amount and shrinks if hearts are lost
- Locked block now spawns randomly and key powerup will only spawn after enough points earned (consumption required to break locked block)

--- 3: Match 3
- Matching tiles now extends the timer at +1 seconds per tile matched
- Base color tiles (no shape variants) are now the only variant in the first level, and shape variants in later levels are worth more points
- Shiny variants now also randomly spawn and will break the entire row if included in a match
- Swapping is now only permitted when it results in a match; if no matches are possible, the board auto-resets

--- 4: Mario
- Player can no longer spawn and drop into empty space (and die)
- Locked block and accompanying key now spawn at random locations in the level, with the key required to be in possession to break the locked block
- Breaking the locked block also spawns the goal post at the end of the level
- Coming into contact with the goal post moves to the next newly generated level, persisting the player's score

--- 5: Zelda
- Hearts now drop randomly from killed enemies
- Pots will randomly spawn in rooms which the player can pick up (displayed as the player holding the pot above them)
- A held pot can be thrown in the direction the player is facing, and will only break when (a) traveling more than 4 tiles, (b) hitting an enemy, or (c) hitting the room boundary
- A thrown pot will also do damage to enemies upon contact, and break

> Best practice to reduce function redundancies (i.e. consolidate update checks)
