import re

input = []
with open('day2-input', 'r') as input_file:
    input = [v for v in input_file.readlines()]

def part1():
    valid_passwords = 0
    for i in input:
        password_data = re.search(r"^(\d+)-(\d+) ([a-z]): (.+)$", i)
        if password_data:
            min_count = int(password_data.group(1))
            max_count = int(password_data.group(2))
            required_char = password_data.group(3)
            password = password_data.group(4)
            num_char_matches = len(password.split(required_char)) - 1
            if num_char_matches >= min_count and num_char_matches <= max_count:
                valid_passwords += 1
    print('part1 valid passwords:', valid_passwords)

def part2():
    valid_passwords = 0
    for i in input:
        password_data = re.search(r"^(\d+)-(\d+) ([a-z]): (.+)$", i)
        if password_data:
            pos1 = int(password_data.group(1))
            pos2 = int(password_data.group(2))
            required_char = password_data.group(3)
            password = password_data.group(4)
            if bool(password[pos1-1] == required_char) != bool(password[pos2-1] == required_char):
                valid_passwords += 1
    print('part2 valid passwords:', valid_passwords)

part1()
part2()