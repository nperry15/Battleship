require_relative '../models/game_board'
require_relative '../models/ship'
require_relative '../models/position'

# return a populated GameBoard or nil
# Return nil on any error (validation error or file opening error)
# If 5 valid ships added, return GameBoard; return nil otherwise
def read_ships_file(path)
    if read_file_lines(path) == false then return nil end
    gameboard = GameBoard.new 10, 10
    lines = Array.new
    read_file_lines(path){|line| lines << line}
    
    i = 0
    while i < lines.length
        row = lines[i][1].to_i
        col = lines[i][3].to_i
        pos = Position.new(row, col)
        orien = lines[i].split(", ")[1].to_s
        size = lines[i].split(", ")[2].to_i
        
        ship = Ship.new(pos, orien, size)
        exit = gameboard.add_ship(ship)
        if exit == false then return nil end
        
       i += 1
    end
    
    return gameboard
end


# return Array of Position or nil
# Returns nil on file open error
def read_attacks_file(path)
    if read_file_lines(path) == false then return nil end
    # "((String1))".tr('()', '')
    # [Position.new(1, 1)]
    positions = Array.new
    lines = Array.new
    read_file_lines(path){|line| lines << line}
    
    i = 0
    while i < lines.length
        if checkCoords(lines[i]) then
            c = checkCoords(lines[i])
            positions << Position.new(c[0].to_i, c[1].to_i)
        end
        i += 1
    end
    
    return positions
end

private def checkCoords(coord)
    if coord[0] == "(" || coord[coord.length - 1] == ")"
        coord = coord.tr('()', '')
        coord = coord.split(",")
        return coord
    else
        return false
    end
end

# ===========================================
# =====DON'T modify the following code=======
# ===========================================
# Use this code for reading files
# Pass a code block that would accept a file line
# and does something with it
# Returns True on successfully opening the file
# Returns False if file doesn't exist
def read_file_lines(path)
    return false unless File.exist? path
    if block_given?
        File.open(path).each do |line|
            yield line
        end
    end

    true
end
