--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Room = Class{}

function Room:init(player, dungeon)
    self.dungeon = dungeon

    self.width = MAP_WIDTH
    self.height = MAP_HEIGHT

    self.tiles = {}
    self:generateWallsAndFloors()

    -- initiative table
    self.initiative = {}

    -- reference to player for collisions, etc.
    self.player = player

    -- player initiative roll is executed here
    self.player.initiative = math.random(1, 10)
    table.insert(self.initiative, self.player)

    -- entities in the room
    self.entities = {}
    self:generateEntities()

    -- game objects in the room
    self.objects = {}
    self:generateObjects()

    -- handling any loot in the room
    self.loot = {}

    -- doorways that lead to other dungeon rooms
    self.doorways = {}
    table.insert(self.doorways, Doorway('top', false, self))
    table.insert(self.doorways, Doorway('bottom', false, self))
    table.insert(self.doorways, Doorway('left', false, self))
    table.insert(self.doorways, Doorway('right', false, self))

    -- used for centering the dungeon rendering
    self.renderOffsetX = MAP_RENDER_OFFSET_X
    self.renderOffsetY = MAP_RENDER_OFFSET_Y

    -- used for drawing when this room is the next room, adjacent to the active
    self.adjacentOffsetX = 0
    self.adjacentOffsetY = 0

    -- table of possible projectiles for processing
    self.projectiles = {['projectile'] = true, ['ice'] = true, ['acid'] = true}

    -- menu for displaying player action options during their turn
    --[[ 
        Interactive option notes: (all options check whether an item is being held; only Throw is possible if so)
            Melee Attack (check for action, select enemy from list display overlay, automatically navigates but will not if 
                distance > movement limit, executes animation)
            Ranged Attack (check for action, check for ranged weapon, select enemy from list display overlay, will NOT attack
                if not already within range, executes animation)
            Dash (checks for action, doubles player movement limit) 
            Pick Up (checks for bonus action, checks for an applicable game object within 1 tile, executes animation)
            Throw (checks for action, checks whether holding an item, executes animation)
            Use Potion (checks for bonus action, then checks for if any potions in inventory)
            End Turn (ends the player's turn, sets player.hasTurn = false)
    ]]  
    self.battleMenu = Menu {
        x = 0,
        y = VIRTUAL_HEIGHT * 7/8,
        width = VIRTUAL_WIDTH,
        height = VIRTUAL_HEIGHT * 1/8,
        canInput = false,
        font = gFonts['zelda-text'],
        items = {
            {
                text = 'Melee',
                onSelect = function()
                    gSounds['blip']:stop()
                    gSounds['blip']:play()
                    if self.player.holding then
                        gStateStack:push(BattleMessageState('You must throw the item you are holding!',
                            function() end), false)
                    elseif not(self.player.hasAction) then
                        gStateStack:push(BattleMessageState('You do not have an action!',
                            function() end), false)
                    else
                        -- consumes player action
                        self.player.hasAction = false
                        self.player:processAttack()
                    end
                end
            },
            {
                text = 'Ranged',
                onSelect = function()
                    gSounds['blip']:stop()
                    gSounds['blip']:play()
                    if self.player.holding then
                        gStateStack:push(BattleMessageState('You must throw the item you are holding!',
                            function() end), false)
                    elseif not(self.player.hasAction) then
                        gStateStack:push(BattleMessageState('You do not have an action!',
                            function() end), false)
                    elseif self.player.rangedWeapon == '' then
                        gStateStack:push(BattleMessageState('You do not have a ranged weapon equipped!',
                            function() end), false)
                    else
                        -- consumes player action
                        self.player.hasAction = false
                        self.player.range = true
                        self.player:processAttack()
                    end
                end
            },
            {
                text = 'Dash',
                onSelect = function()
                    gSounds['blip']:stop()
                    gSounds['blip']:play()
                    if not(self.player.hasAction) then
                        gStateStack:push(BattleMessageState('You do not have an action!',
                            function() end), false)
                    else
                        -- temporarily set player movement to double current unused amount
                        gSounds['powerup']:play()
                        self.player.movement = self.player.movement * 2
                        self.player.hasAction = false
                    end
                end
            },
            {
                text = 'Pick Up',
                onSelect = function()
                    gSounds['blip']:stop()
                    gSounds['blip']:play()
                    if not(self.player.hasBonus) then
                        gStateStack:push(BattleMessageState('You do not have a bonus action!',
                            function() end), false)
                    elseif self.player.holding then
                        gStateStack:push(BattleMessageState('You are already holding something!',
                            function() end), false)                       
                    else
                        self.player:pickUp()
                        -- check for a pot nearby and picks up the nearest one if within one tile of distance
                        if self.player.holding then
                            self.player.hasBonus = false 
                        else
                            gStateStack:push(BattleMessageState('There are no pots close enough to pick up!',
                            function() end), false) 
                        end
                    end
                end
            },
            {
                text = 'Throw',
                onSelect = function()
                    gSounds['blip']:stop()
                    gSounds['blip']:play()
                    if not(self.player.hasAction) then
                        gStateStack:push(BattleMessageState('You do not have an action!',
                            function() end), false)
                    elseif not(self.player.holding) then
                        gStateStack:push(BattleMessageState('You are not holding something!',
                            function() end), false)                       
                    else
                        for k, object in pairs(self.objects) do
                            if object.type == 'pot' and not(object.solid) and not(object.thrown) then
                                object.thrown = true
                    
                                self.player.holding = false
                    
                                if self.player.direction == 'left' then
                                    object.dx = -50
                                elseif self.player.direction == 'right' then
                                    object.dx = 50
                                elseif self.player.direction == 'up' then
                                    object.dy = -50
                                else
                                    object.dy = 50
                                end
                            end
                        end
                        self.player:changeState('idle')

                        self.player.hasAction = false
                    end
                end
            },
            {
                text = 'Potion',
                onSelect = function()
                    gSounds['blip']:stop()
                    gSounds['blip']:play()
                    if not(self.player.hasBonus) then
                        gStateStack:push(BattleMessageState('You do not have a bonus action!',
                            function() end), false)
                    elseif self.player.potions == 0 then
                        gStateStack:push(BattleMessageState('You do not have any potions to use!',
                            function() end), false)                       
                    else
                        gSounds['heal']:play()
                        self.player.health = self.player.maxHealth -- fully recovers health
                        self.player.hasBonus = false
                        self.player.potions = self.player.potions - 1
                    end
                end
            },
            {
                text = 'End Turn',
                onSelect = function()
                    gSounds['blip']:stop()
                    gSounds['blip']:play()
                    self.player.hasTurn = false
                    -- menu input is toggled in the processTurn()
                end
            }
        }
    }

    -- flag for when the battle can take input, set in the first update call
    self.turnIndex = 1
    self.player.inCombat = true
    self.combatActive = true
end

--[[
    Randomly creates an assortment of enemies for the player to fight.
]]
function Room:generateEntities()
    local types = {'skeleton', 'slime', 'bat', 'ghost', 'spider'}

    -- enemy count limited to 3-4 to prevent excessive fighting
    local enemyCount = math.random(3, 4)
    for i = 1, enemyCount do
        local type = types[math.random(#types)]
        local isMajor = false
        local healthRef = 1

        -- if # of cleared rooms > 2, 1/2 chance to spawn a major enemy
        if self.dungeon.clearCount > 2 and math.random(1, 2) == 1 then
            isMajor = true
            healthRef = 3
        end

        table.insert(self.entities, Entity {
            animations = ENTITY_DEFS[type].animations,
            walkSpeed = ENTITY_DEFS[type].walkSpeed or 20,
            movement = ENTITY_DEFS[type].movement,
            range = ENTITY_DEFS[type].range,
            ac = ENTITY_DEFS[type].ac,

            -- ensure X and Y are within bounds of the map
            x = math.random(MAP_RENDER_OFFSET_X + TILE_SIZE,
                VIRTUAL_WIDTH - TILE_SIZE * 2 - 16),
            y = math.random(MAP_RENDER_OFFSET_Y + TILE_SIZE,
                VIRTUAL_HEIGHT - (VIRTUAL_HEIGHT - MAP_HEIGHT * TILE_SIZE) + MAP_RENDER_OFFSET_Y - TILE_SIZE - 16),
            
            width = 16,
            height = 16,

            health = healthRef,

            major = isMajor,

            entityType = type
        })

        self.entities[i].stateMachine = StateMachine {
            ['walk'] = function() return EntityWalkState(self.entities[i], self.dungeon) end,
            ['idle'] = function() return EntityIdleState(self.entities[i], self.dungeon) end
        }

        self.entities[i]:changeState('idle') -- set to idle state
        self.entities[i].initiative = math.random(1, 10) -- roll initiative upon spawning
    end

    -- temporarily adding spawned enemies to initiative table out of order
    for i = 1, #self.entities do
        table.insert(self.initiative, self.entities[i])
    end

    -- sort the initiative table to determine order of action in the room
    table.sort(self.initiative, function(a, b)
        return a.initiative > b.initiative
    end)
end

--[[
    Randomly creates an assortment of obstacles for the player to navigate around.
]]
function Room:generateObjects()
    -- random number of pots (5-10)
    local potCount = math.random(5, 10)
    for i = 1, potCount do
        local pot = GameObject(
        GAME_OBJECT_DEFS['pot'],
        math.random(MAP_RENDER_OFFSET_X + TILE_SIZE,
                    VIRTUAL_WIDTH - TILE_SIZE * 2 - 16),
        math.random(MAP_RENDER_OFFSET_Y + TILE_SIZE,
                    VIRTUAL_HEIGHT - (VIRTUAL_HEIGHT - MAP_HEIGHT * TILE_SIZE) + MAP_RENDER_OFFSET_Y - TILE_SIZE - 16)
        )

        table.insert(self.objects, pot)
    end
end

--[[
    Generates the walls and floors of the room, randomizing the various varieties
    of said tiles for visual variety.
]]
function Room:generateWallsAndFloors()
    for y = 1, self.height do
        table.insert(self.tiles, {})

        for x = 1, self.width do
            local id = TILE_EMPTY

            if x == 1 and y == 1 then
                id = TILE_TOP_LEFT_CORNER
            elseif x == 1 and y == self.height then
                id = TILE_BOTTOM_LEFT_CORNER
            elseif x == self.width and y == 1 then
                id = TILE_TOP_RIGHT_CORNER
            elseif x == self.width and y == self.height then
                id = TILE_BOTTOM_RIGHT_CORNER
            
            -- random left-hand walls, right walls, top, bottom, and floors
            elseif x == 1 then
                id = TILE_LEFT_WALLS[math.random(#TILE_LEFT_WALLS)]
            elseif x == self.width then
                id = TILE_RIGHT_WALLS[math.random(#TILE_RIGHT_WALLS)]
            elseif y == 1 then
                id = TILE_TOP_WALLS[math.random(#TILE_TOP_WALLS)]
            elseif y == self.height then
                id = TILE_BOTTOM_WALLS[math.random(#TILE_BOTTOM_WALLS)]
            else
                id = TILE_FLOORS[math.random(#TILE_FLOORS)]
            end
            
            table.insert(self.tiles[y], {
                id = id
            })
        end
    end
end

function Room:processTurn(dt)
    if #self.initiative <= 1 then
        self.combatActive = false
        self.player.inCombat = false
        self.battleMenu.selection.canInput = false

        -- increment room clear count by 1
        self.dungeon.clearCount = self.dungeon.clearCount + 1

        if self.dungeon.clearCount == 5 then
            gSounds['music']:stop()
            gSounds['victory']:play()
            gStateStack:pop()
            gStateStack:push(ClearState())
            return
        end

        local chest = GameObject(GAME_OBJECT_DEFS['chest'], VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT / 2)
        chest.onCollide = function()
            gSounds['chest']:play()

            chest.state = 'opened'
            local lootRef = math.random(1, #self.dungeon.lootTable)

            -- set item to spawn and located a tile to the right
            local loot = GameObject(GAME_OBJECT_DEFS[self.dungeon.lootTable[lootRef]], VIRTUAL_WIDTH / 2 + TILE_SIZE, VIRTUAL_HEIGHT / 2)

            table.insert(self.loot, loot)

            -- remove item from loot table if not potion/key to prevent duplicates
            if not(self.dungeon.lootTable[lootRef] == 'potion') then
                table.remove(self.dungeon.lootTable, lootRef)
            end
        end

        table.insert(self.objects, chest)

        -- open every door in the room if we cleared it
        for k, doorway in pairs(self.doorways) do
            doorway.open = true
        end

        gSounds['door']:play()
        return
    end

    local entity = self.initiative[self.turnIndex]

    if entity.entityType == 'player' then
        if not(self.battleMenu.selection.canInput) then
            entity.hasTurn = true
            entity.movement = ENTITY_DEFS['player-' .. self.player.gender].movement
            entity.hasAction = true
            entity.hasBonus = true
            self.battleMenu.selection.canInput = true
        elseif not(entity.hasTurn) then
            self.battleMenu.selection.canInput = false
            
            self.turnIndex = (self.turnIndex % #self.initiative) + 1
        end
    else
        if not(entity.stateMachine.current.processedAI) then
            for i = 1, #entity.conditions do
                if entity.conditions[i] == 'poison' then
                    entity:damage(1)
                    gSounds['hit-enemy']:play()
                end
            end
            entity.stateMachine.current.processedAI = true
            entity:processAI({room = self})
        end

        if entity.stateMachine.current.finished then
            entity.stateMachine.current.processedAI = false
            entity.stateMachine.current.finished = false
            self.turnIndex = (self.turnIndex % #self.initiative) + 1
        end
    end
end

function Room:update(dt)
    -- don't update anything if we are sliding to another room (we have offsets)
    if self.adjacentOffsetX ~= 0 or self.adjacentOffsetY ~= 0 then return end

    if self.combatActive then
        self:processTurn(dt)
    end

    self.player:update(dt)

    -- build a cleanup loop(s) to search for gameObjects that should be removed?

    for i = #self.initiative, 1, -1 do
        local entity = self.initiative[i]

        -- remove entity from the table if health is <= 0
        if entity.entityType ~= 'player' then
            if entity.health <= 0 then
                
                -- only spawn heart if entity is of height 16, an enemy, and 25% chance
                if math.random(4) == 1 then
                    local heart = GameObject(
                        GAME_OBJECT_DEFS['heart'],
                        entity.x,
                        entity.y
                    )
                    -- hearts 
                    heart.onCollide = function()
                        gSounds['heal']:play()
                        self.player.maxHealth = self.player.maxHealth + 2
                        self.player.health = self.player.maxHealth
                    end

                    table.insert(self.objects, heart)
                end
                if self.player.hasTurn and self.turnIndex ~= 1 and self.turnIndex > i then
                    self.turnIndex = self.turnIndex - 1
                end
                table.remove(self.initiative, i)
                
            elseif not(entity.health <= 0) then
                entity:update(dt)
            end
        end
    end

    -- goto continue IF a given object is removed, as it will try to reference a nil object if you do not
    for k = #self.objects, 1, -1 do
        local object = self.objects[k]
        -- pot object will only not be solid if picked up, tracks player motion
        if object.type == 'pot' and not(object.solid) and not (object.thrown) then
            object.x = self.player.x 
            object.y = self.player.y - (TILE_SIZE / 2)
        end

        object:update(dt)
        
        -- if a projectile ends up out of bounds or travels more than 6 tiles distance after updating, immediately remove
        local bottomEdge = VIRTUAL_HEIGHT - (VIRTUAL_HEIGHT - MAP_HEIGHT * TILE_SIZE) 
            + MAP_RENDER_OFFSET_Y - TILE_SIZE
        if (object.type == 'pot' and object.thrown) or (self.projectiles[object.type]) then
            if (object.x <= MAP_RENDER_OFFSET_X + TILE_SIZE) or 
            (object.x + object.width >= VIRTUAL_WIDTH - TILE_SIZE * 2) or
            (object.y <= MAP_RENDER_OFFSET_Y + TILE_SIZE - object.height / 2) or
            (object.y + object.height >= bottomEdge) or 
            object.distance >= (TILE_SIZE * 6) then
                object:onCollide()
                table.remove(self.objects, k)
                goto continue
            end

        end

        -- trigger collision callback on object, need to MODIFY this so onCollide is called regardless of whether player
        -- or entity collides with a gameObject, use object.type == 'projectile'
        if self.player:collides(object) then

            -- only remove if object is a heart, set player status to bumped if pot collision
            if object.type ~= nil then
                if object.type == 'heart' then
                    object:onCollide()
                    table.remove(self.objects, k)
                    goto continue
                elseif object.type == 'pot' and object.solid then
                    self.player.bumped = true
                elseif object.type == 'chest' and object.state == 'closed' then
                    object:onCollide()
                elseif object.type == 'projectile' and math.random(1, 20) > self.player.ac then
                    gSounds['hit-player']:play()
                    object:onCollide()
                    self.player:damage(1)
                    self.player:flashTrigger(1.5)
                    table.remove(self.objects, k)
                    goto continue
                end
            end
        end

        -- entity collision detection with any projectiles
        for i = #self.initiative, 1, -1 do
            local entity = self.initiative[i]

            if entity.entityType ~= 'player' then
                if entity:collides(object) and math.random(1, 20) > entity.ac then
                    if object.type == 'pot' and object.thrown then
                        entity:damage(1)
                        gSounds['hit-enemy']:play()
                        object.state = 'broken'
                        table.remove(self.objects, k)
                    elseif (object.type == 'ice' or object.type == 'acid') then
                        entity:damage(1)
                        gSounds['hit-enemy']:play()
                        object:onCollide()
                        if object.type == 'ice' and math.random(1,2) == 1 then
                            entity.movement = entity.movement / 2
                        elseif object.type == 'acid' then
                            entity.ac = entity.ac / 2
                        end
                        table.remove(self.objects, k)
                    end
                    goto continue
                end
            end
        end

        ::continue::
    end

    -- check for player collision with any loot objects in the room
    for k = #self.loot, 1, -1 do
        local object = self.loot[k]
        if self.player:collides(object) then
            gSounds['powerup']:play()

            if object.type == 'fire' or object.type == 'poison' then
                self.player.meleeWeapon = object.type
            elseif object.type == 'ice' or object.type == 'acid' then
                self.player.rangedWeapon = object.type
            elseif object.type == 'key' then
                self.player.key = true
            elseif object.type == 'potion' then
                self.player.potions = self.player.potions + 1
            end

            table.remove(self.loot, k)
        end
    end

    -- check if player is still alive
    if self.player.health <= 0 then
        gStateStack:pop() -- pops BattleState
        gStateStack:pop() -- pops PlayState
        gStateStack:push(GameOverState())
    end

    if self.battleMenu.selection.canInput then
        self.battleMenu:update(dt)
    end
end

function Room:render()
    for y = 1, self.height do
        for x = 1, self.width do
            local tile = self.tiles[y][x]
            love.graphics.draw(gTextures['tiles'], gFrames['tiles'][tile.id],
                (x - 1) * TILE_SIZE + self.renderOffsetX + self.adjacentOffsetX, 
                (y - 1) * TILE_SIZE + self.renderOffsetY + self.adjacentOffsetY)
        end
    end

    -- render doorways; stencils are placed where the arches are after so the player can
    -- move through them convincingly
    for k, doorway in pairs(self.doorways) do
        doorway:render(self.adjacentOffsetX, self.adjacentOffsetY)
    end

    if self.player then
        self.player:render()
    end

    for k, entity in pairs(self.initiative) do
        if not entity.dead then entity:render(self.adjacentOffsetX, self.adjacentOffsetY) end
    end

    for k, object in pairs(self.objects) do
        object:render(self.adjacentOffsetX, self.adjacentOffsetY)
    end

    for k, object in pairs(self.loot) do
        object:render(self.adjacentOffsetX, self.adjacentOffsetY)
    end

    -- stencil out the door arches so it looks like the player is going through
    love.graphics.stencil(function()
        
        -- left
        love.graphics.rectangle('fill', -TILE_SIZE - 6, MAP_RENDER_OFFSET_Y + (MAP_HEIGHT / 2) * TILE_SIZE - TILE_SIZE,
            TILE_SIZE * 2 + 6, TILE_SIZE * 2)
        
        -- right
        love.graphics.rectangle('fill', MAP_RENDER_OFFSET_X + (MAP_WIDTH * TILE_SIZE),
            MAP_RENDER_OFFSET_Y + (MAP_HEIGHT / 2) * TILE_SIZE - TILE_SIZE, TILE_SIZE * 2 + 6, TILE_SIZE * 2)
        
        -- top
        love.graphics.rectangle('fill', MAP_RENDER_OFFSET_X + (MAP_WIDTH / 2) * TILE_SIZE - TILE_SIZE,
            -TILE_SIZE - 6, TILE_SIZE * 2, TILE_SIZE * 2 + 12)
        
        --bottom
        love.graphics.rectangle('fill', MAP_RENDER_OFFSET_X + (MAP_WIDTH / 2) * TILE_SIZE - TILE_SIZE,
            VIRTUAL_HEIGHT - TILE_SIZE - 6, TILE_SIZE * 2, TILE_SIZE * 2 + 12)
    end, 'replace', 1)

    love.graphics.setStencilTest('less', 1)

    love.graphics.setStencilTest()

    if self.battleMenu.selection.canInput then
        self.battleMenu:render()
    end

    --
    -- DEBUG DRAWING OF STENCIL RECTANGLES
    --

    -- love.graphics.setColor(255, 0, 0, 100)
    
    -- -- left
    -- love.graphics.rectangle('fill', -TILE_SIZE - 6, MAP_RENDER_OFFSET_Y + (MAP_HEIGHT / 2) * TILE_SIZE - TILE_SIZE,
    -- TILE_SIZE * 2 + 6, TILE_SIZE * 2)

    -- -- right
    -- love.graphics.rectangle('fill', MAP_RENDER_OFFSET_X + (MAP_WIDTH * TILE_SIZE),
    --     MAP_RENDER_OFFSET_Y + (MAP_HEIGHT / 2) * TILE_SIZE - TILE_SIZE, TILE_SIZE * 2 + 6, TILE_SIZE * 2)

    -- -- top
    -- love.graphics.rectangle('fill', MAP_RENDER_OFFSET_X + (MAP_WIDTH / 2) * TILE_SIZE - TILE_SIZE,
    --     -TILE_SIZE - 6, TILE_SIZE * 2, TILE_SIZE * 2 + 12)

    -- --bottom
    -- love.graphics.rectangle('fill', MAP_RENDER_OFFSET_X + (MAP_WIDTH / 2) * TILE_SIZE - TILE_SIZE,
    --     VIRTUAL_HEIGHT - TILE_SIZE - 6, TILE_SIZE * 2, TILE_SIZE * 2 + 12)
    
    -- love.graphics.setColor(255, 255, 255, 255)
end
