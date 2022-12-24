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

Rock = Struct.new(:points) do
    def apply(delta)
        Rock.new(points.map { |p| p.plus(delta) })
    end

    def to_s
        points.map(&:to_s).join(", ")
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
        @states = {}

        # fill the bottom row [x,0]; using a set is way faster than enumerable/array
        @fill = (0...@@chamber_width).map { |x| Point.new(x, 0) }.to_set
    end

    def height
        @fill.map { |point| point.y }.max || 0
    end

    def rasterize(num_rows = 0)
        current_height = height
        stop_at = num_rows == 0 ? current_height : [num_rows, current_height].min
        rows = []
        (1..stop_at).each do |y|
            row = ""
            (0...@@chamber_width).each do |x|
                row += @fill.include?(Point.new(x, current_height - y + 1)) ? "#" : "."
            end
            rows.push("|#{row}|")
        end
        rows.push("+" + ("-" * @@chamber_width) + "+")
        rows
    end

    def top_contour(num_rows)
        tops = []
        current_height = height
        (0...@@chamber_width).each do |x|
            (0...[height, num_rows].min).each do |y|
                actual_y = current_height - y
                if not tops[x] and @fill.include?(Point.new(x, actual_y))
                    # we want the column height relative to tower height
                    tops[x] = y
                end
            end
            if not tops[x]
                tops[x] = -1
            end
        end
        tops
    end

    def simulate_rocks(num_rocks)
        rock_count = 0
        cycle_found = false
        while rock_count <= num_rocks do
            if not cycle_found
                current_height = height
                top_contour = top_contour(50)
                state = [@rock_index, @jet_index, top_contour]
                if @states.has_key?(state)
                    puts "repeat; rock #{@rock_index}, jet #{@jet_index}, height #{current_height} rocks dropped #{rock_count}, top contour #{top_contour}}"
                    cycle_found = true

                    prev_rock_count, prev_height = @states[state]
                    cycle_length = rock_count - prev_rock_count
                    cycle_height = current_height - prev_height
                    rocks_remaining = num_rocks - rock_count
                    cycles_remaining = rocks_remaining / cycle_length
                    height_gain = cycles_remaining * cycle_height
                    rock_count += cycles_remaining * cycle_length + 1   # I don't know why +1 is necessary :/

                    puts "\tcycle length #{cycle_length}, cycle height #{cycle_height}, rocks_remaining #{rocks_remaining}, cycles_remaining #{cycles_remaining}, height_gain #{height_gain}"
                    puts "\trock count is now #{rock_count}"

                    # re-apply the top contour at the new height
                    top_contour.each_with_index do |offset_height, x|
                        @fill.add(Point.new(x, current_height + height_gain - offset_height))
                    end
                else
                    @states[state] = [rock_count, current_height]
                end
            end
            play_rock
            rock_count += 1
        end
    end

    def play_rock
        rock = Rock.new(@@rock_shapes[@@rock_order[@rock_index]]).apply(Point.new(2, height + 4))
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
            in_bounds = try_move.points.all? { |point| point.x >= 0 and point.x < @@chamber_width}
            no_fill_collision = @fill.intersection(try_move.points.to_set).empty?

            if in_bounds and no_fill_collision
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
    chamber.simulate_rocks(2022)
    puts chamber.height
end

def part2(input)
    chamber = Chamber.new(input)
    chamber.simulate_rocks(1_000_000_000_000)
    puts chamber.height
end

part1(input)
part2(input)
