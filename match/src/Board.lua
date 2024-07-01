--[[
    GD50
    Match-3 Remake

    -- Board Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The Board is our arrangement of Tiles with which we must try to find matching
    sets of three horizontally or vertically.

    Tile variety has been modified to be limited to the first 9 colors ONLY to maximize chances of a board with at least one possible move.
]]

Board = Class{}

function Board:init(x, y, level)
    self.x = x
    self.y = y
    self.matches = {}
    self.level = level

    self:initializeTiles()
end

function Board:initializeTiles()
    self.tiles = {}

    for tileY = 1, 8 do
        
        -- empty table that will serve as a new row
        table.insert(self.tiles, {})

        for tileX = 1, 8 do
            -- default tile state
            self.shiny = false

            -- randomly decides if the tile is shiny or not (1/10 probability)
            if math.random(10) == 1 then
                self.shiny = true
            end
            
            if self.level == 1 then
                -- create a new tile at X,Y with a random color and base variety
                table.insert(self.tiles[tileY], Tile(tileX, tileY, math.random(9), 1, self.shiny))
            else    
                -- create a new tile at X,Y with a random color and variety
                table.insert(self.tiles[tileY], Tile(tileX, tileY, math.random(9), math.random(6), self.shiny))
            end
        end
    end

    while not(self:checkMatches()) do
        -- recursively initialize if no matches are possible on the current board
        self:initializeTiles()
    end

    while self:calculateMatches() do
        
        -- recursively initialize if matches were returned so we always have
        -- a matchless board on start
        self:initializeTiles()
    end
end

--[[
    Goes left to right, top to bottom in the board, calculating matches by counting consecutive
    tiles of the same color. Doesn't need to check the last tile in every row or column if the 
    last two haven't been a match.
]]
function Board:calculateMatches()
    local matches = {}

    -- how many of the same color blocks in a row we've found
    local matchNum = 1

    -- horizontal matches first
    for y = 1, 8 do
        local colorToMatch = self.tiles[y][1].color

        matchNum = 1
        
        -- every horizontal tile
        for x = 2, 8 do
            
            -- if this is the same color as the one we're trying to match...
            if self.tiles[y][x].color == colorToMatch then
                matchNum = matchNum + 1
            else
                
                -- set this as the new color we want to watch for
                colorToMatch = self.tiles[y][x].color

                -- if we have a match of 3 or more up to now, add it to our matches table
                if matchNum >= 3 then
                    local match = {}

                    -- go backwards from here by matchNum
                    for x2 = x - 1, x - matchNum, -1 do
                        
                        if self.tiles[y][x2].shiny then
                            for i = 1, 8 do
                                if match[self.tiles[y][i]] == nil then
                                    table.insert(match, self.tiles[y][i])
                                end
                            end
                            goto continue
                        end

                        -- add each tile to the match that's in that match
                        table.insert(match, self.tiles[y][x2])
                    end

                    ::continue::
                    -- add this match to our total matches table
                    table.insert(matches, match)
                end

                matchNum = 1

                -- don't need to check last two if they won't be in a match
                if x >= 7 then
                    break
                end
            end
        end

        -- account for the last row ending with a match
        if matchNum >= 3 then
            local match = {}
            
            -- go backwards from end of last row by matchNum
            for x = 8, 8 - matchNum + 1, -1 do
                if self.tiles[y][x].shiny then
                    for i = 1, 8 do
                        if match[self.tiles[y][i]] == nil then
                            table.insert(match, self.tiles[y][i])
                        end
                    end
                    goto continue
                end
                table.insert(match, self.tiles[y][x])
            end

            ::continue::
            table.insert(matches, match)
        end
    end

    -- vertical matches
    for x = 1, 8 do
        local colorToMatch = self.tiles[1][x].color

        matchNum = 1

        -- every vertical tile
        for y = 2, 8 do
            if self.tiles[y][x].color == colorToMatch then
                matchNum = matchNum + 1
            else
                colorToMatch = self.tiles[y][x].color

                if matchNum >= 3 then
                    local match = {}

                    for y2 = y - 1, y - matchNum, -1 do
                        if self.tiles[y2][x].shiny then
                            for i = 1, 8 do
                                if match[self.tiles[y2][i]] == nil then
                                    table.insert(match, self.tiles[y2][i])
                                end
                            end
                            goto continue
                        end

                        table.insert(match, self.tiles[y2][x])
                        ::continue::
                    end

                    table.insert(matches, match)
                end

                matchNum = 1

                -- don't need to check last two if they won't be in a match
                if y >= 7 then
                    break
                end
            end
        end

        -- account for the last column ending with a match
        if matchNum >= 3 then
            local match = {}
            
            -- go backwards from end of last row by matchNum
            for y = 8, 8 - matchNum + 1, -1 do
                if self.tiles[y][x].shiny then
                    for i = 1, 8 do
                        if match[self.tiles[y][i]] == nil then
                            table.insert(match, self.tiles[y][i])
                        end
                    end
                    goto continue
                end

                table.insert(match, self.tiles[y][x])
                ::continue::
            end

            table.insert(matches, match)
        end
    end

    -- store matches for later reference
    self.matches = matches

    -- return matches table if > 0, else just return false
    return #self.matches > 0 and self.matches or false
