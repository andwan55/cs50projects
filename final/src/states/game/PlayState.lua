--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayState = Class{__includes = BaseState}

function PlayState:init(def)
    self.player = Player {
        animations = ENTITY_DEFS['player-' .. def].animations,
        walkSpeed = ENTITY_DEFS['player-' .. def].walkSpeed,
        meleeWeapon = ENTITY_DEFS['player-' .. def].meleeWeapon,
        rangedWeapon = ENTITY_DEFS['player-' .. def].rangedWeapon,
        movement = ENTITY_DEFS['player-' .. def].movement,
        range = ENTITY_DEFS['player-' .. def].range,
        ac = ENTITY_DEFS['player-' .. def].ac,
        
        x = VIRTUAL_WIDTH / 2 - 8,
        y = VIRTUAL_HEIGHT / 2 - 11,
        
        width = 16,
        height = 22,

        -- one heart == 2 health
        health = 10,

        -- rendering and collision offset for spaced sprites
        offsetY = 5,

        -- unique identifier for player
        entityType = 'player',

        gender = def
    }

    self.dungeon = Dungeon(self.player)
    self.currentRoom = Room(self.player, self.dungeon)
    
    self.player.stateMachine = StateMachine {
        ['walk'] = function() return PlayerWalkState(self.player, self.dungeon) end,
        ['idle'] = function() return PlayerIdleState(self.player, self.dungeon) end,
        ['swing-sword'] = function() return PlayerSwingSwordState(self.player, self.dungeon) end,
        ['shoot'] = function() return PlayerShootState(self.player, self.dungeon) end,
        ['hold'] = function() return PlayerHoldState(self.player, self.dungeon) end,
        ['lift'] = function() return PlayerLiftState(self.player, self.dungeon) end
    }
    self.player:changeState('idle')
end

function PlayState:update(dt)
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    self.dungeon:update(dt)
end

function PlayState:render()
    -- render dungeon and all entities separate from hearts GUI
    love.graphics.push()
    self.dungeon:render()
    love.graphics.pop()

    -- draw player hearts, top of screen
    local healthLeft = self.player.health
    local heartFrame = 1
    local heartLimit = self.player.health / 2
    if self.player.health % 2 ~= 0 then
        heartLimit = heartLimit + 1
    end

    for i = 1, heartLimit do
        if healthLeft > 1 then
            heartFrame = 5
        elseif healthLeft == 1 then
            heartFrame = 3
        else
            heartFrame = 1
        end

        love.graphics.draw(gTextures['hearts'], gFrames['hearts'][heartFrame],
            (i - 1) * (TILE_SIZE + 1), 2)
        
        healthLeft = healthLeft - 2
    end
end