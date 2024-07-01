--[[
    GD50
    Super Mario Bros. Remake

    -- LevelMaker Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

LevelMaker = Class{}

function LevelMaker.generate(width, height)
    local tiles = {}
    local entities = {}
    local objects = {}

    -- list of lockblock texture IDs for reference
    local lockblocks = {5, 6, 7, 8}
    local lockframe = lockblocks[math.random(#lockblocks)]
    local keyspawned = false
    local lockspawned = false

    local tileID = TILE_ID_GROUND
    
    -- whether we should draw our tiles with toppers
    local topper = true
    local tileset = math.random(20)
    local topperset = math.random(20)

    -- insert blank tables into tiles for later access
    for x = 1, height do
        table.insert(tiles, {})
    end

    -- column by column generation instead of row; sometimes better for platformers
    for x = 1, width do
        local tileID = TILE_ID_EMPTY
        
        -- lay out the empty space
        for y = 1, 6 do
            table.insert(tiles[y],
                Tile(x, y, tileID, nil, tileset, topperset))
        end

        -- chance to just be emptiness, only possible if not generating first or second last column
        if math.random(7) == 1 and x ~= 1 and x ~= (width - 1) then
            for y = 7, height do
                table.insert(tiles[y],
                    Tile(x, y, tileID, nil, tileset, topperset))
            end
        else
            tileID = TILE_ID_GROUND

            -- height at which we would spawn a potential jump block
            local blockHeight = 4

            for y = 7, height do
                table.insert(tiles[y],
                    Tile(x, y, tileID, y == 7 and topper or nil, tileset, topperset))
            end

            -- chance to generate a pillar, cannot be second last column
            if math.random(8) == 1 and x ~= (width - 1) then
                blockHeight = 2
                
                -- chance to generate bush on pillar
                if math.random(8) == 1 then
                    table.insert(objects,
                        GameObject {
                            texture = 'bushes',
                            x = (x - 1) * TILE_SIZE,
                            y = (4 - 1) * TILE_SIZE,
                            width = 16,
                            height = 16,
                            
                            -- select random frame from bush_ids whitelist, then random row for variance
                            frame = BUSH_IDS[math.random(#BUSH_IDS)] + (math.random(4) - 1) * 7,
                            collidable = false
                        }
                    )
                end
                
                -- pillar tiles
                tiles[5][x] = Tile(x, 5, tileID, topper, tileset, topperset)
                tiles[6][x] = Tile(x, 6, tileID, nil, tileset, topperset)
                tiles[7][x].topper = nil
            
            -- chance to generate bushes, also cannot be second last column to prevent obstruction
            elseif math.random(8) == 1 and x ~= (width - 1) then
                table.insert(objects,
                    GameObject {
                        texture = 'bushes',
                        x = (x - 1) * TILE_SIZE,
                        y = (6 - 1) * TILE_SIZE,
                        width = 16,
                        height = 16,
                        frame = BUSH_IDS[math.random(#BUSH_IDS)] + (math.random(4) - 1) * 7,
                        collidable = false
                    }
                )
            end

            -- chance to spawn a block, cannot be in second last column to prevent overlap with goalpost
            if math.random(10) == 1 and x ~= (width - 1) then
                table.insert(objects,

                    -- jump block
                    GameObject {
                        texture = 'jump-blocks',
                        x = (x - 1) * TILE_SIZE,
                        y = (blockHeight - 1) * TILE_SIZE,
                        width = 16,
                        height = 16,

                        -- make it a random variant
                        frame = math.random(#JUMP_BLOCKS),
                        collidable = true,
                        hit = false,
                        solid = true,

                        -- collision function takes itself
                        onCollide = function(player, obj)

                            -- spawn a gem if we haven't already hit the block
                            if not obj.hit then

                                -- chance to spawn gem, not guaranteed
                                if math.random(5) == 1 then

                                    -- maintain reference so we can set it to nil
                                    local gem = GameObject {
                                        texture = 'gems',
                                        x = (x - 1) * TILE_SIZE,
                                        y = (blockHeight - 1) * TILE_SIZE - 4,
                                        width = 16,
                                        height = 16,
                                        frame = math.random(#GEMS),
                                        collidable = true,
                                        consumable = true,
                                        solid = false,

                                        -- gem has its own function to add to the player's score
                                        onConsume = function(player, object)
                                            gSounds['pickup']:play()
                                            player.score = player.score + 100
                                        end
                                    }
                                    
                                    -- make the gem move up from the block and play a sound
                                    Timer.tween(0.1, {
                                        [gem] = {y = (blockHeight - 2) * TILE_SIZE}
                                    })
                                    gSounds['powerup-reveal']:play()

                                    table.insert(objects, gem)
                                end

                                obj.hit = true
                            end

                            gSounds['empty-block']:play()
                        end
                    }
                )                
            elseif x > 20 then  -- spawns a key/lockblock if not already spawned, very low chance to not spawn both
                -- spawn a key first if not already spawned in the level
                if not keyspawned then
                    keyspawned = true
                    local key = GameObject {
                        texture = 'keys',
                        x = (x - 1) * TILE_SIZE,
                        y = (blockHeight - 1) * TILE_SIZE - 4,
                        width = 16,
                        height = 16,
                        frame = lockframe - 4,
                        collidable = true,
                        consumable = true,
                        solid = false,

                        -- key has its own function to flag player that it's been picked up
                        onConsume = function(player, object)
                            gSounds['pickup']:play()
                            player.key = true
                        end
                    }
                    table.insert(objects, key)
                elseif not lockspawned and x > 40 then
                    lockspawned = true
                    table.insert(objects,

                        -- lockblock
                        GameObject {
                            texture = 'lockblocks',
                            x = (x - 1) * TILE_SIZE,
                            y = (blockHeight - 1) * TILE_SIZE,
                            width = 16,
                            height = 16,

                            frame = lockframe,
                            collidable = true,
                            solid = true, 

                            -- will "only" run when player has acquired key
                            onCollide = function(player, object)
                                if player.key then
                                    gSounds['powerup-reveal']:play()

                                    -- spawn goalpost
                                    table.insert(objects,
                                        GameObject {
                                            texture = 'flags',
                                            x = (player.level.tileMap.width - 2) * TILE_SIZE,
                                            y = 3 * TILE_SIZE,
                                            width = 16,
                                            height = 48,

                                            -- make it a random variant
                                            frame = math.random(6),
                                            collidable = true,
                                            hit = false,
                                            solid = true,

                                            -- collision function takes itself
                                            onCollide = function(player, obj)

                                                -- spawn a flag if we haven't already hit the goalpost for visuals
                                                if not obj.hit then
                                                    local flag = GameObject {
                                                        texture = 'flags',
                                                        x = (player.level.tileMap.width - 1.5) * TILE_SIZE,
                                                        y = 3 * TILE_SIZE,
                                                        width = 16,
                                                        height = 16,
                                                        frame = math.random(7, 10),
                                                        collidable = true,
                                                        solid = false
                                                    }
                                                    
                                                    table.insert(objects, flag)

                                                    obj.hit = true

                                                    gSounds['powerup-reveal']:play()
                                                    gStateMachine:change('play', {tier = player.tier + 1, score = player.score})
                                                end

                                                gSounds['powerup-reveal']:play()
                                            end
                                        }
                                    )
                                end
                                
                            end
                        }
                    )
                end
            end
        end
    end

    local map = TileMap(width, height)
    map.tiles = tiles
    
    return GameLevel(entities, objects, map)
end