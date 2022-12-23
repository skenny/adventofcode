input = ">>><<><>><<<>><>>><<<>>><<<><<<>><>><<>>"

Point2d = Struct.new(:x, :y) do
    def plus(delta)
        Point2d.new(x + delta.x, y + delta.y)
    end

    def to_s
        "[#{x},#{y}]"
    end
end

class RockGenerator
    @@rock_shapes = {
        :horizontal_line => "@@@@",
        :plus => ".@.\n@@@\n.@.",
        :ell => "..@\n..@\n@@@",
        :vertical_line => "@\n@\n@\n@",
        :block => "@@\n@@"
    }
    @@rock_order = [:horizontal_line, :plus, :ell, :vertical_line, :block]

    def initialize
        @rock_index = 0
    end

    def next_rock
        next_index = @rock_index % @@rock_shapes.length
        @rock_index += 1

        shape_str = @@rock_shapes[@@rock_order[next_index]]
        shape_arr = shape_str.split("\n").map(&:chars)

        height = shape_arr.length
        width = shape_arr[0].length

        points = []
        (0...height).each do |y|
            (0...width).each do |x|
                # [0,0] is bottom left
                points.push(Point2d.new(x, height - y - 1)) if shape_arr[y][x] == "@"
            end
        end

        Rock.new(points)
    end
end

class Rock
    attr_accessor :points

    def initialize(points)
        @points = points
    end

    def apply(delta)
        Rock.new(@points.map { |p| p.plus(delta) })
    end
end

class Chamber
    @@chamber_width = 7

    def initialize(jet_pattern)
        @jet_pattern = jet_pattern
        @jet_index = 0
        @fill = (0...@@chamber_width).map { |x| Point2d.new(x, 0) } # fill the bottom row [x,0]
    end

    def draw
        # TODO draw active and settled rocks
        puts "+" + ("-" * @@chamber_width) + "+"
    end

    def height
        @fill.map { |x,y| y }.max || 0
    end

    def play_rock(rock)
        puts "A new rock begins falling:"
        rock = rock.apply(Point2d.new(2, height + 4))
        step = 0
        loop do
            if step % 2 == 0
                jet_direction = @jet_pattern[@jet_index]
                @jet_index = (@jet_index + 1) % @jet_pattern.length
                if jet_direction == "<"
                    try_left = rock.apply(Point2d.new(-1, 0))
                    if @fill.intersection(try_left.points).empty?
                        puts "Jet of gas pushes rock left:"
                        rock = try_left
                    else 
                        puts "Jet of gas pushes rock left, but nothing happens:"
                    end
                else
                    try_right = rock.apply(Point2d.new(1, 0))
                    if @fill.intersection(try_right.points).empty?
                        puts "Jet of gas pushes rock right:"
                        rock = try_right
                    else
                        puts "Jet of gas pushes rock right, but nothing happens:"
                    end
                end
            else
                try_down = rock.apply(Point2d.new(0, -1))
                if @fill.intersection(try_down.points).empty?
                    puts "Rock falls 1 unit:"
                    rock = try_down
                else
                    puts "Rock falls 1 unit, causing it to come to rest:"
                    @fill += rock.points
                    break
                end
            end
            step += 1
        end
    end
end

chamber = Chamber.new(input)
rock_generator = RockGenerator.new

5.times do 
    chamber.play_rock(rock_generator.next_rock)
end
