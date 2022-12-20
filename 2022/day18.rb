droplets = ARGF.read.split("\n").map { |point_s| point_s.split(',').map(&:to_i) }

face_directions = [
    [1, 0, 0],
    [-1, 0, 0],
    [0, 1, 0],
    [0, -1, 0],
    [0, 0, 1],
    [0, 0, -1]
]

world = {}
x_range = [99, 0]
y_range = [99, 0]
z_range = [99, 0]
droplets.each do |droplet|
    x, y, z = droplet
    world[droplet] = :lava
    x_range = [[x, x_range[0]].min, [x, x_range[1]].max]
    y_range = [[y, y_range[0]].min, [y, y_range[1]].max]
    z_range = [[z, z_range[0]].min, [z, z_range[1]].max]
end

puts "ranges are #{x_range}, #{y_range}, #{z_range}"

surface_area = droplets.map { |droplet|
    x, y, z = droplet
    face_directions.count do |face_direction|
        f_x, f_y, f_z = face_direction
        neighbour = [x + f_x, y + f_y, z + f_z]
        not world.has_key?(neighbour)
    end
}.reduce(:+)

puts surface_area
