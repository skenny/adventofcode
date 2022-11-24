input = []
with open('day1-input', 'r') as input_file:
    #input = list(map(lambda v: int(v), input_file.readlines()))
    input = [int(v) for v in input_file.readlines()]

def part1():
    for i in range(len(input)):
        v1 = input[i]
        for v2 in input[i+1:]:
            if v1 + v2 == 2020:
                print('part 1:', v1, v2, v1*v2)

def part2():
    for i in range(len(input)):
        v1 = input[i]
        v2_input = input[i+1:]
        for j, v2 in enumerate(v2_input):
            for v3 in v2_input[j+1:]:
                if v1 + v2 + v3 == 2020:
                    print('part 2:', v1, v2, v3, v1*v2*v3)

def part2_2():
    for i in range(len(input)):
        for j in range(i+1, len(input)):
            for k in range(j+1, len(input)):
                v1 = input[i]
                v2 = input[j]
                v3 = input[k]
                if v1 + v2 + v3 == 2020:
                    print('part 2:', v1, v2, v3, v1*v2*v3)

part1()
part2_2()
