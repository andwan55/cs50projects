--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerShootState = Class{__includes = BaseState}

function PlayerShootState:init(player, dungeon)
    self.player = player
    self.dungeon = dungeon

    -- render offset for spaced character sprite
    self.player.offsetY = 5
    self.player.offsetX = 8

    -- create hitbox based on where the player is and facing
    local direction = self.player.direction

    self.player:changeAnimation('crossbow-' .. self.player.direction .. '-' .. self.player.rangedWeapon)
end

function PlayerShootState:enter(params)

    -- restart shooting sound
    gSounds['shoot']:stop()
    gSounds['shoot']:play()

    -- restart shooting animation
    self.player.currentAnimation:refresh()

    local shot = GameObject(GAME_OBJECT_DEFS['arrow-' .. self.player.rangedWeapon], self.player.x, self.player.y)
    shot.state = tostring(self.player.direction)
    shot.onCollide = (function ()
        shot.state = 'explosion'
        -- projectile removed in the room upon collision, not here
    end)

    if self.player.direction == 'left' then
        shot.dx = -50
    elseif self.player.direction == 'right' then
        shot.dx = 50
    elseif self.player.direction == 'up' then
        shot.dy = -50
    else
        shot.dy = 50
    end

    table.insert(self.dungeon.currentRoom.objects, shot)

    self.player.range = false -- reset back to melee mode
end

function PlayerShootState:update(dt)
    -- if we've fully elapsed through one cycle of animation, change back to idle state
    if self.player.currentAnimation.timesPlayed > 0 then
        self.player.currentAnimation.timesPlayed = 0
        self.player:changeState('idle')
    end
end

function PlayerShootState:render()
    local anim = self.player.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.player.x - self.player.offsetX), math.floor(self.player.y - self.player.offsetY))

    --
    -- debug for player and hurtbox collision rects VV
    --

    -- love.graphics.setColor(255, 0, 255, 255)
    -- love.graphics.rectangle('line', self.player.x, self.player.y, self.player.width, self.player.height)
    -- love.graphics.rectangle('line', self.swordHurtbox.x, self.swordHurtbox.y,
    --     self.swordHurtbox.width, self.swordHurtbox.height)
    -- love.graphics.setColor(255, 255, 255, 255)
end