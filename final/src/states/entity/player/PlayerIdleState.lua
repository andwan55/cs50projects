--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerIdleState = Class{__includes = EntityIdleState}

function PlayerIdleState:init(player, dungeon)
    self.entity = player
    self.dungeon = dungeon

    -- render offset for spaced character sprite (negated in render function of state)
    self.entity.offsetY = 5
    self.entity.offsetX = 0
end

function PlayerIdleState:enter()
    if self.entity.holding then
        self.entity:changeAnimation('idle-hold-' .. self.entity.direction)
    else
        self.entity:changeAnimation('idle-' .. self.entity.direction)
    end
end

-- function to pick up a pot within pickup distance in the current room
function PlayerIdleState:pickUp()
    local objects = self.dungeon.currentRoom.objects

    for k, object in pairs(objects) do
        if object.type == 'pot' then
            -- using composites of dimensions to calculate distances
            local dx = (self.entity.x + self.entity.width / 2) - (object.x + object.width / 2)
            local dy = (self.entity.y + self.entity.height / 2) - (object.y + object.height / 2)

            -- if either x or y distance between player and given pot is <= 1 tile, modify pot to be "picked up"
            if math.abs(dx) <= TILE_SIZE * 2 and math.abs(dy) <= TILE_SIZE * 2 then
                object.solid = false
                self.entity.holding = true
                self.entity:changeAnimation('idle-hold-' .. self.entity.direction)
                return
            end
        end
    end
end

function PlayerIdleState:processAttack()
    if self.entity.range then 
        self.entity:changeState('shoot')
    else
        -- melee attack code here
        self.entity:changeState('swing-sword')
    end

end

function PlayerIdleState:update(dt)
    -- only process controlled movement code if out of combat to freely move
    if not(self.entity.inCombat) then
        if love.keyboard.isDown('a') or love.keyboard.isDown('d') or
        love.keyboard.isDown('w') or love.keyboard.isDown('s') then
            self.entity:changeState('walk')
        end
    -- do not take input if in combat and is not the player's turn
    elseif self.entity.inCombat and not(self.entity.hasTurn) then
        goto finish
    -- check for movement in combat, change to walkState if applicable
    else
        if self.entity.movement > 0 then
            if love.keyboard.isDown('a') or love.keyboard.isDown('d') or
            love.keyboard.isDown('w') or love.keyboard.isDown('s') then
                self.entity:changeState('walk')
            end
        end
    end

    ::finish::
end