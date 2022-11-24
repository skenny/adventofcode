import re

input = []
with open('day4-input', 'r') as fin:
    record_num = 0
    for line in fin.readlines():
        line = line.strip()
        if len(line) == 0:
            record_num += 1
        else:
            if record_num + 1 > len(input):
                input.append({})
            record = input[record_num]
            for part in line.split(" "):
                parts = part.split(":")
                record[parts[0]] = parts[1]

def count_valid_passports(records, deep_validation): 
    valid_count = 0
    for record in records:
        valid = True
        for required_field in ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]:
            if not required_field in record:
                valid = False
            elif deep_validation:
                value = record[required_field]
                if required_field == "byr": valid = validate_birth_year(value)
                if required_field == "iyr": valid = validate_issue_year(value)
                if required_field == "eyr": valid = validate_expiry_year(value)
                if required_field == "hgt": valid = validate_height(value)
                if required_field == "hcl": valid = validate_hair_color(value)
                if required_field == "ecl": valid = validate_eye_color(value)
                if required_field == "pid": valid = validate_passport_id(value)
            if valid == False:
                break
        if valid:
            valid_count += 1
    return valid_count

def validate_year(v, min, max):
    if not v.isdigit():
        return False
    year = int(v)
    return year >= min and year <= max

def validate_birth_year(v):
    #byr (Birth Year) - four digits; at least 1920 and at most 2002.
    return validate_year(v, 1920, 2002)

def validate_issue_year(v):
    #iyr (Issue Year) - four digits; at least 2010 and at most 2020.
    return validate_year(v, 2010, 2020)

def validate_expiry_year(v):
    #eyr (Expiration Year) - four digits; at least 2020 and at most 2030.
    return validate_year(v, 2020, 2030)

def validate_height(v):
    #hgt (Height) - a number followed by either cm or in:
    #    If cm, the number must be at least 150 and at most 193.
    #    If in, the number must be at least 59 and at most 76.
    height_data = re.search(r"^(\d+)(cm|in)$", v)
    if height_data:
        height_value = int(height_data.group(1))
        height_units = height_data.group(2)
        if height_units == "cm": return height_value >= 150 and height_value <= 193
        if height_units == "in": return height_value >= 59 and height_value <= 76
    return False

def validate_hair_color(v):
    #hcl (Hair Color) - a # followed by exactly six characters 0-9 or a-f.
    return re.match(r"^#[0-9a-f]{6}$", v) != None

def validate_eye_color(v):
    #ecl (Eye Color) - exactly one of: amb blu brn gry grn hzl oth.
    return v in ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]

def validate_passport_id(v):
    #pid (Passport ID) - a nine-digit number, including leading zeroes.
    return v.isdigit() and len(v) == 9

def part1():
    print("part 1: of", len(input), "records,", count_valid_passports(input, False), "are valid passports")

def part2():
    print("part 2: of", len(input), "records,", count_valid_passports(input, True), "are valid passports")

part1()
part2()