end

function Board:checkMatches()
    local matchFound = false

    for y = 1, 8 do
        for x = 1, 8 do
            local currentTile = self.tiles[y][x]

            -- test swap with top
            if y > 1 then
                local newTile = self.tiles[y - 1][x]

                self.tiles[y][x] = newTile
                self.tiles[y - 1][x] = currentTile

                if self:calculateMatches() then
                    matchFound = true
                end

                -- revert test changes
                self.tiles[y][x] = currentTile
                self.tiles[y - 1][x] = newTile
            end
            
            -- test swap with right
            if x < 8 then
                local newTile = self.tiles[y][x + 1]

                self.tiles[y][x] = newTile
                self.tiles[y][x + 1] = currentTile

                if self:calculateMatches() then
                    matchFound = true
                end

                -- revert test changes
                self.tiles[y][x] = currentTile
                self.tiles[y][x + 1] = newTile
            end

            -- test swap with bottom
            if y < 8 then
                local newTile = self.tiles[y + 1][x]

                self.tiles[y][x] = newTile
                self.tiles[y + 1][x] = currentTile

                if self:calculateMatches() then
                    matchFound = true
                end

                -- revert test changes
                self.tiles[y][x] = currentTile
                self.tiles[y + 1][x] = newTile
            end

            -- test swap with left
            if x > 1 then
                local newTile = self.tiles[y][x - 1]

                self.tiles[y][x] = newTile
                self.tiles[y][x - 1] = currentTile

                if self:calculateMatches() then
                    matchFound = true
                end

                -- revert test changes
                self.tiles[y][x] = currentTile
                self.tiles[y][x - 1] = newTile
            end

        end
    end

    -- if no matches were found, return false, otherwise will return true
    return matchFound
end

--[[
    Remove the matches from the Board by just setting the Tile slots within
    them to nil, then setting self.matches to nil.
]]
function Board:removeMatches()
    for k, match in pairs(self.matches) do
        for l, tile in pairs(match) do
            -- delete current tile after all checks
            self.tiles[tile.gridY][tile.gridX] = nil
        end
    end

    self.matches = nil
end

--[[
    Shifts down all of the tiles that now have spaces below them, then returns a table that
    contains tweening information for these new tiles.
]]
function Board:getFallingTiles()
    -- tween table, with tiles as keys and their x and y as the to values
    local tweens = {}

    -- for each column, go up tile by tile till we hit a space
    for x = 1, 8 do
        local space = false
        local spaceY = 0

        local y = 8
        while y >= 1 do
            
            -- if our last tile was a space...
            local tile = self.tiles[y][x]
            
            if space then
                
                -- if the current tile is *not* a space, bring this down to the lowest space
                if tile then
                    
                    -- put the tile in the correct spot in the board and fix its grid positions
                    self.tiles[spaceY][x] = tile
                    tile.gridY = spaceY

                    -- set its prior position to nil
                    self.tiles[y][x] = nil

                    -- tween the Y position to 32 x its grid position
                    tweens[tile] = {
                        y = (tile.gridY - 1) * 32
                    }

                    -- set Y to spaceY so we start back from here again
                    space = false
                    y = spaceY

                    -- set this back to 0 so we know we don't have an active space
                    spaceY = 0
                end
            elseif tile == nil then
                space = true
                
                -- if we haven't assigned a space yet, set this to it
                if spaceY == 0 then
                    spaceY = y
                end
            end

            y = y - 1
        end
    end

    -- create replacement tiles at the top of the screen
    for x = 1, 8 do
        for y = 8, 1, -1 do
            local tile = self.tiles[y][x]

            -- if the tile is nil, we need to add a new one
            if not tile then

                -- default tile state
                shiny = false

                -- randomly decides if the tile is shiny or not (1/10 probability)
                if math.random(10) == 1 then
                    shiny = true
                end
                
                -- new tile with random color and variety, based on level
                if self.level == 1 then
                    -- create a new tile at X,Y with a random color and base variety
                    tile = Tile(x, y, math.random(9), 1, shiny)
                else    
                    -- create a new tile at X,Y with a random color and variety
                    tile = Tile(x, y, math.random(9), math.random(6), shiny)
                end

                tile.y = -32
                self.tiles[y][x] = tile

                -- create a new tween to return for this tile to fall down
                tweens[tile] = {
                    y = (tile.gridY - 1) * 32
                }
            end
        end
    end

    return tweens
end

function Board:render()
    for y = 1, #self.tiles do
        for x = 1, #self.tiles[1] do
            self.tiles[y][x]:render(self.x, self.y)
        end
    end
end