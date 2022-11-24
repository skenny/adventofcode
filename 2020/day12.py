INPUT_FILE = "day12-input"
TEST_INPUT_FILE = "day12-input-test"

def read_input(file):
    with open(file, "r") as fin:
        return [l.strip() for l in fin.readlines()]

def navigate(steps):
    # E is 0, S is 90, W is 180, N is 270
    direction = 0
    x = 0
    y = 0

    for step in steps:
        action = step[0]
        units = int(step[1:])

        if action == "F":
            if direction == 0:
                action = "E"
            if direction == 90:
                action = "S"
            if direction == 180:
                action = "W"
            if direction == 270:
                action = "N"

        if action == "N": y += units
        if action == "S": y -= units
        if action == "E": x += units
        if action == "W": x -= units
        if action == "L": direction = (direction - units) % 360
        if action == "R": direction = (direction + units) % 360

    return abs(x) + abs(y)

def navigate_with_waypoint(steps):
    ship_x = 0
    ship_y = 0
    waypoint_x = 10
    waypoint_y = 1

    for step in steps:
        action = step[0]
        units = int(step[1:])

        if action == "N": waypoint_y += units 
        if action == "S": waypoint_y -= units 
        if action == "E": waypoint_x += units 
        if action == "W": waypoint_x -= units 
        if action in ("L", "R"):
            change_in_direction = units if action == "R" else -units
            new_waypoint_x = 0
            new_waypoint_y = 0
            if change_in_direction == 90 or change_in_direction == -270:
                new_waypoint_x = waypoint_y
                new_waypoint_y = -waypoint_x
            if change_in_direction == -90 or change_in_direction == 270:
                new_waypoint_x = -waypoint_y
                new_waypoint_y = waypoint_x
            if abs(change_in_direction) == 180:
                new_waypoint_x = -waypoint_x
                new_waypoint_y = -waypoint_y
            waypoint_x = new_waypoint_x
            waypoint_y = new_waypoint_y
        if action == "F":
            ship_x += waypoint_x * units
            ship_y += waypoint_y * units

        #print(step, ship_x, ship_y, waypoint_x, waypoint_y)

    return abs(ship_x) + abs(ship_y)

def run(label, input_file):
    steps = read_input(input_file)
    print("{} 1: {}".format(label, navigate(steps)))
    print("{} 2: {}".format(label, navigate_with_waypoint(steps)))

run("test", TEST_INPUT_FILE)
run("part", INPUT_FILE)