import math
import re

def read_input():
    input = []
    with open('input/day6-test.txt', 'r') as input_file:
        input = [v for v in input_file.readlines()]
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
    ops_line = input[-1]
    ops_padded = re.findall(r"([*+]\s+)", ops_line)

    totals = []
    offset = 0

    for i, op in enumerate(ops_padded):
        # remove the extra space (the divider between columns) after every operator except the last one
        if i != len(ops_padded) - 1:
            op = op[:-1]
        
        col_width = len(op)
        nums = list(map(lambda l: l[offset:offset+col_width], input[:-1]))
        offset += col_width + 1
        
        nums_t = []
        for i in range(col_width - 1, -1, -1):
            digits = []
            for num in nums:
                digits.append(num[i])
            nums_t.append(int("".join(digits)))

        if op.strip() == '*':
            totals.append(math.prod(nums_t))
        else:
            totals.append(sum(nums_t))

    total = sum(totals)
    print(f"Part 2: {total}")
    
input = read_input()
part1(input)
part2(input)