input = []
with open('input/day1.txt', 'r') as input_file:
    input = [v.strip() for v in input_file.readlines()]

def part1():
    dial_position = 50
    zeroes_hit = 0
    for adjustment in input:
        direction = adjustment[0]
        clicks = int(adjustment[1:])
        if direction == 'L':
            clicks *= -1
        dial_position = (dial_position + clicks) % 100  # dial positions are 0..99
        if dial_position == 0:
            zeroes_hit += 1
    print("Part 1:", zeroes_hit)

def part2():
    dial_position = 50
    zeroes_hit = 0
    for adjustment in input:
        direction = adjustment[0]
        full_clicks = int(adjustment[1:])

        # count full rotations as passing zero
        full_rotations = full_clicks // 100
        zeroes_hit += full_rotations

        # remove the full rotations from the clicks amount
        clicks = full_clicks % 100
        if direction == 'L':
            clicks *= -1

        new_dial_position = dial_position + clicks
        final_dial_position = new_dial_position % 100

        # count landing on or passing zero
        if final_dial_position == 0:
            zeroes_hit += 1
        elif dial_position != 0 and new_dial_position != final_dial_position:
            zeroes_hit += 1

        dial_position = final_dial_position
    print("Part 2:", zeroes_hit)
    
part1()
part2()