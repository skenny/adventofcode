input = File.read("2022/day8input.txt").split("\n")

def part1(grid)
    cols = grid[0].length
    rows = grid.length
    visible_trees = 0

    (0...rows).each do |y|
        (0...cols).each do |x|
            tree_height = grid[y][x]

            # check edges
            if y == 0 || y == rows-1 || x == 0 || x == cols-1
                visible_trees += 1
                next
            end

            visible_left = (0...x).all?      { |l_x| grid[y][l_x] < tree_height }
            visible_right = (x+1...cols).all? { |r_x| grid[y][r_x] < tree_height }
            visible_up = (0...y).all?        { |u_y| grid[u_y][x] < tree_height }
            visible_down = (y+1...rows).all?  { |d_y| grid[d_y][x] < tree_height }
            visible_trees += 1 if visible_left || visible_right || visible_up || visible_down
        end
    end

    visible_trees
end

puts part1(input)