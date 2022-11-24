import math

INPUT_FILE = "day11-input"
TEST_INPUT_FILE = "day11-input-test"

OCCUPIED = "#"
EMPTY = "L"

def read_input(file):
    with open(file, "r") as fin:
        return [list(l.strip()) for l in fin.readlines()]

def fill_seats(grid, occupied_seat_counter, occupied_threshold):
    #print("fill seats using", occupied_seat_counter, occupied_threshold)

    working_grid = [row.copy() for row in grid]
    iteration = 1

    while True:
        new_grid = []
        num_seats_changed = 0

        #print_grid(working_grid)

        for i, row in enumerate(working_grid):
            new_row = []
            for j, col in enumerate(row):
                occupied_seats = 0
                if not col == ".":
                    occupied_seats = occupied_seat_counter(working_grid, i, j)
                if col == EMPTY and occupied_seats == 0:
                    new_row.append(OCCUPIED)
                    num_seats_changed += 1
                elif col == OCCUPIED and occupied_seats >= occupied_threshold:
                    new_row.append(EMPTY)
                    num_seats_changed += 1
                else:
                    new_row.append(col)
            new_grid.append(new_row)

        if num_seats_changed == 0:
            break
        
        working_grid = new_grid
        iteration += 1

    return count_occupied_grid_seats(working_grid)

def count_occupied_grid_seats(grid):
    return sum(list(map(lambda row: row.count(OCCUPIED), grid)))

def count_occupied_adjacent_seats(grid, row, col):
    num_rows = len(grid)
    num_cols = len(grid[0])
    offsets = (-1, 0, 1)

    adjacent_seats = []
    for i in offsets:
        r = row + i
        for j in offsets:
            c = col + j
            if not (i == 0 and j == 0) and 0 <= r < num_rows and 0 <= c < num_cols:
                adjacent_seats.append(grid[r][c])
    
    return adjacent_seats.count(OCCUPIED)

def count_occupied_in_sight_seats(grid, row, col):
    num_rows = len(grid)
    num_cols = len(grid[0])

    visible_seats = []
    for vector in [(-1, 0), (-1, 1), (0, 1), (1, 1), (1, 0), (1, -1), (0, -1), (-1, -1)]:
        offset = 1
        while True:
            r, c = (row + vector[0] * offset, col + vector[1] * offset)
            if not (0 <= r < num_rows and 0 <= c < num_cols):
                break
            seat = grid[r][c]
            if seat != ".":
                visible_seats.append(seat)
                break
            offset += 1

    return visible_seats.count(OCCUPIED)

def print_grid(grid):
    [print("".join(r)) for r in grid]
    print("-" * len(grid[0]))

def run(label, input_file):
    grid = read_input(input_file)
    print("{} 1: {}".format(label, fill_seats(grid, count_occupied_adjacent_seats, 4)))
    print("{} 2: {}".format(label, fill_seats(grid, count_occupied_in_sight_seats, 5)))

run("test", TEST_INPUT_FILE)
run("part", INPUT_FILE)