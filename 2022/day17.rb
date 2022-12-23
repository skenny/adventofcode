require 'set'

input = ARGF.read.strip

Point = Struct.new(:x, :y) do
    def plus(delta)
        Point.new(x + delta.x, y + delta.y)
    end

    def to_s
        "[#{x},#{y}]"
    end
end

Rock = Struct.new(:count, :points) do
    def apply(delta)
        Rock.new(count, points.map { |p| p.plus(delta) })
    end

    def to_s
        "#{count} " + points.map(&:to_s).join(", ")
    end
end

class Chamber 
    @@rock_shapes = {
        :hline => [Point.new(0,0), Point.new(1,0), Point.new(2,0), Point.new(3,0)],
        :plus  => [Point.new(1,2), Point.new(0,1), Point.new(1,1), Point.new(2,1), Point.new(1,0)],
        :ell   => [Point.new(2,2), Point.new(2,1), Point.new(0,0), Point.new(1,0), Point.new(2,0)],
        :vline => [Point.new(0,3), Point.new(0,2), Point.new(0,1), Point.new(0,0)],
        :block => [Point.new(0,1), Point.new(1,1), Point.new(0,0), Point.new(1,0)]
    }
    @@rock_order = [:hline, :plus, :ell, :vline, :block]
    @@directions = {
        "<" => Point.new(-1,0),
        ">" => Point.new(1,0),
        "v" => Point.new(0,-1)
    }
    @@chamber_width = 7

    def initialize(jet_pattern)
        @jet_pattern = jet_pattern
        @jet_index = 0
        @rock_index = 0

        # fill the bottom row [x,0]; using a set is way faster than enumerable/array
        @fill = (0...@@chamber_width).map { |x| Point.new(x, 0) }.to_set
    end

    def draw
        (1..height).each do |y|
            row = ""
            (0...@@chamber_width).each do |x|
                row += @fill.include?(Point.new(x, height - y + 1)) ? "#" : "."
            end
            puts "|#{row}|"
        end
        puts "+" + ("-" * @@chamber_width) + "+\n\n"
    end

    def height
        @fill.map { |point| point.y }.max || 0
    end

    def in_bounds(rock)
        rock.points.all? { |point| point.x >= 0 and point.x < @@chamber_width}
    end

    def play_rock
        rock = Rock.new(@rock_index, @@rock_shapes[@@rock_order[@rock_index]]).apply(Point.new(2, height + 4))
        @rock_index = (@rock_index + 1) % @@rock_shapes.length

        step = 0
        loop do
            direction = "v"
            if step % 2 == 0
                direction = @jet_pattern[@jet_index]
                @jet_index = (@jet_index + 1) % @jet_pattern.length
            end

            delta = @@directions[direction]
            try_move = rock.apply(delta)

            if in_bounds(try_move) and @fill.intersection(try_move.points.to_set).empty?
                rock = try_move
            else
                if delta.y == -1
                    @fill += rock.points.to_set
                    break
                end
            end

            step += 1
        end
    end
end

def part1(input)
    chamber = Chamber.new(input)
    2022.times { chamber.play_rock }
    puts chamber.height
end

def part2(input)
    chamber = Chamber.new(input)
    1_000_000_000_000.times { chamber.play_rock }
    puts chamber.height
end

part1(input)
#part2(input)
