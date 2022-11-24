INPUT_FILE = "day16-input"
TEST_INPUT_FILE = "day16-input-test"
TEST_INPUT_FILE_2 = "day16-input-test-2"

def read_input(file):
    rules = {}
    your_ticket = []
    nearby_tickets = []
    mode = 0

    with open(file, "r") as fin:
        for l in fin.readlines():
            l = l.strip()

            if len(l) == 0:
                continue

            if l == "your ticket:":
                mode = 1
                continue
            if l == "nearby tickets:":
                mode = 2
                continue

            if mode == 0:
                rule_name, rule_spec = l.split(": ")
                rule_ranges = []
                for rule_range in rule_spec.split(" or "):
                    low, high = rule_range.split("-")
                    rule_ranges.append(range(int(low), int(high)))
                rules[rule_name] = rule_ranges
            if mode == 1:
                your_ticket = [int(v) for v in l.split(",")]
            if mode == 2:
                nearby_tickets.append([int(v) for v in l.split(",")])

    return (rules, your_ticket, nearby_tickets)

def validate_tickets(rules, tickets):
    invalid_count = 0
    valid_tickets = []

    for ticket in tickets:
        ticket_valid = True
        for n in ticket:
            num_valid = False
            for rule_ranges in rules.values():
                if check_rule(n, rule_ranges):
                    num_valid = True
                    break
            if not num_valid:
                ticket_valid = False
                invalid_count += n
        if ticket_valid:
            valid_tickets.append(ticket)

    return (invalid_count, valid_tickets)

def check_rule(n, rule_ranges):
    matches = False
    for rule_range in rule_ranges:
        if rule_range[0] <= n <= rule_range[-1] + 1:
            matches = True
    return matches

def match_ticket_fields(rules, your_ticket, nearby_tickets):
    rule_matches = {}

    # determine which rules are valid for which indexes
    for rule, rule_ranges in rules.items():
        for i in range(len(your_ticket)):
            ticket_values_i = list(map(lambda ticket: ticket[i], nearby_tickets))
            matches_rule = True
            for n in ticket_values_i:
                if not check_rule(n, rule_ranges):
                    matches_rule = False
                    break
            if matches_rule:
                rule_matches.setdefault(i, []).append(rule)

    # reduce index->rule matches until each index matches a single rule
    while True:
        multi_matches = list(filter(lambda tup: len(tup[1]) > 1, rule_matches.items()))
        if len(multi_matches) == 0:
            break
        single_matches = list(filter(lambda tup: len(tup[1]) == 1, rule_matches.items()))
        for index, matched_rules in multi_matches:
            for single_index, single_matched_rules in single_matches:
                r = single_matched_rules[0]
                if r in matched_rules:
                    matched_rules.remove(r)

    product = 1
    for index, rule in rule_matches.items():
        if rule[0].startswith("departure"):
            product *= your_ticket[index]
    return product

def run(label, input_file):
    rules, your_ticket, nearby_tickets = read_input(input_file)
    error_rate, valid_tickets = validate_tickets(rules, nearby_tickets)

    print("{} 1: {}".format(label, error_rate))
    print("{} 2: {}".format(label, match_ticket_fields(rules, your_ticket, valid_tickets)))

run("test 1", TEST_INPUT_FILE)
run("test 2", TEST_INPUT_FILE_2)
run("part", INPUT_FILE)