class GameBoard
    attr_reader :max_row, :max_column
    
    

    def initialize(max_row, max_column)
        @max_row = max_row
        @max_column = max_column
        @gb = Array.new(max_row){Array.new(max_column){Array.new(2, "-")}}
        @successful_attacks = 0
        @ship_sizes = 0
    end

    # adds a Ship object to the GameBoard
    # returns Boolean
    # Returns true on successfully added the ship, false otherwise
    # Note that Position pair starts from 1 to max_row/max_column
    def add_ship(ship)
        # check if new ship is in the game board
        # and check if ship is already in that position
        if not canPlace?(ship) then return false end
        place(ship)
        
        
        @ship_sizes += ship.size
        
        return true
    end

    # return Boolean on whether attack was successful or not (hit a ship?)
    # return nil if Position is invalid (out of the boundary defined)
    def attack_pos(position)
        row = position.row - 1
        col = position.column - 1
        
        # check position
        if not inMap?(row, col) then return nil end
        # return whether the attack was successful or not
        if not @gb[row][col][0] == "B" then return false end
        # update your grid
        @gb[row][col][1] = "A"
        @successful_attacks += 1
        return true
    end

    # Number of successful attacks made by the "opponent" on this player GameBoard
    def num_successful_attacks
        return @successful_attacks
    end

    # returns Boolean
    # returns True if all the ships are sunk.
    # Return false if at least one ship hasn't sunk.
    def all_sunk?
        if @ship_sizes > @successful_attacks then return false end
        return true
    end


    # String representation of GameBoard (optional but recommended)
    def to_s
        row = 0
        i = 0
        print  "    "
        while i < @gb.length
            print (i + 1)
            print  "      "
            i += 1
        end
        puts
        
        while row < @gb.length
            print (row + 1)
            print ": "
            col = 0
            while col < @gb[row].length
                print @gb[row][col][0] + ", " + @gb[row][col][1]
                if col != @gb[row].length - 1
                    print " | "
                end
                col += 1
            end
            puts
            row += 1
        end
    end
    
    private def canPlace?(ship)
        row = ship.start_position.row
        col = ship.start_position.column
        row -= 1
        col -= 1
        
        i = 0
        while i < ship.size
            # right
            if ship.orientation == "Right"
                # check that position is in map
                
                if not inMap?(row, col + i) then return false end
                # check that position is open
                if not positionOpen?(row, col + i) then return false end
            # left
            elsif ship.orientation == "Left"
                # check that position is in map
                if not inMap?(row, col - i) then return false end
                # check that position is open
                if not positionOpen?(row, col - i) then return false end
            # up
            elsif ship.orientation == "Up"
                # check that position is in map
                if not inMap?(row - i, col) then return false end
                # check that position is open
                if not positionOpen?(row - i, col) then return false end
            # down
            elsif ship.orientation == "Down"
                # check that position is in map
                if not inMap?(row + i, col) then return false end
                # check that position is open
                if not positionOpen?(row + i, col) then return false end
            end
            
            i += 1
        end
        
        return true
    end
    
    private def place(ship)
        row = ship.start_position.row
        col = ship.start_position.column
        row -= 1
        col -= 1
        
        i = 0
        
        while i < ship.size
            # right
            if ship.orientation == "Right"
                @gb[row][col + i][0] = "B"
            # left
            elsif ship.orientation == "Left"
                @gb[row][col - i][0] = "B"
            # up
            elsif ship.orientation == "Up"
                @gb[row - i][col][0] = "B"
            # down
            elsif ship.orientation == "Down"
                @gb[row + i][col][0] = "B"
            end
            
            i += 1
        end
    
        
    end

    private def positionOpen?(row, col)
        # check if a ship is occupying that current position
        if @gb[row][col][0] == "B" then return false end
        return true
    end

    private def inMap?(row, col)
        if row < 0 || row >= @gb.length
            return false
        end
        
        if col < 0 || col >= @gb[row].length
            return false
        end
        
        return true
    end
end
