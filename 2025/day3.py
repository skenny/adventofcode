input = []
with open('input/day3.txt', 'r') as input_file:
    input = input_file.readlines()

def part1():
    joltages = []
    for battery_bank in input:
        max_joltage = 0
        for i in range(0, len(battery_bank) - 1):
            for j in range(i + 1, len(battery_bank)):
                joltage = int(battery_bank[i] + battery_bank[j])
                max_joltage = max(joltage, max_joltage)
        joltages.append(max_joltage)
    print(f"Part 1: {sum(joltages)}")

def part2():
    output = 0
    print(f"Part 2: {output}")

part1()
part2()
