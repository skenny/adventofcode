import re
import copy

def read_input(file):
    rules = {}
    messages = []

    mode = 0

    with open(file, "r") as fin:
        for line in fin.readlines():
            line = line.strip()

            if len(line) == 0:
                mode = 1
                continue

            if mode == 0:
                rule = line.split(": ")
                rule_num = int(rule[0])
                rule_spec = rule[1].replace('"', '')
                rules[rule_num] = rule_spec

            if mode == 1:
                messages.append(line)

    return rules, messages

def simplify(rules):
    rules_copy = copy.copy(rules)
    rules_to_simplify = list(rules_copy.keys())

    while len(rules_to_simplify) > 0:
        for rule_num in rules_to_simplify:
            rule_spec = rules_copy[rule_num]
            #print("{}: {}".format(rule_num, rule_spec))
            if not any(char.isdigit() for char in rule_spec):
                #print("simple rule", rule_num) #, rule_spec)
                rules_to_simplify.remove(rule_num)
            else:
                new_rule_spec = ""
                rule_parts = rule_spec.split(" ")
                rule_part_references = list(filter(lambda c: c.isdigit(), rule_parts))
                for i, rule_part in enumerate(rule_parts):
                    if rule_part.isdigit() and int(rule_part) == rule_num:
                        if len(rule_part_references) > 1:
                            new_rule_spec += rule_part + " "
                        else:
                            if int(rule_part) == 8:
                                new_rule_spec = "({0})+ ".format(rules_copy[42])
                                break
                            if int(rule_part) == 11:
                                new_rule_spec = "({0}) ({1}) | ({0}) ({0}) ({1}) ({1}) | ({0}) ({0}) ({0}) ({1}) ({1}) ({1}) | ({0}) ({0}) ({0}) ({0}) ({1}) ({1}) ({1}) ({1})".format(rules_copy[42], rules_copy[31])
                                break
                            raise "unexpected looping rule: " + rule_part
                    elif rule_part.isdigit() and not int(rule_part) in rules_to_simplify:
                        simple_rule = rules_copy[int(rule_part)]
                        if len(simple_rule) == 1:
                            new_rule_spec += simple_rule + " "
                        else:
                            new_rule_spec += "(" + simple_rule + ") "
                    else:
                        new_rule_spec += rule_part + " "
                rules_copy[rule_num] = new_rule_spec.strip()

    return rules_copy[0].replace(' ', '')

def count_valid_messages(rules, messages):
    target_rule_pattern = re.compile("^" + simplify(rules) + "$")    
    valid_messages = []
    for message in messages:
        if target_rule_pattern.match(message):
            #print("valid message: " + message)
            valid_messages.append(message)
    return len(valid_messages)

def run(label, input_file1, input_file2):
    rules, messages = read_input(input_file1)
    print("{} 1: {}".format(label, count_valid_messages(rules, messages)))

    rules, messages = read_input(input_file2)
    rules[8] = "42 | 42 8"
    rules[11] = "42 31 | 42 11 31" # only apply + to (42 11 31), not (42 31 | 42 11 31)+
    print("{} 2: {}".format(label, count_valid_messages(rules, messages)))

run("test", "day19-input-test", "day19-input-test-2")
run("part", "day19-input", "day19-input")