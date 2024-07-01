--[[
    PauseState Class
    
    A simple state used to pause the game before they
    transition back into the play state. Transitioned to from the
    PlayState when they press the 'p' key, and can go back to PlayState 
    with 'p' as well.
]]

PauseState = Class{__includes = BaseState}


function PauseState:update(dt)
    -- go back to play if 'p' is pressed
    if love.keyboard.wasPressed('p') then
        gStateMachine:change('play')
    end
end

function PauseState:render()
    -- render the pause icon in the middle of the screen
    self.image = love.graphics.newImage('pause-button-icon.png')
    love.graphics.draw(self.image, 225, 100, 0, 0.1)
end