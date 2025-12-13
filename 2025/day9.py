from dataclasses import dataclass
from itertools import combinations

@dataclass(frozen=True)
class Vertex():
    x: int
    y: int

    def manhattan_distance(self, o):
        return abs(self.x - o.x) + abs(self.y - o.y)

    def __repr__(self):
        return f"({self.x},{self.y})"

def read_input(test):
    file = "day9"
    if test: file += "-test"
    input = []
    with open(f'input/{file}.txt', 'r') as input_file:
        input = [v.strip() for v in input_file.readlines()]
    return input

def parse_vertices(input):
    vertices = []
    for str in input:
        x, y = str.split(',')
        vertices.append(Vertex(int(x), int(y)))
    return vertices

def find_furthest_pair(vertices):
    best_pair, best_pair_dist = None, 0
    for pair in combinations(vertices, 2):
        v1, v2 = pair[0], pair[1]
        dist = v1.manhattan_distance(v2)
        if dist > best_pair_dist:
            best_pair = pair
            best_pair_dist = dist
    return best_pair

def part1(input):
    vertices = parse_vertices(input)
    v1, v2 = find_furthest_pair(vertices)
    largest_area = (abs(v1.x - v2.x) + 1) * (abs(v1.y - v2.y) + 1)
    print(f"Part 1: {largest_area}")

def part2(input):
    print("Part 2:")

input = read_input(False)
part1(input)
part2(input)
