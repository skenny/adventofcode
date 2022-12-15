input = ARGF.read.split("\n")

def plot_cave(input)
    cave = {}
    max_y = 0
    input.each do |line|
        # 498,4 -> 498,6 -> 496,6
        coords = line.split(' -> ').map { |coord| coord.split(',').map(&:to_i) }
        c1 = coords.shift
        while !coords.empty?
            c2 = coords.shift
            x_range = ([c1[0], c2[0]].min..[c1[0], c2[0]].max)
            y_range = ([c1[1], c2[1]].min..[c1[1], c2[1]].max)
            x_range.each do |x|
                y_range.each do |y|
                    max_y = [max_y, y].max
                    cave[[x,y]] = '#'
                end
            end
            c1 = c2
        end
    end
    [cave, max_y + 2]
end

def part1(input)
    cave, floor_y = plot_cave(input)

    sand_origin = [500, 0]
    sand_count = 0

    loop do
        x, y = sand_origin
        came_to_rest = false

        loop do
            if y >= 1000
                break
            end
    
            if cave[[x, y+1]] == nil
                y += 1
            elsif cave[[x-1, y+1]] == nil
                x -= 1
                y += 1
            elsif cave[[x+1, y+1]] == nil
                x += 1
                y += 1
            else
                # blocked
                cave[[x,y]] = 'o'
                came_to_rest = true
                break
            end
        end
    
        break if not came_to_rest
        sand_count += 1
    end

    puts "dropped #{sand_count} units of sand"
end

def part2(input)
    cave, floor_y = plot_cave(input)

    sand_origin = [500, 0]
    sand_count = 0

    while cave[sand_origin] == nil
        x, y = sand_origin

        loop do
            if cave[[x, y+1]] == nil and y+1 < floor_y
                y += 1
            elsif cave[[x-1, y+1]] == nil and y+1 < floor_y
                x -= 1
                y += 1
            elsif cave[[x+1, y+1]] == nil and y+1 < floor_y
                x += 1
                y += 1
            else
                # blocked
                cave[[x,y]] = 'o'
                break
            end
        end
    
        sand_count += 1
    end

    puts "dropped #{sand_count} units of sand"
end

part1(input)
part2(input)
