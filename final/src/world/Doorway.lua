--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Doorway = Class{}

function Doorway:init(direction, open, room)
    self.direction = direction
    self.open = open
    self.room = room

    -- doorways will always be in the same place for this example, so we hard-code their locations
    -- based on which direction in the room they're assigned
    if direction == 'left' then
        self.x = MAP_RENDER_OFFSET_X
        self.y = MAP_RENDER_OFFSET_Y + (MAP_HEIGHT / 2) * TILE_SIZE - TILE_SIZE
        self.height = 32
        self.width = 16
    elseif direction == 'right' then
        self.x = MAP_RENDER_OFFSET_X + (MAP_WIDTH * TILE_SIZE) - TILE_SIZE
        self.y = MAP_RENDER_OFFSET_Y + (MAP_HEIGHT / 2 * TILE_SIZE) - TILE_SIZE
        self.height = 32
        self.width = 16
    elseif direction == 'top' then
        self.x = MAP_RENDER_OFFSET_X + (MAP_WIDTH / 2 * TILE_SIZE) - TILE_SIZE
        self.y = MAP_RENDER_OFFSET_Y
        self.height = 16
        self.width = 32
    else
        self.x = MAP_RENDER_OFFSET_X + (MAP_WIDTH / 2 * TILE_SIZE) - TILE_SIZE
        self.y = MAP_RENDER_OFFSET_Y + (MAP_HEIGHT * TILE_SIZE) - TILE_SIZE
        self.height = 16
        self.width = 32
    end
end

function Doorway:render(offsetX, offsetY)
    local texture = gTextures['tiles']
    local quads = gFrames['tiles']

    -- used for shifting the doors when sliding rooms
    self.x = self.x + offsetX
    self.y = self.y + offsetY

    -- the doors are composite sprites, since the tiles are smaller than they are,
    -- so we have to draw four sprites together for each doorway

    --[[
        left: 221, 222, 240, 241
        right: 176, 177, 195, 196
        top: 137, 138, 156, 157
        bottom: 179, 180, 198, 199

        closed clearDoor:
        left: 219, 220, 238, 239
        right: 174, 175, 193, 194
        top: 134, 135, 153, 154
        bottom: 216, 217, 235, 236
    ]]
    if self.direction == 'left' then
        if self.open then
            love.graphics.draw(texture, quads[181], self.x - TILE_SIZE, self.y)
            love.graphics.draw(texture, quads[182], self.x, self.y)
            love.graphics.draw(texture, quads[200], self.x - TILE_SIZE, self.y + TILE_SIZE)
            love.graphics.draw(texture, quads[201], self.x, self.y + TILE_SIZE)
        else
            --[[
            if self.clearDoor then
                love.graphics.draw(texture, quads[219], self.x - TILE_SIZE, self.y)
                love.graphics.draw(texture, quads[220], self.x, self.y)
                love.graphics.draw(texture, quads[238], self.x - TILE_SIZE, self.y + TILE_SIZE)
                love.graphics.draw(texture, quads[239], self.x, self.y + TILE_SIZE)
            else ]]
            love.graphics.draw(texture, quads[221], self.x - TILE_SIZE, self.y)
            love.graphics.draw(texture, quads[222], self.x, self.y)
            love.graphics.draw(texture, quads[240], self.x - TILE_SIZE, self.y + TILE_SIZE)
            love.graphics.draw(texture, quads[241], self.x, self.y + TILE_SIZE)
            --end
        end
    elseif self.direction == 'right' then
        if self.open then
            love.graphics.draw(texture, quads[172], self.x, self.y)
            love.graphics.draw(texture, quads[173], self.x + TILE_SIZE, self.y)
            love.graphics.draw(texture, quads[191], self.x, self.y + TILE_SIZE)
            love.graphics.draw(texture, quads[192], self.x + TILE_SIZE, self.y + TILE_SIZE)
        else
            --[[
            if self.clearDoor then
                love.graphics.draw(texture, quads[174], self.x, self.y)
                love.graphics.draw(texture, quads[175], self.x + TILE_SIZE, self.y)
                love.graphics.draw(texture, quads[193], self.x, self.y + TILE_SIZE)
                love.graphics.draw(texture, quads[194], self.x + TILE_SIZE, self.y + TILE_SIZE)
            else ]]
            love.graphics.draw(texture, quads[176], self.x, self.y)
            love.graphics.draw(texture, quads[177], self.x + TILE_SIZE, self.y)
            love.graphics.draw(texture, quads[195], self.x, self.y + TILE_SIZE)
            love.graphics.draw(texture, quads[196], self.x + TILE_SIZE, self.y + TILE_SIZE)
            --end
        end
    elseif self.direction == 'top' then
        if self.open then
            love.graphics.draw(texture, quads[98], self.x, self.y - TILE_SIZE)
            love.graphics.draw(texture, quads[99], self.x + TILE_SIZE, self.y - TILE_SIZE)
            love.graphics.draw(texture, quads[117], self.x, self.y)
            love.graphics.draw(texture, quads[118], self.x + TILE_SIZE, self.y)
        else
            --[[
            if self.clearDoor then
                love.graphics.draw(texture, quads[134], self.x, self.y - TILE_SIZE)
                love.graphics.draw(texture, quads[135], self.x + TILE_SIZE, self.y - TILE_SIZE)
                love.graphics.draw(texture, quads[153], self.x, self.y)
                love.graphics.draw(texture, quads[154], self.x + TILE_SIZE, self.y)
            else ]]
            love.graphics.draw(texture, quads[137], self.x, self.y - TILE_SIZE)
            love.graphics.draw(texture, quads[138], self.x + TILE_SIZE, self.y - TILE_SIZE)
            love.graphics.draw(texture, quads[156], self.x, self.y)
            love.graphics.draw(texture, quads[157], self.x + TILE_SIZE, self.y)
            --end
        end
    else
        if self.open then
            love.graphics.draw(texture, quads[141], self.x, self.y)
            love.graphics.draw(texture, quads[142], self.x + TILE_SIZE, self.y)
            love.graphics.draw(texture, quads[160], self.x, self.y + TILE_SIZE)
            love.graphics.draw(texture, quads[161], self.x + TILE_SIZE, self.y + TILE_SIZE)
        else
            --[[
            if self.clearDoor then
                love.graphics.draw(texture, quads[216], self.x, self.y)
                love.graphics.draw(texture, quads[217], self.x + TILE_SIZE, self.y)
                love.graphics.draw(texture, quads[235], self.x, self.y + TILE_SIZE)
                love.graphics.draw(texture, quads[236], self.x + TILE_SIZE, self.y + TILE_SIZE)
            else ]]
            love.graphics.draw(texture, quads[179], self.x, self.y)
            love.graphics.draw(texture, quads[180], self.x + TILE_SIZE, self.y)
            love.graphics.draw(texture, quads[198], self.x, self.y + TILE_SIZE)
            love.graphics.draw(texture, quads[199], self.x + TILE_SIZE, self.y + TILE_SIZE)
            -- end
        end
    end

    -- revert to original positions
    self.x = self.x - offsetX
    self.y = self.y - offsetY
end