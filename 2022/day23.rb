Point = Struct.new(:x, :y) do

    def plus(delta)
        Point.new(x + delta.x, y + delta.y)
    end

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

input = ARGF.read.split("\n")

elves = []
input.each_with_index do |row, y|
    row.chars.each_with_index do |contents, x|
        elves.push(Point.new(x, y)) if contents == '#'
    end
end

directions = [Point.new(0, -1), Point.new(0, 1), Point.new(-1, 0), Point.new(1, 0)]

10.times do |round_num|
    puts "round #{round_num}"

    # first half, for each elf consider all neighbours; if none, the elf doesn't participate in the round
    participating_elves = {}
    elves.each_with_index do |point, i|
        neighbours = point.neighbours
        participating_elves[i] = [point, neighbours] if neighbours.any? { |p| elves.include?(p) }
    end

    # second half, each elf with neighbours proposes a move based on the current direction
    proposed_moves = []
    participating_elves.each do |elf_i, v|
        point, neighbours = v
        nw, n, ne, w, e, sw, s, se = neighbours
        directions.each do |direction|
            if direction.y == -1    # north
                if [nw, n, ne].none? { |p| elves.include?(p) }
                    #puts "elf #{elf_i} at #{point} proposes going north to #{n}"
                    proposed_moves.push([elf_i, n]) 
                    break
                end
            elsif direction.y == 1  # south
                if [sw, s, se].none? { |p| elves.include?(p) }
                    #puts "elf #{elf_i} at #{point} proposes going south to #{s}"
                    proposed_moves.push([elf_i, s])
                    break
                end
            elsif direction.x == -1 # west
                if [nw, w, sw].none? { |p| elves.include?(p) }
                    #puts "elf #{elf_i} at #{point} proposes going west to #{w}"
                    proposed_moves.push([elf_i, w])
                    break
                end
            elsif direction.x == 1  # east
                if [ne, e, se].none? { |p| elves.include?(p) }
                    #puts "elf #{elf_i} at #{point} proposes going east to #{e}"
                    proposed_moves.push([elf_i, e])
                    break
                end
            end
        end
    end

    # filter out proposed moves that go to the same position, then apply the unique position moves
    proposed_move_points = proposed_moves.map { |elf_i, point| point }
    proposed_moves
        .keep_if { |elf_i, point| proposed_move_points.count(point) == 1 }
        .each { |elf_i, point| elves[elf_i] = point }

    # rotate directions backwards one step (first -> last, second -> first, etc)
    directions.rotate!(directions.size + 1)
end

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

puts (min_x..max_x).size * (min_y..max_y).size - elves.size
