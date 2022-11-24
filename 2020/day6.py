from functools import reduce

INPUT_FILE = "day6-input"

def read_input():
    groups = []
    with open(INPUT_FILE, "r") as fin:
        group = []
        for line in fin.readlines():
            line = line.strip()
            if not line:
                groups.append(group)
                group = []
            else:
                group.append(line)
        groups.append(group)
    return groups

def count_anyone_answers(group):
    return len(set("".join(group)))

def count_everyone_answers(group):
    return len(reduce(lambda total_answers, person_answers: total_answers.intersection(set(person_answers)), group[1:], set(group[0])))

def sum(ints):
    return reduce(lambda total, group_count: total + group_count, ints)

def run_tests():
    test_groups = [["abc"], ["a","b","c"], ["ab","ac"], ["a","a","a","a"], ["b"]]
    test = lambda label, reducer, group, expected_count: print(label, group, "=", expected_count, "?", reducer(group) == expected_count)
    test("test any", count_anyone_answers, test_groups[0], 3)
    test("test any", count_anyone_answers, test_groups[1], 3)
    test("test any", count_anyone_answers, test_groups[2], 3)
    test("test any", count_anyone_answers, test_groups[3], 1)
    test("test any", count_anyone_answers, test_groups[4], 1)
    test("test all", count_everyone_answers, test_groups[0], 3)
    test("test all", count_everyone_answers, test_groups[1], 0)
    test("test all", count_everyone_answers, test_groups[2], 1)
    test("test all", count_everyone_answers, test_groups[3], 1)
    test("test all", count_everyone_answers, test_groups[4], 1)

def part1(groups):
    print("part 1", sum(map(count_anyone_answers, groups)))

def part2(groups):
    print("part 2", sum(map(count_everyone_answers, groups)))

def run_parts():
    groups = read_input()
    part1(groups)
    part2(groups)

run_tests()
run_parts()