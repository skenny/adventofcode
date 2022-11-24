INPUT_FILE = "day9-input"
TEST_INPUT_FILE = "day9-input-test"

def read_input(file):
    with open(file, "r") as fin:
        return [int(l) for l in fin.readlines()]

def find_invalid_value(values, preamble_len):
    preamble = values[0:preamble_len]
    for i in range(preamble_len, len(values)):
        value = values[i]
        if not validate_value(preamble, value):
            return value
        del preamble[0]
        preamble.append(value)

def validate_value(preamble, value):
    for i in range(0, len(preamble)):
        v1 = preamble[i]
        v2 = value - v1
        if v1 != v2 and v2 in preamble:
            return True
    return False

def find_contiguous_range(values, invalid_value):
    for i in range(0, len(values)):
        value = values[i]

        n = 1
        while (value < invalid_value and n < len(values)):
            value += values[i + n]
            n += 1

        if value == invalid_value:
            contiguous_range = values[i:i+n]
            contiguous_range.sort()
            return contiguous_range

def run(label, input_file, preamble_len):
    input = read_input(input_file)

    invalid_value = find_invalid_value(input, preamble_len)
    print("{} 1: {}".format(label, invalid_value))

    contiguous_range = find_contiguous_range(input, invalid_value)
    print("{} 2: {}".format(label, contiguous_range[0] + contiguous_range[-1]))

run("test", TEST_INPUT_FILE, 5)
run("part", INPUT_FILE, 25)
