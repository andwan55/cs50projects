--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

ClearState = Class{__includes = BaseState}

function ClearState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gSounds['victory']:stop()
        gStateStack:pop()
        gStateStack:push(StartState())
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function ClearState:render()
    love.graphics.setFont(gFonts['zelda'])
    love.graphics.setColor(175/255, 53/255, 42/255, 1)
    love.graphics.printf('VICTORY', 0, VIRTUAL_HEIGHT / 2 - 48, VIRTUAL_WIDTH, 'center')
    
    love.graphics.setFont(gFonts['zelda-text'])
    love.graphics.printf('Press Enter to return to Start', 0, VIRTUAL_HEIGHT / 2 + 16, VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(1, 1, 1, 1)
end