grid = ARGF.read.split("\n").map { |line| line.chars }

@directions = {
    "U" => [0, 1],
    "D" => [0, -1],
    "L" => [-1, 0],
    "R" => [1, 0]
}

def compute_dists(grid)
    the_end = find_letters(grid, 'E')[0]
    neighbours = find_accessible_neighbours(grid, the_end)
    dist = 0
    
    dists = {}
    dists[the_end] = dist

    while not neighbours.empty?
        dist += 1

        new_neighbours = []
        neighbours.each do |neighbour|
            if not dists.has_key?(neighbour)
                dists[neighbour] = dist
                new_neighbours += find_accessible_neighbours(grid, neighbour)
            end
        end

        neighbours = new_neighbours
    end

    dists
end

def find_start(grid)
    find_letters(grid, 'S')[0]
end

def find_end(grid)
    find_letters(grid, 'E')[0]
end

def find_letters(grid, target_letter)
    matches = []
    grid.each_with_index do |row, y|
        start_index = row.index(target_letter)
        if start_index
            matches.push([start_index, y])
        end
    end
    matches
end

def find_neighbours(grid, vertex)
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

def find_accessible_neighbours(grid, vertex)
    vertex_elevation = read_elevation(grid, vertex)
    find_neighbours(grid, vertex).select { |v| read_elevation(grid, v) >= vertex_elevation - 1 }
end

def read_elevation(grid, vertex)
    grid_val = grid[vertex[1]][vertex[0]]
    if grid_val == "S"
        1
    elsif grid_val == "E"
        26
    else
        # a = 1, b = 2, ...
        grid_val.ord - 96
    end
end

dists = compute_dists(grid)
puts dists[find_start(grid)]
puts find_letters(grid, 'a').map { |a| dists[a] }.min
