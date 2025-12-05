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
            fresh_ingredient_ranges.append([int(low), int(high)])
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
            if ingredient >= fresh_ingredient_range[0] and ingredient <= fresh_ingredient_range[1]:
                #print(f"\tis fresh!")
                is_fresh = True
                break
        if is_fresh:
            fresh_count += 1
    print(f"Part 1: {fresh_count}")

def part2(fresh_ingredient_ranges):
    sorted_fresh_ingredient_ranges = sorted(fresh_ingredient_ranges, key = lambda r: r[0])
    fresh_ingredient_count = 0
    ranges_seen = []

    for fresh_ingredient_range in sorted_fresh_ingredient_ranges:
        range_start = fresh_ingredient_range[0]
        range_end = fresh_ingredient_range[1]
        range_len = range_end - range_start + 1
        #print(f"{fresh_ingredient_range}: start is {range_start} and stop is {range_end} and len is {range_len}")

        skip = False

        for seen_range in ranges_seen:
            #print(f"\tcomparing with seen range {seen_range}")

            if range_start >= seen_range[0] and range_end <= seen_range[1]:
                #print("\t\tcompletely contained! ignoring...")
                skip = True
                break

            if range_start >= seen_range[0] and range_start <= seen_range[1]:
                range_start = seen_range[1] + 1
                #print(f"\t\tnew range starts within seen range; adjusting range_start to {range_start}")
            elif range_end >= seen_range[0] and range_end <= seen_range[1]:
                range_end = seen_range[0] - 1
                #print(f"\t\tnew range ends within seen range; adjusting range_end to {range_start}")

        if not skip:
            adjusted_range_ingredient_count = range_end - range_start + 1
            #print(f"\tadjusted range: {range_start} to {range_end}, len is {adjusted_range_ingredient_count}")

            fresh_ingredient_count += adjusted_range_ingredient_count
            #print(f"\tfresh_ingredient_count is {fresh_ingredient_count}")

        ranges_seen.append(fresh_ingredient_range)

    print(f"Part 2: {fresh_ingredient_count}")

fresh_ingredient_ranges, available_ingredients = parse_input(read_input())

part1(fresh_ingredient_ranges, available_ingredients)
part2(fresh_ingredient_ranges)