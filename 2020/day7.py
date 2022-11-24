import re

INPUT_FILE = "day7-input"

INPUT_DESCRIPTOR_REGEX = r"(\w+ \w+) bags contain (.+)."
INPUT_CONTENTS_REGEX = r"(\d) (\w+ \w+) bags?,?"
INPUT_CONTENTS_EMPTY = "no other bags"

def read_input():
    with open(INPUT_FILE, "r") as fin:
        return fin.readlines()

def parse_rules(inputs):
    return dict([parse_rule(input) for input in inputs])

def parse_rule(input):
    match = re.match(INPUT_DESCRIPTOR_REGEX, input)
    bag = match.group(1)
    contents_str = match.group(2)

    if contents_str == INPUT_CONTENTS_EMPTY:
        return (bag, [])

    return (
        bag,
        list(map(lambda tuple: (int(tuple[0]), tuple[1]), re.findall(INPUT_CONTENTS_REGEX, contents_str)))
    )

def count_bag_holders(target_bag, rules):
    bags_to_search = list(rules.keys())
    bags_to_search.remove(target_bag)

    count = 0
    for s in bags_to_search:
        if can_bag_hold_target_bag(s, target_bag, rules):
            count += 1
    return count

def can_bag_hold_target_bag(bag, target_bag, rules):
    inner_bags = list(map(lambda t: t[1], rules[bag]))

    if target_bag in inner_bags:
        return True

    for inner_bag in inner_bags:
        if can_bag_hold_target_bag(inner_bag, target_bag, rules):
            return True

    return False

def count_inner_bags(bag, rules):
    count = 0
    for num, inner_bag in rules[bag]:
        count += num + (num * count_inner_bags(inner_bag, rules))
    return count

def run_tests():
    test_inputs = [
        "light red bags contain 1 bright white bag, 2 muted yellow bags.",
        "dark orange bags contain 3 bright white bags, 4 muted yellow bags.",
        "bright white bags contain 1 shiny gold bag.",
        "muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.",
        "shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.",
        "dark olive bags contain 3 faded blue bags, 4 dotted black bags.",
        "vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.",
        "faded blue bags contain no other bags.",
        "dotted black bags contain no other bags.",
    ]
    
    for input in test_inputs:
        print('{} -> {}'.format(input, parse_rule(input)))

    rules = parse_rules(test_inputs)
    print("test 1:", count_bag_holders("shiny gold", rules))
    print("test 2:", count_inner_bags("shiny gold", rules))

def run_parts():
    rules = parse_rules(read_input())
    print("part 1:", count_bag_holders("shiny gold", rules))
    print("part 2:", count_inner_bags("shiny gold", rules))

run_tests()
run_parts()
