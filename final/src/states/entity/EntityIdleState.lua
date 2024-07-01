--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

EntityIdleState = Class{__includes = BaseState}

function EntityIdleState:init(entity, dungeon)
    self.entity = entity

    self.dungeon = dungeon

    self.entity:changeAnimation('idle-' .. self.entity.direction)

    -- used for positional adjustment tracking
    self.moveX = 0
    self.moveY = 0
    self.tempX = 0
    self.tempY = 0
    -- used to track directional priority; true is x, false is y
    self.movePriority = true

    -- flag to track whether we want to attack this turn
    self.attacking = false

    self.processedAI = false
    self.finished = false
end

--[[
    We can call this function if we want to use this state on an agent in our game; otherwise,
    we can use this same state in our Player class and have it not take action.
]]
function EntityIdleState:processAI(params)
    self.attacking = false
    -- reset all tracker and directional values
    self.moveX = 0
    self.moveY = 0
    self.tempX = 0
    self.tempY = 0
    self.movePriority = true

    local room = params.room

    -- map boundaries for movement calculations
    local mapBoundaries = {
        left = MAP_RENDER_OFFSET_X + TILE_SIZE,
        right = VIRTUAL_WIDTH - TILE_SIZE * 2,
        top = MAP_RENDER_OFFSET_Y + TILE_SIZE - self.entity.height / 2,
        bottom = VIRTUAL_HEIGHT - (VIRTUAL_HEIGHT - MAP_HEIGHT * TILE_SIZE) + MAP_RENDER_OFFSET_Y - TILE_SIZE
    }

    --[[
        Working logic:

        Compute the destination coordinates OR the x and y differences
        Change entity direction based on whether x or y (prioritized) is positive or negative

        
        Change animation to walk-"direction", DO NOT change the state as that will cut this function

        Check if an attack is possible, if so then execute
        
    ]]

    -- using composites of dimensions to calculate distances
    local dx = (room.player.x + room.player.width / 2) - (self.entity.x + self.entity.width / 2)
    local dy = (room.player.y + room.player.height / 2) - (self.entity.y + self.entity.height / 2)

    local movementLimit = self.entity.movement

    local tX = 0
    local tY = 0

    if math.abs(dx) > math.abs(dy) or math.abs(dx) == math.abs(dy) then
        -- Move in the x direction first
        if dx > 0 then
            -- Move right
            tX = math.min(dx, movementLimit)
            -- Adjust moveX to not exceed the right boundary
            if self.entity.x + tX + self.entity.width > mapBoundaries.right then
                tX = mapBoundaries.right - self.entity.x - self.entity.width
            end
        else
            -- Move left
            tX = math.max(dx, -movementLimit)
            -- Adjust moveX to not exceed the left boundary
            if self.entity.x + tX < mapBoundaries.left then
                tX = mapBoundaries.left - self.entity.x
            end
        end
        -- Update movement limit
        movementLimit = movementLimit - math.abs(tX)
        
        -- Now move in the y direction with the remaining movement limit
        if dy > 0 then
            -- Move down
            tY = math.min(dy, movementLimit)
            -- Adjust moveY to not exceed the bottom boundary
            if self.entity.y + tY + self.entity.height > mapBoundaries.bottom then
                tY = mapBoundaries.bottom - self.entity.y - self.entity.height
            end
        else
            -- Move up
            tY = math.max(dy, -movementLimit)
            -- Adjust moveY to not exceed the top boundary
            if self.entity.y + tY < mapBoundaries.top then
                tY = mapBoundaries.top - self.entity.y
            end
        end
    else
        -- Move in the y direction first
        if dy > 0 then
            -- Move down
            tY = math.min(dy, movementLimit)
            -- Adjust moveY to not exceed the bottom boundary
            if self.entity.y + tY + self.entity.height > mapBoundaries.bottom then
                tY = mapBoundaries.bottom - self.entity.y - self.entity.height
            end
        else
            -- Move up
            tY = math.max(dy, -movementLimit)
            -- Adjust moveY to not exceed the top boundary
            if self.entity.y + tY < mapBoundaries.top then
                tY = mapBoundaries.top - self.entity.y
            end
        end
        -- Update movement limit
        movementLimit = movementLimit - math.abs(tY)
        
        -- Now move in the x direction with the remaining movement limit
        if dx > 0 then
            -- Move right
            tX = math.min(dx, movementLimit)
            -- Adjust moveX to not exceed the right boundary
            if self.entity.x + tX + self.entity.width > mapBoundaries.right then
                tX = mapBoundaries.right - self.entity.x - self.entity.width
            end
        else
            -- Move left
            tX = math.max(dx, -movementLimit)
            -- Adjust moveX to not exceed the left boundary
            if self.entity.x + tX < mapBoundaries.left then
                tX = mapBoundaries.left - self.entity.x
            end
        end
    end

    -- x-difference is larger
    if math.abs(tX) > math.abs(tY) or math.abs(tX) == math.abs(tY) then
        self.movePriority = true
    -- y-difference is larger
    else
        self.movePriority = false
    end

    -- flag as attacking in this turn if within range
    local rangeAdd = 0
    if self.entity.range then
        rangeAdd = 64
    end
    if (math.abs(tX) + math.abs(tY)) >= (math.abs(dx) + math.abs(dy) - rangeAdd) then
        self.attacking = true
    end
    -- set intended distances to trigger off movement on next update() cycle
    self.moveX = tX
    self.moveY = tY
