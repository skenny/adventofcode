Point = Struct.new(:x, :y) do

    def neighbours
        points = []

        # nw, n, ne, w, e, sw, s, se
        [-1, 0, 1].each do |n_y|
            [-1, 0, 1].each do |n_x|
                if n_x == 0 and n_y == 0
                    next
                end
                points.push(Point.new(x + n_x, y + n_y))
            end
        end
        points
    end

    def inspect
        "[#{x},#{y}]"
    end

    def to_s
        "[#{x},#{y}]"
    end

end

def play_rounds(elves, round_limit=nil)
    directions = [Point.new(0, -1), Point.new(0, 1), Point.new(-1, 0), Point.new(1, 0)]
    rounds_played = 0

    loop do
        # quick elf position lookup
        elf_lookup = Hash[elves.map { |elf| [elf, true] }]

        # first half, for each elf consider all neighbours; if none, the elf doesn't participate in the round
        participating_elves = {}
        elves.each_with_index do |point, i|
            neighbours = point.neighbours
            participating_elves[i] = neighbours if neighbours.any? { |p| elf_lookup.has_key?(p) }
        end

        break if participating_elves.empty?

        # second half, each elf with neighbours proposes a move based on the current direction
        proposed_moves = []
        participating_elves.each do |elf_i, neighbours|
            nw, n, ne, w, e, sw, s, se = neighbours
            directions.each do |direction|
                if direction.y == -1    # north
                    if [nw, n, ne].none? { |p| elf_lookup.has_key?(p) }
                        proposed_moves.push([elf_i, n]) 
                        break
                    end
                elsif direction.y == 1  # south
                    if [sw, s, se].none? { |p| elf_lookup.has_key?(p) }
                        proposed_moves.push([elf_i, s])
                        break
                    end
                elsif direction.x == -1 # west
                    if [nw, w, sw].none? { |p| elf_lookup.has_key?(p) }
                        proposed_moves.push([elf_i, w])
                        break
                    end
                elsif direction.x == 1  # east
                    if [ne, e, se].none? { |p| elf_lookup.has_key?(p) }
                        proposed_moves.push([elf_i, e])
                        break
                    end
                end
            end
        end

        # apply unique position moves
        proposed_moves
            .group_by { |elf_i, point| point }
            .select { |point, referenced_moves| referenced_moves.size == 1 }
            .each { |point, unique_moves| elves[unique_moves[0][0]] = point }

        # rotate directions backwards one step (first -> last, second -> first, etc)
        directions.rotate!(directions.size + 1)

        rounds_played += 1
        break if round_limit and round_limit == rounds_played
    end

    rounds_played
end

def rasterize(elves)
    min_x, max_x = elves.map(&:x).minmax
    min_y, max_y = elves.map(&:y).minmax
    raster = ""
    (min_y..max_y).each do |y|
        (min_x..max_x).each do |x|
            p = Point.new(x,y)
            raster += elves.include?(p) ? "#" : "."
        end
        raster += "\n"
    end
    puts raster
end

def parse_input(input)
    elves = []
    input.each_with_index do |row, y|
        row.chars.each_with_index do |contents, x|
            elves.push(Point.new(x, y)) if contents == '#'
        end
    end
    elves
end

def part1(input)
    elves = parse_input(input)
    rounds_played = play_rounds(elves, 10)
    min_x, max_x = elves.map(&:x).minmax
    min_y, max_y = elves.map(&:y).minmax
    puts (max_x - min_x + 1) * (max_y - min_y + 1) - elves.size
end

def part2(input)
    elves = parse_input(input)
    rounds_played = play_rounds(elves)
    puts rounds_played + 1
end

input = ARGF.read.split("\n")

part1(input)
part2(input)
