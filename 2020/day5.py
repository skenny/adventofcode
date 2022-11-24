def find_seat(input):
    row = binary_search(input[:7], 0, 128)
    col = binary_search(input[7:], 0, 8)
    return (row, col, row * 8 + col)

def binary_search(path, min, max):
    for c in path:
        mid = int((max - min) / 2)
        if c in ['F', 'L']:
            max -= mid
        else:
            min += mid
    return min

def run_tests():
    for i in ["FBFBBFFRLR", "BFFFBBFRRR", "FFFBBBFRRR", "BBFFBBFRLL"]:
        print("testing", i, find_seat(i))

def read_input():
    with open('day5-input', 'r') as fin:
        return [l.strip() for l in fin.readlines()]

def parse_seats():
    return [find_seat(i) for i in read_input()]

def part1(seats):
    max_seat_id = 0
    for seat in seats:
        #print(i, seat, max_seat_id)
        if seat[2] > max_seat_id:
            max_seat_id = seat[2]
    print("part 1", max_seat_id)

def part2(seats):
    seat_ids = sorted(list(map(lambda s: s[2], seats)))
    for i in range(1, len(seats) - 1):
        if i not in seat_ids and i + 1 in seat_ids and i - 1 in seat_ids:
            print("part 2", i)

def run_parts():
    seats = parse_seats()
    part1(seats)
    part2(seats)

run_tests()
run_parts()
