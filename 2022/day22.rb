Point = Struct.new(:x, :y) do

    def move_and_wrap(v, w, h)
        Point.new((x + v.x) % w, (y + v.y) % h)
    end

    def move(v)
        Point.new(x + v.x, y + v.y)
    end

    def swap
        Point.new(y, x)
    end

    def turn_right
        if x == 1 and y == 0
            Point.new(0, 1)
        elsif x == 0 and y == 1
            Point.new(-1, 0)
        elsif x == -1 and y == 0
            Point.new(0, -1)
        else
            Point.new(1, 0)
        end
    end

    def turn_left
        if x == 1 and y == 0
            Point.new(0, -1)
        elsif x == 0 and y == -1
            Point.new(-1, 0)
        elsif x == -1 and y == 0
            Point.new(0, 1)
        else
            Point.new(1, 0)
        end
    end

    def to_s
        "[#{x},#{y}]"
    end
end

CubeFace = Struct.new(:grid, :offset)

class World1

    def initialize(grid_spec)
        @height = grid_spec.size
        @grid_sections = grid_spec.each { |line| line.chars }
        @player_position = Point.new(@grid_sections[0].chars.index { |char| char != ' ' }, 0)
        @player_vector = Point.new(1, 0)
    end

    def get_final_password
        row = @player_position.y + 1
        col = @player_position.x + 1
        facing_val, facing_dir = get_facing
        1000 * row + 4 * col + facing_val
    end

    def get_facing
        case @player_vector
        when Point.new(1, 0)  # right
            [0, ">"]
        when Point.new(0, 1)  # down
            [1, "v"]
        when Point.new(-1, 0) # left
            [2, "<"]
        when Point.new(0, -1) # up
            [3, "^"]
        end
    end

    def grid_position(position)
        @grid_sections[position.y][position.x]
    end

    def wraps(position)
        (grid_position(position) || ' ') == ' '
    end

    def move_player(instr)
        if /(\d+)/.match?(instr)
            steps = instr.to_i
            steps.times do
                
                forward_position = @player_position.move_and_wrap(@player_vector, @grid_sections[@player_position.y].size, @height)
                
                if wraps(forward_position)
                    wrap_x = forward_position.x
                    wrap_y = forward_position.y

                    facing_val, facing_dir = get_facing
                    case facing_dir
                    when ">"
                        wrap_x = @grid_sections[forward_position.y].chars.index { |char| char != ' ' }
                    when "v"
                        wrap_y = @grid_sections.index { |row| forward_position.x < row.size && row[forward_position.x] != ' ' }
                    when "<"
                        wrap_x = @grid_sections[forward_position.y].chars.rindex { |char| char != ' ' }
                    when "^"
                        wrap_y = @grid_sections.rindex { |row| forward_position.x < row.size && row[forward_position.x] != ' ' }
                    end

                    forward_position = Point.new(wrap_x, wrap_y)
                end

                if grid_position(forward_position) == '#'
                    break
                end

                @player_position = forward_position
            end
        else
            turn_player(instr)
        end
    end

    def turn_player(direction)
        case direction
        when "L"
            @player_vector = @player_vector.turn_left
        when "R"
            @player_vector = @player_vector.turn_right
        end
    end

end

