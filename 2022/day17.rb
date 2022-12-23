input = ARGF.read.strip

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
        :hline => [Point.new(0,0), Point.new(1,0), Point.new(2,0), Point.new(3,0)],
        :plus  => [Point.new(1,2), Point.new(0,1), Point.new(1,1), Point.new(2,1), Point.new(1,0)],
        :ell   => [Point.new(2,2), Point.new(2,1), Point.new(0,0), Point.new(1,0), Point.new(2,0)],
        :vline => [Point.new(0,3), Point.new(0,2), Point.new(0,1), Point.new(0,0)],
        :block => [Point.new(0,1), Point.new(1,1), Point.new(0,0), Point.new(1,0)]
    }
    @@rock_order = [:hline, :plus, :ell, :vline, :block]

    def initialize
        @rock_index = 0
    end

    def next_rock
        next_index = @rock_index % @@rock_shapes.length
        @rock_index += 1
        Rock.new(@@rock_shapes[@@rock_order[next_index]])
    end
end

class Chamber 
    @@jet_directions = {
        "<" => Point.new(-1,0),
        ">" => Point.new(1,0),
        "v" => Point.new(0,-1)
    }
    @@chamber_width = 7

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
        rock = rock.apply(Point.new(2, height + 4))
        step = 0
        
        loop do
            delta = Point.new(0,0)
            if step % 2 == 0
                jet_direction = @jet_pattern[@jet_index]
                @jet_index = (@jet_index + 1) % @jet_pattern.length
                delta = @@jet_directions[jet_direction]
            else
                delta = @@jet_directions["v"]
            end

            try_move = rock.apply(delta)
            if in_bounds(try_move) and @fill.intersection(try_move.points).empty?
                rock = try_move
            else
                if delta.y == -1
                    @fill.concat(rock.points)
                    break
                end
            end

            step += 1
        end
    end
end

chamber = Chamber.new(input)
rock_generator = RockGenerator.new

puts Time.new.to_s
2022.times do |i|
    puts "Rock ##{i}..." if i % 500 == 0
    chamber.play_rock(rock_generator.next_rock)
    #chamber.draw
end
puts Time.new.to_s
puts chamber.height
