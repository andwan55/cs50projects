--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

GameObject = Class{}

function GameObject:init(def, x, y)
    
    -- string identifying this object type
    self.type = def.type

    self.texture = def.texture
    self.frame = def.frame or 1

    -- whether it acts as an obstacle or not
    self.solid = def.solid

    self.defaultState = def.defaultState
    self.state = self.defaultState
    self.states = def.states

    -- dimensions
    self.x = x
    self.y = y
    self.width = def.width
    self.height = def.height

    -- default velocities, only used for pots
    self.dx = 0
    self.dy = 0
    self.distance = 0

    -- default empty collision callback
    self.onCollide = function() end
end

function GameObject:update(dt)
    -- check if object is pot, only then check if thrown
    if self.type == 'pot' and self.thrown then
        self.x = self.x + self.dx * dt
        self.y = self.y + self.dy * dt
        self.distance = self.distance + math.abs(self.dx * dt) + math.abs(self.dy * dt)
    end
end

function GameObject:render(adjacentOffsetX, adjacentOffsetY)
    love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.states[self.state].frame or self.frame],
        self.x + adjacentOffsetX, self.y + adjacentOffsetY)
end