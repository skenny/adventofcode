def read_input(test):
    file = "dayN"
    if test: file += "-test"
    input = []
    with open(f'input/{file}.txt', 'r') as input_file:
        input = [v.strip() for v in input_file.readlines()]
    return input

def part1(input):
    print("Part 1:")

def part2(input):
    print("Part 2:")

input = read_input(True)
part1(input)
part2(input)
