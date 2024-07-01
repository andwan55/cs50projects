--[[
    GD50
    Breakout Remake

    -- Powerup Class --

    Author: Andrew Wang

    Represents a powerup that the player can collect when a certain point threshold has been
    reached to spawn a second ball to use. The powerup has a fixed appearance.
]]

Powerup = Class{}

function Powerup:init(powerType)
    -- determine whether powerup is for extra balls or key
    self.type = powerType

    -- simple positional and dimensional variables
    self.width = 16
    self.height = 16

    self.x = VIRTUAL_WIDTH / 2
    self.y = 0

    -- these variables are for keeping track of our velocity on both the
    -- X and Y axis, since the ball can move in two dimensions
    self.dy = 0.25
    self.dx = 0

    -- to keep track of whether to render or not
    self.inPlay = true
end

--[[
    Expects an argument with a bounding box, be that a paddle or a brick,
    and returns true if the bounding boxes of this and the argument overlap.
]]
function Powerup:collides(target)
    -- first, check to see if the left edge of either is farther to the right
    -- than the right edge of the other
    if self.x > target.x + target.width or target.x > self.x + self.width then
        return false
    end

    -- then check to see if the bottom edge of either is higher than the top
    -- edge of the other
    if self.y > target.y + target.height or target.y > self.y + self.height then
        return false
    end 

    -- if the above aren't true, they're overlapping
    return true
end

function Powerup:hit()
    self.inPlay = false
    gSounds['brick-hit-2']:play()
end

function Powerup:update()
    self.y = self.y + self.dy

    if self.y <= 0 then
        self.inPlay = false
    end
end

function Powerup:render()
    if self.inPlay then
        if self.type == 1 then
            love.graphics.draw(gTextures['main'], gFrames['powerups'][9], self.x, self.y)
        elseif self.type == 2 then
            love.graphics.draw(gTextures['main'], gFrames['powerups'][10], self.x, self.y)
        end
    end
end