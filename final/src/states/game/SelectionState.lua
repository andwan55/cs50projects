--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

SelectionState = Class{__includes = BaseState}

function SelectionState:init()
    self.characterMenu = Menu {
        x = 0,
        y = VIRTUAL_HEIGHT * 3 / 4,
        width = VIRTUAL_WIDTH,
        height = VIRTUAL_HEIGHT / 4,
        font = gFonts['zelda-text'],
        items = {
            {
                text = 'Male',
                onSelect = function()
                    gStateStack:pop() -- pops itself, PlayState should be the only active State
                    gStateStack:push(PlayState('male'))
                end
            },
            {
                text = 'Female',
                onSelect = function()
                    gStateStack:pop() -- pops itself, PlayState should be the only active State
                    gStateStack:push(PlayState('female'))
                end
            }
        }
    }
end

function SelectionState:update(dt)
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    self.characterMenu:update(dt)
end

function SelectionState:render()

    love.graphics.draw(gTextures['background'], 0, 0, 0, 
        VIRTUAL_WIDTH / gTextures['background']:getWidth(),
        VIRTUAL_HEIGHT / gTextures['background']:getHeight())

    self.characterMenu:render()
end