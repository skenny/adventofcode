@face_directions = [
    [1, 0, 0],
    [-1, 0, 0],
    [0, 1, 0],
    [0, -1, 0],
    [0, 0, 1],
    [0, 0, -1]
]

def build_world(droplets)
    # find the dimensions of the lava structure
    x_max = 0
    y_max = 0
    z_max = 0
    droplets.each do |droplet|
        x, y, z = droplet
        x_max = [x, x_max].max
        y_max = [y, y_max].max
        z_max = [z, z_max].max
    end

    # create a 3d world array filled with air
    world = Array.new(z_max + 2) { Array.new(y_max + 2) { Array.new(x_max + 2, :air) } }

    # add the lava droplets
    droplets.each do |droplet|
        set(world, droplet, :lava)
    end

    # flood with water
    flood_fill(world, [[0,0,0]], :water)

    #print_world(world)

    world
end

def print_world(world)
    world.each_with_index do |z_layer, z|
        puts "Layer #{z}:"
        z_layer.each do |y_column|
            puts "\t" + y_column.map { |p| p == :air ? '.' : p == :water ? '~' : '#' }.join
        end
        puts ""
    end
end

def flood_fill(world, points, fill)
    while not points.empty?
        next_points = []
        points.each { |point|
            set(world, point, fill)
            next_neighbours = find_neighbours(world, point).select { |neighbour|
                is_in_bounds(world, neighbour) and get(world, neighbour) == :air
            }
            # I should just figure out how to use sets in ruby...
            next_points = (next_points + next_neighbours).uniq
        }
        points = next_points
    end
end

def find_neighbours(world, point)
    x, y, z = point
    @face_directions.map do |face_direction|
        f_x, f_y, f_z = face_direction
        [x + f_x, y + f_y, z + f_z]
    end
end

def is_in_bounds(world, point)
    x, y, z = point
    x_bounds = (0...world[0][0].size)
    y_bounds = (0...world[0].size)
    z_bounds = (0...world.size)
    x_bounds.include?(x) and y_bounds.include?(y) and z_bounds.include?(z)
end

def get(world, point)
    x, y, z = point
    world[z][y][x]
end

def set(world, point, fill)
    x, y, z = point
    world[z][y][x] = fill
end

def part1(world, droplets)
    puts droplets.map { |droplet|
        find_neighbours(world, droplet).count do |neighbour|
            not is_in_bounds(world, neighbour) or get(world, neighbour) != :lava
        end
    }.reduce(:+)
end

def part2(world, droplets)
    puts droplets.map { |droplet|
        find_neighbours(world, droplet).count do |neighbour|
            not is_in_bounds(world, neighbour) or get(world, neighbour) == :water
        end
    }.reduce(:+)
end

input = ARGF.read.split("\n")
droplets = input.map { |droplet_str| droplet_str.split(',').map(&:to_i) }
world = build_world(droplets)

part1(world, droplets)
part2(world, droplets)
