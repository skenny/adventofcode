input = ">>><<><>><<<>><>>><<<>>><<<><<<>><>><<>>"

class Rock
    attr_accessor :height, :width

    def initialize(shape_str)
        @shape_str = shape_str
        @shape_arr = shape_str.split("\n").map(&:chars)
        @height = @shape_arr.length
        @width = @shape_arr[0].length
    end

    def position
        [@x, @y]
    end

    def position_at(x, bottom_y)
        @x = x
        @y = bottom_y + @height
    end

    def top_left
        [@x, @y]
    end

    def top_right
        [@x + @width, @height]
    end

    def bottom_left
        [@x, @y - @height]
    end

    def bottom_right
        [@x + @width, @y - @height]
    end

    def move_down
        @y -= 1
    end

    def move_right
        @x += 1
    end

    def move_left
        @x -= 1
    end
    
    def to_s
        "[#{@x},#{@y}]"
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
        Rock.new(@@rock_shapes[@@rock_order[next_index]])
    end
end

class Chamber
    @@chamber_width = 7

    def initialize(jet_pattern)
        @jet_pattern = jet_pattern
        @jet_index = 0
        @settled_rocks = []
        @active_rock = nil
    end

    def draw
        # TODO draw active and settled rocks
        puts "+" + ("-" * @@chamber_width) + "+"
    end

    def height
        @settled_rocks.map { |rock_position| rock_position.top_left[1] }.max || 0
    end

    def can_active_rock_move_left
        # TODO left collision with settled rock
        @active_rock.top_left[0] > 0
    end

    def can_active_rock_move_right
        # TODO right collision with settled rock
        @active_rock.top_right[0] < @@chamber_width
    end

    def apply_jet
        jet_direction = @jet_pattern[@jet_index]
        @jet_index = (@jet_index + 1) % @jet_pattern.length
        if jet_direction == "<"
            if can_active_rock_move_left
                puts "Jet of gas pushes rock left:"
                @active_rock.move_left
            else 
                puts "Jet of gas pushes rock left, but nothing happens:"
            end
        else
            if can_active_rock_move_right
                puts "Jet of gas pushes rock right:"
                @active_rock.move_right 
            else
                puts "Jet of gas pushes rock right, but nothing happens:"
            end
        end
    end

    def drop
        if @active_rock.bottom_left[1] == 0
            puts "Rock falls 1 unit, causing it to come to rest:"
            # TODO this might be a problem when we null out active rock? maybe actually freeze the # into a 2d array?
            @settled_rocks.push(@active_rock)
            @active_rock = nil
        elsif false
            # TODO bottom collision with settled rock
        else
            puts "Rock falls 1 unit:"
            @active_rock.move_down
        end
    end

    def play_rock(rock)
        puts "A new rock begins falling:"
        @active_rock = rock
        @active_rock.position_at(2, height + 3)
        step = 0
        while @active_rock
            step % 2 == 0 ? apply_jet : drop
            step += 1
        end
    end
end

chamber = Chamber.new(input)
rock_generator = RockGenerator.new

5.times do 
    chamber.play_rock(rock_generator.next_rock)
end
