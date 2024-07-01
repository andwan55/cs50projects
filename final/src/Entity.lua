--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Might need to add a onHurt() function that only gets called once someone or something hits this entity
]]

Entity = Class{}

function Entity:init(def)
    self.entityType = def.entityType or 'unspecified'

    -- in top-down games, there are four directions instead of two
    self.direction = 'down'

    self.animations = self:createAnimations(def.animations)

    -- dimensions
    self.x = def.x
    self.y = def.y
    self.width = def.width
    self.height = def.height

    -- drawing offsets for padded sprites
    self.offsetX = def.offsetX or 0
    self.offsetY = def.offsetY or 0

    self.walkSpeed = def.walkSpeed

    self.health = def.health

    -- flags for flashing the entity when hit
    self.invulnerable = false
    self.invulnerableDuration = 0
    self.invulnerableTimer = 0

    -- timer for turning transparency on and off, flashing
    self.flashTimer = 0
    self.flashTracker = 0

    self.dead = false

    -- movement limit per turn
    self.movement = def.movement

    self.range = def.range

    -- armor class value passed in from defs
    self.ac = def.ac

    -- determines enemy Entity major status for visual display differences
    self.major = def.major or false
    self.majorTimer = 0

    -- used to track whether an entity is being viewed for attack by player, or has been attacked
    self.flash = false

    -- table to keep track of inflicted debuffs
    self.conditions = {}
end

function Entity:createAnimations(animations)
    local animationsReturned = {}

    for k, animationDef in pairs(animations) do
        animationsReturned[k] = Animation {
            texture = animationDef.texture or 'entities',
            frames = animationDef.frames,
            interval = animationDef.interval
        }
    end

    return animationsReturned
end

--[[
    AABB with some slight shrinkage of the box on the top side for perspective.
]]
function Entity:collides(target)
    return not (self.x + self.width < target.x or self.x > target.x + target.width or
                self.y + self.height < target.y or self.y > target.y + target.height)
end

function Entity:damage(dmg)
    if not(self.invulnerable) then
        self.health = self.health - dmg
        self:goInvulnerable(1)
    end
    -- need invulnerability to make sure prolonged contact doesnt kill it immediately
end

function Entity:goInvulnerable(duration)
    self.invulnerable = true
    self.invulnerableDuration = duration
end

function Entity:flashTrigger(duration)
    self.flash = true
    self.flashDuration = duration
end

function Entity:changeState(name)
    self.stateMachine:change(name)
end

function Entity:changeAnimation(name)
    self.currentAnimation = self.animations[name]
end

function Entity:update(dt)

    if self.invulnerable then
        self.flashTimer = self.flashTimer + dt
        self.invulnerableTimer = self.invulnerableTimer + dt

        if self.invulnerableTimer > self.invulnerableDuration then
            self.invulnerable = false
            self.invulnerableTimer = 0
            self.invulnerableDuration = 0
            self.flashTimer = 0
        end
    end

    -- needs some sort of check conditions and execution code here

    if self.flash then
        self.flashTimer = self.flashTimer + dt
        self.flashTracker = self.flashTracker + dt
        
        if self.flashTracker > self.flashDuration then
            self.flash = false
            self.flashTracker = 0
            self.flashDuration = 0
            self.flashTimer = 0
        end
    end

    if self.major then
        self.majorTimer = self.majorTimer + dt
    end

    if self.bumped then
        if self.direction == 'left' then
            self.x = self.x + self.walkSpeed * dt
        elseif self.direction == 'right' then
            self.x = self.x - self.walkSpeed * dt
        elseif self.direction == 'up' then
            self.y = self.y + self.walkSpeed * dt
        elseif self.direction == 'down' then
            self.y = self.y - self.walkSpeed * dt
        end
    end

    -- reset bumped state
    self.bumped = false

    self.stateMachine:update(dt)

    if self.currentAnimation then
        self.currentAnimation:update(dt)
    end
end

function Entity:processAI(params)
    self.stateMachine:processAI(params)
end

-- need to add a way to make an enemy sprite appear reddened if they're a major enemy
function Entity:render(adjacentOffsetX, adjacentOffsetY)
    
    -- if it's a major class enemy, set to look red every 0.04 seconds normally
    if self.major and self.majorTimer > 2 then
        self.majorTimer = 0
        love.graphics.setColor(1, 0, 0, 1)
    end
    
    -- draw sprite slightly transparent if invulnerable every 0.04 seconds
    if self.flash and self.flashTimer > 0.06 then
        self.flashTimer = 0
        love.graphics.setColor(1, 1, 1, 64/255)
    end

    if self.invulnerable and self.flashTimer > 0.06 then
        self.flashTimer = 0
        love.graphics.setColor(1, 1, 1, 64/255)
    end

    self.x, self.y = self.x + (adjacentOffsetX or 0), self.y + (adjacentOffsetY or 0)
    self.stateMachine:render()
    love.graphics.setColor(1, 1, 1, 1)
    self.x, self.y = self.x - (adjacentOffsetX or 0), self.y - (adjacentOffsetY or 0)
end