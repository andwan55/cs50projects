Selection = Class{}

function Selection:init(def)
    self.room = def.room
    self.items = def.items
    self.x = def.x
    self.y = def.y

    self.height = def.height
    self.width = def.width
    self.font = def.font or gFonts['gothic-small']

    self.gapWidth = self.width / math.min(4, #self.items)

    self.currentSelection = 1
    self.currentPage = 1

    -- default input to true if nothing was passed in
    if def.canInput == nil then 
        self.canInput = true 
    else
        self.canInput = def.canInput
    end
end

function Selection:update(dt)
    if self.canInput then
        if love.keyboard.wasPressed('up') or love.keyboard.wasPressed('left') then
            if self.currentSelection == 1 then
                self.currentSelection = #self.items
            else
                self.currentSelection = self.currentSelection - 1
            end
            self.currentPage = math.ceil(self.currentSelection / 4)
            
            gSounds['blip']:stop()
            gSounds['blip']:play()
        elseif love.keyboard.wasPressed('down') or love.keyboard.wasPressed('right') then
            if self.currentSelection == #self.items then
                self.currentSelection = 1
            else
                self.currentSelection = self.currentSelection + 1
            end
            self.currentPage = math.ceil(self.currentSelection / 4)
            
            gSounds['blip']:stop()
            gSounds['blip']:play()
        elseif love.keyboard.wasPressed('return') or love.keyboard.wasPressed('enter') then
            gSounds['blip']:stop()
            gSounds['blip']:play()

            self.items[self.currentSelection].onSelect()
        end
    end
end

function Selection:render()
    local currentX = self.x

    local startIdx = (self.currentPage - 1) * 4 + 1
    local endIdx = math.min(self.currentPage * 4, #self.items)

    for i = startIdx, endIdx do
        local paddedX = currentX + (self.gapWidth / 2) - (#self.items[i].text * 3)
        local text = self.items[i].text
        local font = self.font or love.graphics.getFont()
        local textWidth = font:getWidth(text)

        -- draw selection marker if we're at the right index
        if self.canInput and i == self.currentSelection then
            love.graphics.draw(gTextures['cursor'], paddedX - textWidth / 2, self.y + (self.height / 2) - 8)
        end
        love.graphics.printf(self.items[i].text, paddedX, self.y + (self.height / 2) - 8, textWidth, 'center')

        currentX = currentX + self.gapWidth
    end
end
