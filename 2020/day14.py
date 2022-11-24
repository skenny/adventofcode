import re
import itertools

INPUT_FILE = "day14-input"
TEST_INPUT_FILE_1 = "day14-input-test"
TEST_INPUT_FILE_2 = "day14-input-test-2"

def read_input(file):
    with open(file, "r") as fin:
        return [l.strip() for l in fin.readlines()]

def int_to_bit_field(i):
    return bin(i)[2:].zfill(36)

def bit_field_to_int(bits):
    return int(bits, 2)

def apply_mask1(value, bit_mask):
    bit_value = int_to_bit_field(value)
    masked_bits = list(bit_value)
    for i, mask_bit in enumerate(list(bit_mask)):
        masked_bits[i] = mask_bit if mask_bit != "X" else bit_value[i]
    return bit_field_to_int("".join(masked_bits))

def apply_mask2(value, bit_mask):
    bit_value = int_to_bit_field(value)
    masked_bits = list(bit_value)
    floating_indices = []
    for i, mask_bit in enumerate(list(bit_mask)):
        masked_bits[i] = mask_bit if mask_bit != "0" else bit_value[i]

        # keep track of floating bit indexes for replacement later
        if mask_bit == "X":
            floating_indices.append(i)

    floating_permutations = yay_recursion(len(floating_indices))

    masked_values = []
    for fp in floating_permutations:
        for i, b in enumerate(list(fp)):
            masked_bits[floating_indices[i]] = b
        masked_values.append(bit_field_to_int("".join(masked_bits)))

    return masked_values

def yay_recursion(n):
    if n == 1:
        return ["0", "1"]
    perms = []
    for i in yay_recursion(n - 1):
        perms.append("0" + i)
        perms.append("1" + i)
    return perms

def run_program(program, memory_updater):
    bit_mask = "0" * 36
    mem = {}
    for line in program:
        if line.startswith("mask"):
            bit_mask = line.split(" = ")[1]
        if line.startswith("mem"):
            search_result = re.search(r"mem\[(\d+)\] = (\d+)", line)
            if search_result:
                address = int(search_result.group(1))
                value = int(search_result.group(2))
                memory_updater(mem, address, value, bit_mask)
    return sum(mem.values())

def update_memory_address1(mem, address, value, bit_mask):
    mem[address] = apply_mask1(value, bit_mask)

def update_memory_address2(mem, address, value, bit_mask):
    for addr in apply_mask2(address, bit_mask):
        mem[addr] = value
 
def run(label, input_file1, input_file2):
    print("{} 1: {}".format(label, run_program(read_input(input_file1), update_memory_address1)))
    print("{} 2: {}".format(label, run_program(read_input(input_file2), update_memory_address2)))

print(yay_recursion(1))
print(yay_recursion(2))
print(yay_recursion(3))
run("test", TEST_INPUT_FILE_1, TEST_INPUT_FILE_2)
run("part", INPUT_FILE, INPUT_FILE)
