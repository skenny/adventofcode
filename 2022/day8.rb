input = File.read("2022/day8input.txt").split("\n")
#input = File.read("2022/day8testinput.txt").split("\n")

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

            visible_left = (0...x).all?       { |l_x| grid[y][l_x] < tree_height }
            visible_right = (x+1...cols).all? { |r_x| grid[y][r_x] < tree_height }
            visible_up = (0...y).all?         { |u_y| grid[u_y][x] < tree_height }
            visible_down = (y+1...rows).all?  { |d_y| grid[d_y][x] < tree_height }

            visible_trees += 1 if visible_left or visible_right or visible_up or visible_down
        end
    end

    visible_trees
end

def part2(grid)
    cols = grid[0].length
    rows = grid.length
    top_scenic_score = 0

    (0...rows).each do |y|
        (0...cols).each do |x|
            tree_height = grid[y][x]

            visible_left = x - ((x-1).downto(0).find { |l_x| grid[y][l_x] >= tree_height } || 0)
            visible_right = ((x+1...cols).find       { |r_x| grid[y][r_x] >= tree_height } || cols - 1) - x
            visible_up = y - ((y-1).downto(0).find   { |u_y| grid[u_y][x] >= tree_height } || 0)
            visible_down = ((y+1...rows).find        { |d_y| grid[d_y][x] >= tree_height } || rows - 1) - y

            scenic_score = visible_left * visible_right * visible_up * visible_down
            top_scenic_score = [scenic_score, top_scenic_score].max
        end
    end

    top_scenic_score
end

puts part1(input)
puts part2(input)