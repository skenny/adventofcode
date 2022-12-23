input = ">>><<><>><<<>><>>><<<>>><<<><<<>><>><<>>"

Point = Struct.new(:x, :y) do
    def plus(delta)
        Point.new(x + delta.x, y + delta.y)
    end

    def to_s
        "[#{x},#{y}]"
    end
end

Rock = Struct.new(:points) do
    def apply(delta)
        Rock.new(points.map { |p| p.plus(delta) })
    end

    def to_s
        points.map(&:to_s).join(", ")
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
                points.push(Point.new(x, height - y - 1)) if shape_arr[y][x] == "@"
            end
        end

        Rock.new(points)
    end
end

class Chamber 
    @@chamber_width = 7
    @@debug = false

    def initialize(jet_pattern)
        @jet_pattern = jet_pattern
        @jet_index = 0
        @fill = (0...@@chamber_width).map { |x| Point.new(x, 0) } # fill the bottom row [x,0]
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

    def play_rock(rock)
        puts "A new rock begins falling:" if @@debug
        rock = rock.apply(Point.new(2, height + 4))
        step = 0
        loop do
            puts "new step, rock is at #{rock}" if @@debug
            if step % 2 == 0
                jet_direction = @jet_pattern[@jet_index]
                @jet_index = (@jet_index + 1) % @jet_pattern.length
                if jet_direction == "<"
                    try_left = rock.apply(Point.new(-1, 0))
                    if in_bounds(try_left) and @fill.intersection(try_left.points).empty?
                        puts "Jet of gas pushes rock left:" if @@debug
                        rock = try_left
                    else 
                        puts "Jet of gas pushes rock left, but nothing happens:" if @@debug
                    end
                else
                    try_right = rock.apply(Point.new(1, 0))
                    if in_bounds(try_right) and @fill.intersection(try_right.points).empty?
                        puts "Jet of gas pushes rock right:" if @@debug
                        rock = try_right
                    else
                        puts "Jet of gas pushes rock right, but nothing happens:" if @@debug
                    end
                end
            else
                try_down = rock.apply(Point.new(0, -1))
                if @fill.intersection(try_down.points).empty?
                    puts "Rock falls 1 unit:" if @@debug
                    rock = try_down
                else
                    puts "Rock falls 1 unit, causing it to come to rest:" if @@debug
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

2022.times do |i|
    puts "Rock ##{i}..." if i % 500 == 0
    chamber.play_rock(rock_generator.next_rock)
    #chamber.draw
end
puts chamber.height
