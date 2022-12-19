cubes = ARGF.read.split("\n").map { |cube_s| cube_s.split(',').map(&:to_i) }

cube_faces = [
    [1, 0, 0],
    [-1, 0, 0],
    [0, 1, 0],
    [0, -1, 0],
    [0, 0, 1],
    [0, 0, -1]
]

cube_lookup = {}
cubes.each do |cube|
    cube_lookup[cube] = true
end

puts cubes.map { |cube|
    x, y, z = cube
    cube_faces.count do |face|
        f_x, f_y, f_z = face
        not cube_lookup.has_key?([x + f_x, y + f_y, z + f_z])
    end
}.reduce(:+)
