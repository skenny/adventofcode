input = []
with open('input/day4.txt', 'r') as input_file:
    input = [v.strip() for v in input_file.readlines()]

def is_moveable(grid, y, x):
    grid_width = len(grid[0])
    grid_height = len(grid)
    rolls_seen = 0
    for d_y in [-1, 0, 1]:
        for d_x in [-1, 0, 1]:
            # skip our current cell
            if (d_y == 0 and d_x == 0):
                continue
            check_y = y+d_y
            check_x = x+d_x
            # skip out of bounds cells
            if check_y < 0 or check_y >= grid_height or check_x < 0 or check_x >= grid_width:
                continue
            rolls_seen += 1 if grid[y+d_y][x+d_x] == '@' else 0
    return rolls_seen < 4

def part1(grid):
    grid_width = len(grid[0])
    grid_height = len(grid)
    moveable_rolls = 0
    for y in range(0, grid_height):
        for x in range(0, grid_width):
            contents = input[y][x]
            if contents == '@':
                if is_moveable(grid, y, x):
                    moveable_rolls += 1
    print(f"Part 1: {moveable_rolls}")

def part2():
    print("Part 2:")

part1(input)
part2()