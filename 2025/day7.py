from dataclasses import dataclass

@dataclass(frozen=True)
class Node():
    depth: int
    col: int

def read_input():
    input = []
    with open('input/day7.txt', 'r') as input_file:
        input = [v for v in input_file.readlines()]
    return input

def build_universes(input, row, col, universes):
    if row < len(input):
        row_str = input[row]
        node = row_str[col]
        if node == '^':
            # go left
            new_universe = input[:]
            new_universe[row] = row_str[:col] + "/" + row_str[col + 1:]
            if row + 1 < len(input):
                build_universes(new_universe, row+1, col-1, universes)
            else:
                universes.append(new_universe)
            # go right
            new_universe = input[:]
            new_universe[row] = row_str[:col] + "\\" + row_str[col + 1:]
            if row + 1 < len(input):
                build_universes(new_universe, row+1, col+1, universes)
            else:
                universes.append(new_universe)
        else:
            # go straight
            new_universe = input.copy()
            new_universe[row] = row_str[:col] + "|" + row_str[col + 1:]
            if row + 1 < len(input):
                build_universes(new_universe, row+1, col, universes)
            else:
                universes.append(new_universe)
    return universes

def find_splitter_indices(input):
    start = 0
    while True:
        start = input.find("^", start)
        if start == -1: return
        yield start
        start += 1

def part1(input):
    num_splits = 0
    beam_cols = set([input[0].index("S")])
    for level in enumerate(input):
        splitters = list(find_splitter_indices(level))
        new_beam_cols = set()
        for beam in beam_cols:
            if beam in splitters:
                num_splits += 1
                new_beam_cols.add(beam - 1)
                new_beam_cols.add(beam + 1)
            else:
                new_beam_cols.add(beam)
        beam_cols = new_beam_cols
    print(f"Part 1: {num_splits}")

def part2(input):
    # this is way too slow for real input:
    #universes = build_universes(input, 0, input[0].index("S"), [])
    #for universe in universes:
    #    print(f"universe:\n{"".join(universe)}")

    start_row = input[0]
    universe_tracker = [0] * len(start_row)
    universe_tracker[start_row.index("S")] = 1
    for level in enumerate(input):
        splitter_indices = list(find_splitter_indices(level))
        for splitter_i in splitter_indices:
            universe_tracker[splitter_i-1] += universe_tracker[splitter_i]
            universe_tracker[splitter_i+1] += universe_tracker[splitter_i]
            universe_tracker[splitter_i] = 0
    print(f"Part 2: {sum(universe_tracker)}")

input = read_input()
part1(input)
part2(input)