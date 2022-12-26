Point = Struct.new(:x, :y) do
    def plus(delta)
        Point.new(x + delta.x, y + delta.y)
    end

    def neighbours
        [[-1, 0], [1, 0], [0, -1], [0, 1]].map { |v_x, v_y| Point.new(x + v_x, y + v_y) }
    end

    def inspect
        "[#{x},#{y}]"
    end

    def to_s
        "[#{x},#{y}]"
    end
end

class Player
    attr_accessor :point

    def initialize(point)
        @point = point
    end
end

class Blizzard
    attr_accessor :point, :direction_vector

    def initialize(point, direction)
        @point = point
        case direction
        when "^"
            @direction_vector = Point.new(0, -1)
        when "v"
            @direction_vector = Point.new(0, 1)
        when "<"
            @direction_vector = Point.new(-1, 0)
        when ">"
            @direction_vector = Point.new(1, 0)
        else
            "Invalid blizzard direction #{direction}!"
            exit
        end
    end
end

class Grid
    attr_accessor :start, :target

    def initialize(input)
        @width = input[0].size
        @height = input.size
        @exit = nil
        @player = nil
        @blizzards = []
        @lookup = {}

        blizzard_contents = ["<", ">", "v", "^"]

        input.each_with_index do |row, y|
            row.chars.each_with_index do |col, x|
                point = Point.new(x, y)

                if y == 0 and col == '.'
                    @player = Player.new(point)
                elsif y == input.size-1 and col == '.'
                    @exit = point
                end

                if blizzard_contents.include?(col)
                    @blizzards.push(Blizzard.new(point, col))
                end

                @lookup[point] = col
            end
        end

        @lookup[@player.point] = 'E'
    end

    def in_bounds(p)
        p.x > 0 and p.x < @width and p.y > 0 and p.y < @height
    end

    def get(p)
        @lookup[p]
    end

end

def part1(input)
    grid = Grid.new(input)
end

input = ARGF.read.split("\n")
part1(input)
