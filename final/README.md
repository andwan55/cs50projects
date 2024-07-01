# CS50 Final Project: Dungeon 50

This game I designed as part of CS50 Intro to Game Development course is intended to be a hybrid between turn-based and roguelite combat! I took inspiration from DnD mechanics and expanded upon the Zelda assignment in the course, adding new weapons as well as diversifying the enemy attacks. Major changes include:
- Combat is now turn-based with a turn order determined upon entering a new room
- Game states now include: StartState, SelectionState, PlayState, ClearState, and GameOverState (BattleMessageState is more niche)
- An in-combat menu is displayed on your turn to let you choose how to act
- New weapons include: fire sword, poison sword, ice crossbow, and acid crossbow
- Respective effects for the above weapons include: possible instant extra damage, possible extra damage on start of turn, permanently reduced movement, and permanently reduced armor class
- Mechanics inspired by DnD: rolling for initiative per entity, armor class stat baked into entities to determine likelihood of an attack landing, turn-based combat, action / bonus action economy
- New player actions: ranged weapon attack (with one equipped), 
- New major enemies with more health (flash red occasionally) that spawn after 2 rooms have been cleared
- New male and female variants for the player to choose from
- Each enemy is either ranged or melee based, and has accompanying animations for their attack
- New potion item that heals you to full health upon use
- New heart item behavior increases your max health upon pickup
- Pots can be picked up via the Pick Up action, and Thrown
- New Dash action consumes an action but doubles your movement limit for the turn
- A chest now spawns after clearing a room which drops either a weapon or a potion (removes the weapon from loot pool to prevent duplicates)
- The game now shows a Victory screen after 5 rooms have been cleared!

A quick overview / beginner guide: 
- The player can no longer move freely unless out of combat, and has limited movement during their turn (refreshes each turn)
- You have an action and bonus action that is used for your options (Melee, Ranged, Dash, Pick Up, Throw, Potion, and End Turn)
- The player menu has two pages to better display the options, simply use the arrow keys to scroll
- Combat does not end unless all enemies are cleared from the room
- Pots can obstruct your movement, though you can pick them up! Enemies are not blocked by them, though.
- Skeletons, ghosts, and bats all attack in melee range, and slimes + spiders will shoot projectiles at you.
- Your attacks may miss! The enemy's attack also can as well, though your armor class is weighted higher than theirs to give you an advantage.
- If your health drops to 0, you will be sent to the Game Over screen.

Although I utilized assets from CS50's Zelda and Pokemon assignments (graphics/sounds) to build this final project, there are numerous engineering changes that are of my own design. To name a few:
- While entities and the player still operate on a StateMachine, the overall game now functions on a StateStack as I felt it suited this project better.
- There is now a GUI in this project compared to before! Assets were ported from the Pokemon assignment and modified to suit the dimensions / display of the gameplay.
- Instead of realtime combat based on avoiding enemies, the game now functions on a turn order. This is processed mostly in the Room file.
Accomplishing this was really fun albeit complicated, as all of CS50's assignments (besides Pokemon) were realtime based. None were suitable as a reference for a turn-based implementation of gameplay, and thus I developed one of my own which is built into the Room file's update function. Overall, I wanted to add more to the original Zelda assignment's gameplay and change its dynamics, making the player choices feel more impactful and more varied in options. Admittedly, I did also have some additional ideas that I originally intended on building into this project as well, but ran out of time due to the deadline. For reference, they are:
- Longer gameplay overall - currently the game ends at 5 rooms being cleared, but I wanted to double it and add a boss room at the end!
- A boss encounter, complete with a larger mob, more dangerous attacks, and different visuals. The assets are actually still in the graphics folder!
- Boss phases, where smaller trash mobs would spawn after the player reduces the boss' HP to a certain threshold
- Locked boss room which would spawn randomly after enough rooms (~10) have been cleared
- Expand further on weapon gameplay (i.e. a burning enemy exploding upon death)
- Pot variants; I had the idea to add in explosive pots which would explode upon traveling a certain distance from being thrown or directly from being hit with a weapon/projectile
- Shove player bonus action which would move an enemy/pot in range a certain distance
- Key loot item that would drop slightly sooner than the boss room spawning to unlock that room