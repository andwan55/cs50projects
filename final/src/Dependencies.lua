--
-- libraries
--

Class = require 'lib/class'
Event = require 'lib/knife.event'
push = require 'lib/push'
Timer = require 'lib/knife.timer'

require 'src/Animation'
require 'src/constants'
require 'src/Entity'
require 'src/entity_defs'
require 'src/GameObject'
require 'src/game_objects'
require 'src/Hitbox'
require 'src/Player'
require 'src/StateMachine'
require 'src/Util'

require 'src/world/Doorway'
require 'src/world/Dungeon'
require 'src/world/Room'

require 'src/gui/Menu'
require 'src/gui/Panel'
require 'src/gui/Selection'
require 'src/gui/Textbox'

require 'src/states/BaseState'
require 'src/states/StateStack'

require 'src/states/entity/EntityIdleState'
require 'src/states/entity/EntityWalkState'

require 'src/states/entity/player/PlayerIdleState'
require 'src/states/entity/player/PlayerSwingSwordState'
require 'src/states/entity/player/PlayerShootState'
require 'src/states/entity/player/PlayerWalkState'

require 'src/states/game/GameOverState'
require 'src/states/game/SelectionState'
require 'src/states/game/PlayState'
require 'src/states/game/StartState'
require 'src/states/game/ClearState'
require 'src/states/game/BattleMessageState'

gTextures = {
    ['tiles'] = love.graphics.newImage('graphics/tilesheet.png'),
    ['background'] = love.graphics.newImage('graphics/background.png'),
    ['cursor'] = love.graphics.newImage('graphics/cursor.png'),

    ['character-male-walk'] = love.graphics.newImage('graphics/character_male_walk.png'),
    ['character-female-walk'] = love.graphics.newImage('graphics/character_female_walk.png'),

    ['character-male-swing-sword-normal'] = love.graphics.newImage('graphics/character_male_swing_sword_normal.png'),
    ['character-female-swing-sword-normal'] = love.graphics.newImage('graphics/character_female_swing_sword_normal.png'),
    ['character-male-swing-sword-fire'] = love.graphics.newImage('graphics/character_male_swing_sword_fire.png'),
    ['character-female-swing-sword-fire'] = love.graphics.newImage('graphics/character_female_swing_sword_fire.png'),
    ['character-male-swing-sword-poison'] = love.graphics.newImage('graphics/character_male_swing_sword_poison.png'),
    ['character-female-swing-sword-poison'] = love.graphics.newImage('graphics/character_female_swing_sword_poison.png'),

    ['character-male-shoot-crossbow-ice'] = love.graphics.newImage('graphics/character_male_shoot_crossbow_ice.png'),
    ['character-female-shoot-crossbow-ice'] = love.graphics.newImage('graphics/character_female_shoot_crossbow_ice.png'),
    ['character-male-shoot-crossbow-acid'] = love.graphics.newImage('graphics/character_male_shoot_crossbow_acid.png'),
    ['character-female-shoot-crossbow-acid'] = love.graphics.newImage('graphics/character_female_shoot_crossbow_acid.png'),

    ['character-male-hold'] = love.graphics.newImage('graphics/character_male_pot_walk.png'),
    ['character-female-hold'] = love.graphics.newImage('graphics/character_female_pot_walk.png'),

    ['character-male-lift'] = love.graphics.newImage('graphics/character_male_pot_lift.png'),
    ['character-female-lift'] = love.graphics.newImage('graphics/character_female_pot_lift.png'),

    ['hearts'] = love.graphics.newImage('graphics/hearts.png'),
    ['potion'] = love.graphics.newImage('graphics/potion.png'),
    ['chest'] = love.graphics.newImage('graphics/chest.png'),
    ['key'] = love.graphics.newImage('graphics/key_boss.png'),
    ['pot-explosion'] = love.graphics.newImage('graphics/pot_explosion.png'),

    ['sword-normal'] = love.graphics.newImage('graphics/sword_normal.png'),
    ['sword-fire'] = love.graphics.newImage('graphics/sword_fire.png'),
    ['sword-poison'] = love.graphics.newImage('graphics/sword_poison.png'),
    ['crossbow-ice'] = love.graphics.newImage('graphics/crossbow_ice.png'),
    ['crossbow-acid'] = love.graphics.newImage('graphics/crossbow_acid.png'),
    ['arrow-ice'] = love.graphics.newImage('graphics/arrow_ice.png'),
    ['arrow-acid'] = love.graphics.newImage('graphics/arrow_acid.png'),

    ['entities'] = love.graphics.newImage('graphics/entities.png'),
    ['skeleton-attack'] = love.graphics.newImage('graphics/skeleton_atk.png'),
    ['spider-attack'] = love.graphics.newImage('graphics/spider_atk.png'),
    ['ghost-attack'] = love.graphics.newImage('graphics/ghost_atk.png'),
    ['slime-attack'] = love.graphics.newImage('graphics/slime_atk.png'),
    ['bat-attack'] = love.graphics.newImage('graphics/bat_atk.png'),
    ['spider-shot'] = love.graphics.newImage('graphics/spider_shot.png'),
    ['slime-shot'] = love.graphics.newImage('graphics/slime_shot.png')
}

