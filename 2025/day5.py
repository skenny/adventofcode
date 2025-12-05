def read_input():
    input = []
    with open('input/day5.txt', 'r') as input_file:
        input = [v.strip() for v in input_file.readlines()]
    return input

def parse_input(input):
    fresh_ingredient_ranges = []
    available_ingredients = []
    pre_split = True
    for line in input:
        if line == '':
            pre_split = False
            continue
        if pre_split:
            low, high = line.split('-')
            fresh_ingredient_ranges.append(range(int(low), int(high) + 1))
        else:
            available_ingredients.append(int(line))
    return fresh_ingredient_ranges, available_ingredients

def part1(fresh_ingredient_ranges, available_ingredients):
    fresh_count = 0
    for ingredient in available_ingredients:
        #print(f"checking {ingredient}")
        is_fresh = False
        for fresh_ingredient_range in fresh_ingredient_ranges:
            #print(f"\tchecking in {fresh_ingredient_range}")
            if ingredient in fresh_ingredient_range:
                #print(f"\tis fresh!")
                is_fresh = True
                break
        if is_fresh:
            fresh_count += 1
    print(f"Part 1: {fresh_count}")

def part2():
    print("Part 2:")

fresh_ingredient_ranges, available_ingredients = parse_input(read_input())

part1(fresh_ingredient_ranges, available_ingredients)
part2()