input = ARGF.read.split("\n")

def plot_cave(input)
    cave = {}
    input.each do |line|
        # 498,4 -> 498,6 -> 496,6
        coords = line.split(' -> ').map { |coord| coord.split(',').map(&:to_i) }
        c1 = coords.shift
        while !coords.empty?
            c2 = coords.shift
            x_range = ([c1[0], c2[0]].min..[c1[0], c2[0]].max)
            y_range = ([c1[1], c2[1]].min..[c1[1], c2[1]].max)
            #puts "rendering #{c1} -> #{c2} with ranges #{x_range}, #{y_range}"
            x_range.each do |x|
                y_range.each do |y|
                    cave[[x,y]] = '#'
                end
            end
            c1 = c2
        end
    end
    cave
end

def drop_sand(origin, cave)
    x, y = origin

    loop do
        # TODO compute max rock depth when plotting the cave
        if y >= 1000
            return false
        end

        #puts "sand at [#{x},#{y}]"

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
            return true
        end
    end
end

def part1(input)
    cave = plot_cave(input)
    sand_origin = [500, 0]
    sand_count = 0
    loop do
        break if not drop_sand(sand_origin, cave)
        sand_count += 1
    end
    puts "dropped #{sand_count} units of sand"
end

def part2(input)
end

part1(input)
#part2(input)