gFrames = {
    ['tiles'] = GenerateQuads(gTextures['tiles'], 16, 16),
    
    ['character-male-walk'] = GenerateQuads(gTextures['character-male-walk'], 16, 32),
    ['character-female-walk'] = GenerateQuads(gTextures['character-female-walk'], 16, 32),

    ['character-male-swing-sword-normal'] = GenerateQuads(gTextures['character-male-swing-sword-normal'], 32, 32),
    ['character-female-swing-sword-normal'] = GenerateQuads(gTextures['character-female-swing-sword-normal'], 32, 32),
    ['character-male-swing-sword-fire'] = GenerateQuads(gTextures['character-male-swing-sword-fire'], 32, 32),
    ['character-female-swing-sword-fire'] = GenerateQuads(gTextures['character-female-swing-sword-fire'], 32, 32),
    ['character-male-swing-sword-poison'] = GenerateQuads(gTextures['character-male-swing-sword-poison'], 32, 32),
    ['character-female-swing-sword-poison'] = GenerateQuads(gTextures['character-female-swing-sword-poison'], 32, 32),

    ['character-male-shoot-crossbow-ice'] = GenerateQuads(gTextures['character-male-shoot-crossbow-ice'], 32, 32),
    ['character-female-shoot-crossbow-ice'] = GenerateQuads(gTextures['character-female-shoot-crossbow-ice'], 32, 32),
    ['character-male-shoot-crossbow-acid'] = GenerateQuads(gTextures['character-male-shoot-crossbow-acid'], 32, 32),
    ['character-female-shoot-crossbow-acid'] = GenerateQuads(gTextures['character-female-shoot-crossbow-acid'], 32, 32),

    ['character-male-hold'] = GenerateQuads(gTextures['character-male-hold'], 16, 32),
    ['character-female-hold'] = GenerateQuads(gTextures['character-female-hold'], 16, 32),

    ['character-male-lift'] = GenerateQuads(gTextures['character-male-lift'], 16, 32),
    ['character-female-lift'] = GenerateQuads(gTextures['character-female-lift'], 16, 32),

    ['hearts'] = GenerateQuads(gTextures['hearts'], 16, 16),
    ['potion'] = GenerateQuads(gTextures['potion'], 16, 18),
    ['chest'] = GenerateQuads(gTextures['chest'], 16, 18),
    ['key'] = GenerateQuads(gTextures['key'], 16, 18),
    ['pot-explosion'] = GenerateQuads(gTextures['pot-explosion'], 32, 32),

    ['sword-normal'] = GenerateQuads(gTextures['sword-normal'], 16, 18),
    ['sword-fire'] = GenerateQuads(gTextures['sword-fire'], 16, 18),
    ['sword-poison'] = GenerateQuads(gTextures['sword-poison'], 16, 18),
    ['crossbow-ice'] = GenerateQuads(gTextures['crossbow-ice'], 16, 18),
    ['crossbow-acid'] = GenerateQuads(gTextures['crossbow-acid'], 16, 18),
    ['arrow-ice'] = GenerateQuads(gTextures['arrow-ice'], 16, 18),
    ['arrow-acid'] = GenerateQuads(gTextures['arrow-acid'], 16, 18),

    ['entities'] = GenerateQuads(gTextures['entities'], 16, 16),
    ['skeleton-attack'] = GenerateQuads(gTextures['skeleton-attack'], 32, 32),
    ['spider-attack'] = GenerateQuads(gTextures['spider-attack'], 32, 32),
    ['ghost-attack'] = GenerateQuads(gTextures['ghost-attack'], 32, 32),
    ['slime-attack'] = GenerateQuads(gTextures['slime-attack'], 32, 32),
    ['bat-attack'] = GenerateQuads(gTextures['bat-attack'], 32, 32),
    ['spider-shot'] = GenerateQuads(gTextures['spider-shot'], 16, 18),
    ['slime-shot'] = GenerateQuads(gTextures['slime-shot'], 16, 18)
}

gFonts = {
    ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
    ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
    ['large'] = love.graphics.newFont('fonts/font.ttf', 32),
    ['gothic-small'] = love.graphics.newFont('fonts/GothicPixels.ttf', 8),
    ['gothic-medium'] = love.graphics.newFont('fonts/GothicPixels.ttf', 16),
    ['gothic-large'] = love.graphics.newFont('fonts/GothicPixels.ttf', 32),
    ['zelda'] = love.graphics.newFont('fonts/zelda.otf', 64),
    ['zelda-small'] = love.graphics.newFont('fonts/zelda.otf', 32),
    ['zelda-text'] = love.graphics.newFont('fonts/zelda.otf', 16),
    ['zelda-menu'] = love.graphics.newFont('fonts/zelda.otf', 8)
}

gSounds = {
    ['music'] = love.audio.newSource('sounds/music.mp3', 'static'),
    ['blip'] = love.audio.newSource('sounds/blip.wav', 'static'),
    ['powerup'] = love.audio.newSource('sounds/powerup.wav', 'static'),
    ['heal'] = love.audio.newSource('sounds/heal.wav', 'static'),
    ['sword'] = love.audio.newSource('sounds/sword.wav', 'static'),
    ['shoot'] = love.audio.newSource('sounds/shoot.wav', 'static'),
    ['hit-enemy'] = love.audio.newSource('sounds/hit_enemy.wav', 'static'),
    ['hit-player'] = love.audio.newSource('sounds/hit_player.wav', 'static'),
    ['victory'] = love.audio.newSource('sounds/victory.wav', 'static'),
    ['chest'] = love.audio.newSource('sounds/chest.wav', 'static'),
    ['door'] = love.audio.newSource('sounds/door.wav', 'static')
}