import math

INPUT_FILE = "day13-input"
TEST_INPUT_FILE = "day13-input-test"

def read_input(file):
    with open(file, "r") as fin:
        return [l.strip() for l in fin.readlines()]

def part1(earliest_departure_time, bus_ids):
    min_time_difference = 99
    departure_bus = None
    for bus_id_str in bus_ids:
        if bus_id_str == "x":
            continue
        bus_id = int(bus_id_str)
        closest_departure_time = math.ceil(earliest_departure_time / bus_id) * bus_id
        time_difference = closest_departure_time - earliest_departure_time
        if time_difference < min_time_difference:
            min_time_difference = time_difference
            departure_bus = bus_id
    return departure_bus * min_time_difference

def part2(bus_ids):
    buses = []
    for i, bus_id in enumerate(bus_ids):
        if bus_id.isdigit():
            buses.append((i, int(bus_id)))

    timestamp = 0
    step = 1
    for bus_i, bus in buses:
        while not (timestamp + bus_i) % bus == 0:
            timestamp += step
        step = math.lcm(step, bus)
        #print("match on", timestamp, bus_i, bus, "setting step to", step)

    return timestamp

def tests():
    print("3417 should be", part2("17,x,13,19".split(",")))
    print("754018 should be", part2("67,7,59,61".split(",")))
    print("779210 should be", part2("67,x,7,59,61".split(",")))
    print("1261476 should be", part2("67,7,x,59,61".split(",")))
    print("1202161486 should be", part2("1789,37,47,1889".split(",")))

def run(label, input_file):
    input = read_input(input_file)
    earliest_departure_time = int(input[0])
    bus_ids = input[1].split(",")
    print("{} 1: {}".format(label, part1(earliest_departure_time, bus_ids)))
    print("{} 2: {}".format(label, part2(bus_ids)))

tests()
run("test", TEST_INPUT_FILE)
run("part", INPUT_FILE)