from dataclasses import dataclass

@dataclass(frozen=True)
class Node():
    depth: int
    col: int

def read_input():
    input = []
    with open('input/day7-test.txt', 'r') as input_file:
        input = [v for v in input_file.readlines()]
    return input

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
    for depth, level in enumerate(input):
        #print(f"at depth {depth}, tracking beams at {beam_cols}; there have been {num_splits} splits...")
        splitters = list(find_splitter_indices(level))
        #print(f"\tfound splitters at {splitters}")
        new_beam_cols = set()
        for beam in beam_cols:
            if beam in splitters:
                #print(f"\tbeam {beam} splits!")
                num_splits += 1
                new_beam_cols.add(beam - 1)
                new_beam_cols.add(beam + 1)
            else:
                new_beam_cols.add(beam)
        beam_cols = new_beam_cols
    print(f"Part 1: {num_splits}")

def part2(input):
    universes = []

    # try a recursive function that builds/returns a path str, always taking the left first, then the right

    print(f"Part 2: {len(universes)}")   # 3291 is too low

input = read_input()
part1(input)
part2(input)