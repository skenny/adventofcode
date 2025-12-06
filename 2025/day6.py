import math

def read_input():
    input = []
    with open('input/day6.txt', 'r') as input_file:
        input = [v.strip() for v in input_file.readlines()]
    return input

def part1(input):
    input = list(map(lambda l: l.split(), input))
    totals = []
    for col in range(0, len(input[0])):
        nums = list(map(lambda l: int(l[col]), input[:-1]))
        op = input[-1][col]
        if op == '*':
            totals.append(math.prod(nums))
        else:
            totals.append(sum(nums))
    total = sum(totals)
    print(f"Part 1: {total}")

def part2(input):
    print("Part 2:")
    
input = read_input()
part1(input)
part2(input)