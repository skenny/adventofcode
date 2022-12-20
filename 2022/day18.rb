require 'set'

class World

    @@face_directions = [
        [1, 0, 0],
        [-1, 0, 0],
        [0, 1, 0],
        [0, -1, 0],
        [0, 0, 1],
        [0, 0, -1]
    ]

    def initialize(x_max, y_max, z_max, fill)
        @x_max = x_max + 1
        @y_max = y_max + 1
        @z_max = z_max + 1
        @world = Array.new(@z_max) { Array.new(@y_max) { Array.new(@x_max, fill) } }
    end

    def fill(points, fill)
        points.each { |point| set(point, fill) }
    end

    def flood_fill(points, fill)
        while not points.empty?
            next_points = Set.new
            points.each { |point|
                set(point, fill)
                next_points += find_neighbours(point).select { |neighbour|
                    is_in_bounds(neighbour) and get(neighbour) == :air
                }
            }
            points = next_points
        end
    end
        
    def find_neighbours(point)
        @@face_directions.map { |dir| [point, dir].transpose.map(&:sum) }
    end

    def is_in_bounds(point)
        x, y, z = point
        (0...@x_max).include?(x) and (0...@y_max).include?(y) and (0...@z_max).include?(z)
    end

    def set(point, fill)
        x, y, z = point
        @world[z][y][x] = fill
    end

    def get(point)
        x, y, z = point
        @world[z][y][x]
    end

    def print
        (0...@z_max).each do |z|
            puts "Layer #{z}:"
            (0...@y_max).each do |y|
                puts "\t" + ("%02d" % y) + @world[z][y].map { |p| p == :air ? '.' : p == :water ? '~' : '#' }.join
            end
        end
    end
    
end

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

    world = World.new(x_max, y_max, z_max, :air)
    world.fill(droplets, :lava)
    world.flood_fill([[0, 0, 0]], :water)
    world
end

def part1(world, droplets)
    puts droplets.map { |droplet|
        world.find_neighbours(droplet).count do |neighbour|
            not world.is_in_bounds(neighbour) or world.get(neighbour) != :lava
        end
    }.reduce(:+)
end

def part2(world, droplets)
    puts droplets.map { |droplet|
        world.find_neighbours(droplet).count do |neighbour|
            not world.is_in_bounds(neighbour) or world.get(neighbour) == :water
        end
    }.reduce(:+)
end

input = ARGF.read.split("\n")
droplets = input.map { |droplet_str| droplet_str.split(',').map(&:to_i) }
world = build_world(droplets)

part1(world, droplets)
part2(world, droplets)
