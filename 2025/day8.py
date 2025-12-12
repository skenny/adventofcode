from dataclasses import dataclass
from math import sqrt, prod
from time import time_ns
from sys import maxsize as MAX_INT

@dataclass(frozen=True)
class Vertex():
    x: int
    y: int
    z: int

    def __repr__(self):
        return f"{self.x}-{self.y}-{self.z}"

def read_input():
    input = []
    with open('input/day8-test.txt', 'r') as input_file:
        input = [v.strip() for v in input_file.readlines()]
    return input

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
    seen_pairs = []
    distances_calculated = 0
    print("calculating distances...")
    start_ms = time_ns() // 1_000_000
    for v1 in vertices:
        for v2 in vertices:
            if v1 == v2:
                continue
            pair = {v1, v2}
            if pair in seen_pairs:
                continue
            seen_pairs.append(pair)
            vertex_pair_distances.append([v1, v2, euclidean_distance(v1, v2)])
            distances_calculated += 1
            if distances_calculated % 10000 == 0:
                print(f"calculated {distances_calculated} distances...")
    end_ms = time_ns() // 1_000_000
    print(f"calculated {distances_calculated} distances in {end_ms - start_ms}ms!")
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
    vertices = parse_vertices(input)
    closest_pairs = sorted(calculate_distances(vertices), key=lambda pairing: pairing[2])
    circuits = list(map(lambda v: {v}, vertices))

    for pairing in closest_pairs[:limit]:
        v1, v2 = pairing[0], pairing[1]
        #print(f"connecting {v1} to {v2}...")

        new_circuit = set([v1, v2])

        # look for circuits that intersect the new circuit; everything else can be considered already merged
        intersecting_circuits = [new_circuit]
        merged_circuits = []
        for c in circuits:
            if not new_circuit.isdisjoint(c):
                #print(f"\tintersection between new circuit {new_circuit} and existing circuit {c}!")
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

input = read_input()
part1(input, 10)
part2(input)
