grid = ARGF.read.split("\n").map { |line| line.chars }

@directions = {
    "U" => [0, 1],
    "D" => [0, -1],
    "L" => [-1, 0],
    "R" => [1, 0]
}

def part1(grid)
    end_v = find_vertex(grid, 'E')
    
    dists = {}
    dists[end_v] = 0
    dist = 0

    end_elevation = elevation(grid, end_v)
    neighbours = find_previous_neighbours(grid, end_v)

    while not neighbours.empty?
        dist += 1
        new_neighbours = []

        neighbours.each do |neighbour|
            #puts "checking [#{neighbour.join(',')}] #{grid_at(grid, neighbour)}..."
            if not dists.has_key?(neighbour)
                dists[neighbour] = dist
                neighbour_neighbours = find_previous_neighbours(grid, neighbour).filter { |n| !dists.has_key?(n) }
                #puts "new neighbours are " + neighbour_neighbours.map { |n| "[#{n.join(',')}]" }.join(', ')
                new_neighbours += neighbour_neighbours
            end
        end

        neighbours = new_neighbours
    end

    puts dists[find_vertex(grid, 'S')] || "S not found!"
end

def grid_at(grid, vertex)
    grid[vertex[1]][vertex[0]]
end

def elevation(grid, vertex)
    v = grid_at(grid, vertex)
    if v == "S"
        0
    elsif v == "E"
        27
    else
        v.ord - 96 # a = 0, b = 1, ...
    end
end

def find_vertex(grid, target)
    grid.each_with_index do |row, y|
        start_index = row.index(target)
        if start_index
            return [start_index, y]
        end
    end
end

def find_neighbour_vertices(grid, vertex)
    row_len = grid.length
    col_len = grid[0].length
    neighbours = []
    @directions.values.each do |vector|
        n_x = vertex[0] + vector[0]
        n_y = vertex[1] + vector[1]
        if n_x >= 0 and n_x < col_len and n_y >= 0 and n_y < row_len
            neighbours.push([n_x, n_y])
        end
    end
    neighbours
end

def find_previous_neighbours(grid, vertex)
    vertex_elevation = elevation(grid, vertex)
    valid_elevations = [vertex_elevation, vertex_elevation - 1]
    find_neighbour_vertices(grid, vertex).select { |v| elevation(grid, v) >= vertex_elevation - 1 }
end

def all_vertices(grid)
    vertices = []
    (0...grid.length).each do |y|
        (0...grid[0].length).each do |x|
            vertices.push([x, y])
        end
    end
    vertices
end

part1(grid)
