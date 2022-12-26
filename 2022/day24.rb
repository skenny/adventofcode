require 'set'

class Blizzard
    attr_accessor :point, :direction_vector

    def initialize(point, direction)
        @point = point
        case direction
        when "^"
            @direction_vector = [0, -1]
        when "v"
            @direction_vector = [0, 1]
        when "<"
            @direction_vector = [-1, 0]
        when ">"
            @direction_vector = [1, 0]
        else
            "Invalid blizzard direction #{direction}!"
            exit
        end
    end
end

class Grid
    attr_accessor :entrance, :exit, :blizzards

    def initialize(input)
        @width = input[0].size
        @height = input.size
        @entrance = nil
        @exit = nil
        @blizzards = []

        blizzard_contents = ["<", ">", "v", "^"]

        input.each_with_index do |row, y|
            row.chars.each_with_index do |col, x|
                point = [x, y]

                if y == 0 and col == '.'
                    @entrance = point
                elsif y == input.size-1 and col == '.'
                    @exit = point
                end

                if blizzard_contents.include?(col)
                    @blizzards.push(Blizzard.new(point, col))
                end
            end
        end
    end

    def step_blizzards
        @blizzards.each do |blizzard|
            x, y = blizzard.point
            n_x = x + blizzard.direction_vector[0]
            n_y = y + blizzard.direction_vector[1]
            if not in_bounds([n_x, n_y])
                if n_x == 0
                    n_x = @width - 2
                elsif n_x == @width - 1
                    n_x = 1
                elsif n_y == 0
                    n_y = @height - 2
                elsif n_y == @height - 1
                    n_y = 1
                end
            end
            blizzard.point = [n_x, n_y]
        end
    end

    def in_bounds(p)
        p[0] > 0 and p[0] < @width - 1 and p[1] > 0 and p[1] < @height - 1
    end

end

def search(grid, start, target)
    to_check = Set.new
    to_check.add(start)
    minute = 0

    while true
        puts "Minute #{minute}, checking #{to_check.size}..."

        grid.step_blizzards
        next_blizzard_state = grid.blizzards.map(&:point)

        next_to_check = Set.new
        to_check.each do |current|
            if current == target
                return minute
            end
            x, y = current
            possible_next = [[x - 1, y], [x + 1, y], [x, y - 1], [x, y + 1]].select { |neighbour| grid.in_bounds(neighbour) and not next_blizzard_state.include?(neighbour) }
            if possible_next.empty?
                next_to_check.add(current)
            else
                next_to_check += possible_next
            end
        end

        to_check = next_to_check
        minute += 1
    end
end

def part1(input)
    grid = Grid.new(input)
    puts "Starting at #{Time.new}..."
    puts search(grid, grid.entrance, grid.exit)
    puts "Finished at #{Time.new}"
end

input = ARGF.read.split("\n")
part1(input)
