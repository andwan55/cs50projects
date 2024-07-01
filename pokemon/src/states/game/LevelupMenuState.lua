--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

LevelupMenuState = Class{__includes = BaseState}

function LevelupMenuState:init(battleState, onClose, input)
    self.battleState = battleState
    self.playerPokemon = self.battleState.player.party.pokemon[1]

    self.onClose = onClose

    -- set our exp to whatever the overlap is
    self.playerPokemon.currentExp = self.playerPokemon.currentExp - self.playerPokemon.expToLevel 
    local hp, attack, defense, speed = self.playerPokemon.HP, self.playerPokemon.attack, self.playerPokemon.defense, self.playerPokemon.speed

    local increasedHP, increasedAttack, increasedDefense, increasedSpeed = self.playerPokemon:levelUp()
    
    self.battleMenu = Menu {
        x = 0,
        y = VIRTUAL_HEIGHT - 64,
        width = VIRTUAL_WIDTH,
        height = 64,
        canInput = input,
        items = {
            {
                text = 'HP: ' .. tostring(hp) .. ' + ' .. tostring(increasedHP) .. ' = ' .. tostring(self.playerPokemon.HP)
            },
            {
                text = 'Attack: ' .. tostring(attack) .. ' + ' .. tostring(increasedAttack) .. ' = ' .. tostring(self.playerPokemon.attack)
            },
            {
                text = 'Defense: ' .. tostring(defense) .. ' + ' .. tostring(increasedDefense) .. ' = ' .. tostring(self.playerPokemon.defense)
            },
            {
                text = 'Speed: ' .. tostring(speed) .. ' + ' .. tostring(increasedSpeed) .. ' = ' .. tostring(self.playerPokemon.speed)
            }
        }
    }
end

function LevelupMenuState:update(dt)
    self.battleMenu:update(dt)
    if love.keyboard.wasPressed('space') or love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateStack:pop()
        self.onClose()
    end
end

function LevelupMenuState:render()
    self.battleMenu:render()
end