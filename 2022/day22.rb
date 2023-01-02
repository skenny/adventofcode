Point = Struct.new(:x, :y) do

    def move(v, w, h)
        Point.new((x + v.x) % w, (y + v.y) % h)
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

class World1

    def initialize(grid_spec)
        @height = grid_spec.size
        @grid_sections = grid_spec.each { |line| line.chars }
        @player_position = Point.new(@grid_sections[0].chars.index { |char| char != ' ' }, 0)
        @facing_vector = Point.new(1, 0)
    end

    def get_final_password
        row = @player_position.y + 1
        col = @player_position.x + 1
        facing_val, facing_dir = get_facing
        1000 * row + 4 * col + facing_val
    end

    def get_facing
        case @facing_vector
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
                forward_position = @player_position.move(@facing_vector, @grid_sections[@player_position.y].size, @height)
                
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
            @facing_vector = @facing_vector.turn_left
        when "R"
            @facing_vector = @facing_vector.turn_right
        end
    end

end

class World2

    def initialize(grid_spec)
        @grid_sections = parse_grid_sections(grid_spec)
        @player = Point.new(0, 0, 0)
    end

    def parse_grid_sections(grid_spec)
        grid_size = grid_spec.size / 3
        blank_row = ' ' * grid_size
        sections = []
        grid_spec.each_slice(grid_size) do |grid_block|
            (grid_block[0].size / grid_size).times do |grid_i|
                grid = grid_block.map { |row| row.slice(grid_i * grid_size, grid_size) }
                sections.push(grid) if grid[0] != blank_row
            end
        end
        sections
    end

end

def part1(grid_spec, moves_spec)
    world = World1.new(grid_spec)
    moves = moves_spec.scan(/\d+|\D+/)
    moves.each do |move|
        world.move_player(move)
    end
    puts world.get_final_password
end

grid_spec, moves_spec = ARGF.read.split("\n\n").map{ |section_lines| section_lines.split("\n") }
part1(grid_spec, moves_spec[0])