class World2

    @@face_transitions = {
        # face index => [R,D,L,U] to match directions; each is [new face index, new direction index]
        0 => [ [1, 0], [2, 1], [3, 0], [5, 0] ],
        1 => [ [4, 2], [2, 2], [0, 2], [5, 3] ],
        2 => [ [1, 3], [4, 1], [3, 1], [0, 3] ],
        3 => [ [4, 0], [5, 1], [0, 0], [2, 0] ],
        4 => [ [1, 2], [5, 2], [3, 2], [2, 3] ],
        5 => [ [4, 3], [1, 1], [0, 1], [3, 3] ]
    }

    def initialize(grid_spec, cube_face_size)
        @cube = parse_cube(grid_spec, cube_face_size)
        @cube_face_size = cube_face_size
        @player_position = Point.new(0, 0)
        @player_cube_face_index = 0
        @player_vector = Point.new(1,0)
    end

    def parse_cube(grid_spec, cube_face_size)
        blank_row = ' ' * cube_face_size
        cube = []
        grid_spec.each_slice(cube_face_size).with_index do |grid_block, grid_y|
            (grid_block[0].size / cube_face_size).times do |grid_x|
                grid = grid_block.map { |row| row.slice(grid_x * cube_face_size, cube_face_size) }
                offset = Point.new(grid_x * cube_face_size, grid_y * cube_face_size)
                cube.push(CubeFace.new(grid, offset)) if grid[0] != blank_row
            end
        end
        cube
    end

    def get_facing(vector)
        case vector
        when Point.new(1, 0)  # right
            [0, ">"]
        when Point.new(0, 1)  # down
            [1, "v"]
        when Point.new(-1, 0) # left
            [2, "<"]
        when Point.new(0, -1) # up
            [3, "^"]
        end
    end

    def grid_position(cube_face_index, position)
        @cube[cube_face_index].grid[position.y][position.x]
    end

    def get_final_password
        map_offset = @cube[@player_cube_face_index].offset
        row = @player_position.y + map_offset.y + 1
        col = @player_position.x + map_offset.x + 1
        facing_val, facing_dir = get_facing(@player_vector)
        1000 * row + 4 * col + facing_val
    end

    def move_player(instr)
        if /(\d+)/.match?(instr)
            steps = instr.to_i
            steps.times do
                facing_index, facing_dir = get_facing(@player_vector)
                forward_position = @player_position.move(@player_vector)
                forward_cube_face_index = @player_cube_face_index
                forward_player_vector = @player_vector

                if forward_position.x == -1 || forward_position.x == @cube_face_size || forward_position.y == -1 || forward_position.y == @cube_face_size
                    forward_cube_face_index, forward_facing_index = @@face_transitions[@player_cube_face_index][facing_index]
                    orientation_change = facing_index % 2 != forward_facing_index % 2

                    case forward_facing_index
                    when 0
                        new_y = orientation_change ? @player_position.x : @player_position.y
                        
                        # handle < to > 
                        # example: face 3 [0,1] going < to > on face 0 [0,48]
                        if !orientation_change && facing_index != forward_facing_index
                            new_y = @cube_face_size - 1 - @player_position.y
                        end

                        forward_position = Point.new(0, new_y)
                        forward_player_vector = Point.new(1, 0)
                    when 1
                        forward_position = Point.new(orientation_change ? @player_position.y : @player_position.x, 0)
                        forward_player_vector = Point.new(0, 1)
                    when 2
                        new_y = orientation_change ? @player_position.x : @player_position.y

                        # handle > to <
                        # example: face 4 [49,15] going > to < on face 1 [49,34]
                        if !orientation_change && facing_index != forward_facing_index
                            new_y = @cube_face_size - 1 - @player_position.y
                        end

                        forward_position = Point.new(@cube_face_size - 1, new_y)
                        forward_player_vector = Point.new(-1, 0)
                    when 3
                        forward_position = Point.new(orientation_change ? @player_position.y : @player_position.x, @cube_face_size - 1)
                        forward_player_vector = Point.new(0, -1)
                    end
                end

                if grid_position(forward_cube_face_index, forward_position) == '#'
                    break
                end

                @player_position = forward_position
                @player_cube_face_index = forward_cube_face_index
                @player_vector = forward_player_vector
            end
        else
            turn_player(instr)
        end
    end

    def turn_player(direction)
        case direction
        when "L"
            @player_vector = @player_vector.turn_left
        when "R"
            @player_vector = @player_vector.turn_right
        end
    end

end

def find_final_password(world, moves_spec)
    moves = moves_spec.scan(/\d+|\D+/)
    moves.each do |move|
        world.move_player(move)
    end
    world.get_final_password
end

grid_spec, moves_spec = ARGF.read.split("\n\n").map{ |section_lines| section_lines.split("\n") }
puts find_final_password(World1.new(grid_spec), moves_spec.first)
puts find_final_password(World2.new(grid_spec, 50), moves_spec.first)
