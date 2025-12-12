from dataclasses import dataclass
from itertools import combinations
from math import prod, sqrt

@dataclass(frozen=True)
class Vertex():
    x: int
    y: int
    z: int

    def __repr__(self):
        return f"{self.x}-{self.y}-{self.z}"

def read_input():
    input = []
    input_file = 'input/day8.txt'
    limit = 10 if 'test' in input_file else 1000
    with open(input_file, 'r') as input_file:
        input = [v.strip() for v in input_file.readlines()]
    return (limit, input)

def parse_vertices(input):
    v = []
    for line in input:
        v1, v2, v3 = line.split(",")
        v.append(Vertex(int(v1), int(v2), int(v3)))
    return v

def square(v):
    return v * v

def euclidean_distance(v1: Vertex, v2: Vertex):
    return sqrt(square(v1.x - v2.x) + square(v1.y - v2.y) + square(v1.z - v2.z))

def calculate_distances(vertices):
    vertex_pair_distances = []
    for pair in list(combinations(vertices, 2)):
        v1, v2 = pair[0], pair[1]
        vertex_pair_distances.append([v1, v2, euclidean_distance(v1, v2)])
    return vertex_pair_distances

def debug_circuits(circuits):
    counts = {}
    for c in circuits:
        size = len(c)
        if size in counts:
            counts[size].append(c)
        else:
            counts[size] = [c]

    print(f"[debug_circuits] circuit length counts:")
    for k in sorted(counts.keys()):
        print(f"\t\t{len(counts[k])} circuits with {k} junction boxes")

    circuits_str = "\n".join(map(str, circuits))
    print(f"[debug_circuits] circuits:\n{circuits_str}")

def part1(input, limit):
    print(f"connecting {limit} junction boxes...")
    vertices = parse_vertices(input)

    # by default, every junction box is a circuit with itself
    circuits = list(map(lambda v: {v}, vertices))

    closest_pairs = sorted(calculate_distances(vertices), key=lambda pairing: pairing[2])
    for pairing in closest_pairs[:limit]:
        v1, v2 = pairing[0], pairing[1]
        new_circuit = set([v1, v2])

        # look for circuits that intersect the new circuit; everything else can be considered already merged
        intersecting_circuits = [new_circuit]
        merged_circuits = []
        for c in circuits:
            if not new_circuit.isdisjoint(c):
                intersecting_circuits.append(c)
            else:
                merged_circuits.append(c)

        # merge the intersecting circuits
        merged_circuit = set()
        for c in intersecting_circuits:
            for v in c:
                merged_circuit.add(v)
        merged_circuits.append(merged_circuit)

        circuits = merged_circuits

    circuit_lengths = sorted(map(len, circuits))
    result = prod(circuit_lengths[-3:])
    print(f"Part 1: {result}")

def part2(input):
    print("Part 2:")

limit, input = read_input()
part1(input, limit)
part2(input)
