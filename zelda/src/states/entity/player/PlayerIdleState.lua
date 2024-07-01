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

function PlayerIdleState:update(dt)
    if love.keyboard.isDown('left') or love.keyboard.isDown('right') or
       love.keyboard.isDown('up') or love.keyboard.isDown('down') then
        if self.entity.holding then
            self.entity:changeState('hold')
        else
            self.entity:changeState('walk')
        end
    end

    if love.keyboard.wasPressed('space') and not(self.entity.holding) then
        self.entity:changeState('swing-sword')
    end

    -- code for throwing pot
    if love.keyboard.wasPressed('return') then
        for k, object in pairs(self.dungeon.currentRoom.objects) do
            if object.type == 'pot' and not(object.solid) and not(object.thrown) then
                object.thrown = true
    
                self.entity.holding = false
    
                if self.entity.direction == 'left' then
                    object.dx = -50
                elseif self.entity.direction == 'right' then
                    object.dx = 50
                elseif self.entity.direction == 'up' then
                    object.dy = -50
                else
                    object.dy = 50
                end
                
                self.entity:changeState('idle')
                goto finish
            end
        end
    end

    ::finish::
end