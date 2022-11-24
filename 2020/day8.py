INPUT_FILE = "day8-input"
TEST_INPUT_FILE = "day8-input-test"

def read_input(file):
    with open(file, "r") as fin:
        return [l.strip() for l in fin.readlines()]

def parse_boot_code(input):
    boot_code = []
    for i in input:
        op, arg = i.strip().split(" ")
        boot_code.append({ "op": op, "arg": int(arg) })
    return boot_code

def execute(boot_code):
    accumulator = 0
    instr_ptr = 0
    success = True

    for instr in boot_code:
        instr["executed"] = False

    while True:
        if instr_ptr < 0 or instr_ptr >= len(boot_code):
            #print("exit: instr_ptr is out of range: {} (0..{})".format(instr_ptr, len(boot_code) - 1))
            break

        instr = boot_code[instr_ptr]
        op = instr["op"]
        arg = instr["arg"]
        executed = instr["executed"]

        if executed:
            #print("already executed instruction {}; aborting...".format(instr_ptr))
            success = False
            break

        jump_ptr = 1
        if (op == "acc"):
            accumulator += arg
        elif (op == "jmp"):
            jump_ptr = arg
        elif (op == "nop"):
            pass
        
        instr["executed"] = True
        instr_ptr += jump_ptr

    return (accumulator, success)

def repair(boot_code):
    for instr in boot_code:
        if instr["op"] in ("nop", "jmp"):
            swapped = instr["op"]
            instr["op"] = "jmp" if swapped == "nop" else "nop"
            result = execute(boot_code)
            if result[1]:
                return result
            instr["op"] = swapped

def run(label, input_file):
    boot_code = parse_boot_code(read_input(input_file))
    print("{} 1: {}".format(label, execute(boot_code)))
    print("{} 2: {}".format(label, repair(boot_code)))

run("test", TEST_INPUT_FILE)
run("part", INPUT_FILE)