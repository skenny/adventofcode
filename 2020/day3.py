input = []
with open('day3-input', 'r') as input_file:
    input = [l.strip() for l in input_file.readlines()]

def traverse(dX, dY):
    x = 0
    y = 0
    tree_count = 0
    while y < len(input):
        row = input[y]
        c = row[x % len(row)]
        if c == "#":
            tree_count += 1
        x += dX
        y += dY
    return tree_count

def part1():
    print('part 1: encountered', traverse(3, 1), 'trees')

def part2():
    print('part 2: encountered', traverse(1, 1) * traverse(3, 1) * traverse(5, 1) * traverse(7, 1) * traverse(1, 2), 'trees')

part1()
part2()