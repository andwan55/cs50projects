--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Player = Class{__includes = Entity}

function Player:init(def)
    self.gender = def.gender

    self.entityType = def.entityType

    self.holding = false

    -- determines whether to take player input or not, false by default until turn is reached
    self.hasTurn = false

    Entity.init(self, def)

    -- per-turn values that reset to default states as shown here at the end of each turn
    -- hasAction is used for most possible actions in a turn (Attack, Ranged Attack, Dash, Pick Up, Throw)
    self.hasAction = true
    -- hasBonus is used for bonus, smaller actions allowed in a turn (Use Potion, Shove)
    self.hasBonus = true

    -- keeps track of whether player has found and picked up the key to boss room
    self.key = false

    --[[
        Melee variants: normal, fire, poison
        Ranged variants: ice, acid
    ]]
    self.meleeWeapon = def.meleeWeapon
    self.rangedWeapon = def.rangedWeapon

    -- start with no potions
    self.potions = 0

    -- track any maxHealth increases
    self.maxHealth = 10
end

function Player:processAttack()
    self.stateMachine:processAttack()
end

function Player:pickUp()
    self.stateMachine:pickUp()
end

function Player:update(dt)
    Entity.update(self, dt)
end

function Player:collides(target)
    local selfY, selfHeight = self.y + self.height / 2, self.height - self.height / 2
    
    return not (self.x + self.width < target.x or self.x > target.x + target.width or
                selfY + selfHeight < target.y or selfY > target.y + target.height)
end

function Player:render()
    Entity.render(self)
    
    -- love.graphics.setColor(255, 0, 255, 255)
    -- love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
    -- love.graphics.setColor(255, 255, 255, 255)
end