end

--[[
    update() checks if there is any x or y positional changes to execute. 
    Working logic:
        Check against absolute value of self.moveX or self.moveY?

        Use tempX and tempY tracker values, increase based on walkSpeed * dt every cycle & check against abs(moveX/Y)
        Change over time is always positive due to abs() comparison

    Make sure to reset back to idle animation after all positioning adjustments are finished
]]
function EntityIdleState:update(dt)
    -- verifies that we have not exceeded the intended distance(s) to move
    if (self.tempX < math.abs(self.moveX)) or (self.tempY < math.abs(self.moveY)) then
        -- move in x-direction if difference is larger than or equal to y, sets direction to match
        if self.movePriority then 
            if self.moveX > 0 then -- moves to the right
                self.entity.x = self.entity.x + self.entity.walkSpeed * dt
                self.tempX = self.tempX + self.entity.walkSpeed * dt
                self.entity.direction = 'right'

            elseif self.moveX < 0 then -- moves to the left
                self.entity.x = self.entity.x - self.entity.walkSpeed * dt
                self.tempX = self.tempX + self.entity.walkSpeed * dt
                self.entity.direction = 'left'
            end

            -- change to appropriate animation if not already active
            if not(self.entity.currentAnimation == tostring('walk-' .. self.entity.direction)) then
                self.entity:changeAnimation('walk-' .. self.entity.direction)
            end
            
            -- once x-directional movement exceeds/equals intended movement, flip to y
            if(self.tempX >= math.abs(self.moveX)) then
                self.movePriority = false
            end
        -- move in y-direction if difference is larger than x
        else
            if self.moveY > 0 then -- moves down
                self.entity.y = self.entity.y + self.entity.walkSpeed * dt
                self.tempY = self.tempY + self.entity.walkSpeed * dt
                self.entity.direction = 'down'

            elseif self.moveY < 0 then -- moves up
                self.entity.y = self.entity.y - self.entity.walkSpeed * dt
                self.tempY = self.tempY + self.entity.walkSpeed * dt
                self.entity.direction = 'up'
            end

            -- change to appropriate animation if not already active
            if not(self.entity.currentAnimation == tostring('walk-' .. self.entity.direction)) then
                self.entity:changeAnimation('walk-' .. self.entity.direction)
            end
            
            -- once y-directional movement exceeds/equals intended movement, flip to x
            if(self.tempY >= math.abs(self.moveY)) then
                self.movePriority = true
            end
        end
    else
        --[[
            Ranged attacking animation notes:
            needs to execute and generate projectile
            projectile should travel x distance and execute everything below (including) the gSounds function
            projectile should be removed from the battle state to stop rendering
        ]]
        if self.attacking and not(self.finished) then
            self.entity:changeAnimation('attack-' .. self.entity.direction)

            -- render offset for spaced character sprite
            self.entity.offsetY = 5
            self.entity.offsetX = 8

            if self.entity.range then 
                local shot = GameObject(GAME_OBJECT_DEFS[self.entity.entityType .. '-shot'], self.entity.x, self.entity.y)
                shot.state = tostring(self.entity.direction)
                shot.onCollide = function ()
                    shot.state = 'explosion'
                    -- projectile removed in the room upon collision, not here
                end

                if self.entity.direction == 'left' then
                    shot.dx = -50
                elseif self.entity.direction == 'right' then
                    shot.dx = 50
                elseif self.entity.direction == 'up' then
                    shot.dy = -50
                else
                    shot.dy = 50
                end

                table.insert(self.dungeon.currentRoom.objects, shot)
            else
                if math.random(1, 20) > self.dungeon.currentRoom.player.ac then
                    gSounds['hit-player']:play()
                    self.dungeon.currentRoom.player:damage(1)
                    self.dungeon.currentRoom.player:flashTrigger(1.5)
                end
            end
            self.attacking = false
            
            -- player health after attack occurs is checked in the room, not here
        -- if no more movement to be done, then change back to idle animation
        elseif self.entity.currentAnimation.timesPlayed > 0 and self.processedAI then
            self.entity.currentAnimation.timesPlayed = 0
            self.entity:changeAnimation('idle-' .. self.entity.direction)
            self.finished = true
            self.moveX = 0
            self.moveY = 0
            self.tempX = 0
            self.tempY = 0
            self.entity.offsetY = 0
            self.entity.offsetX = 0
        end
    end
end

function EntityIdleState:render()
    local anim = self.entity.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.entity.x - self.entity.offsetX), math.floor(self.entity.y - self.entity.offsetY))
    
    -- love.graphics.setColor(255, 0, 255, 255)
    -- love.graphics.rectangle('line', self.entity.x, self.entity.y, self.entity.width, self.entity.height)
    -- love.graphics.setColor(255, 255, 255, 255)
end