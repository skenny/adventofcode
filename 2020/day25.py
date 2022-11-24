import time

def read_input(file):
    with open(file, "r") as fin:
        door_pk = int(fin.readline().strip())
        card_pk = int(fin.readline().strip())
        return (door_pk, card_pk)

def transform_subject_num(subject_num, loop_size):
    val = 1
    for i in range(loop_size):
        val = apply_transformation(val, subject_num)
    return val

def apply_transformation(value, subject_num):
    return (value * subject_num) % 20201227

def resolve_loop_size(target):
    print("resolving loop size for {}...".format(target))
    loop_size = 1
    value = 1
    while True:
        value = apply_transformation(value, 7)
        if value == target:
            break
        loop_size += 1
    return loop_size

def resolve_encryption_key(door_pk, card_pk):
    door_ls = resolve_loop_size(door_pk)
    print("door loop size is", door_ls)
    card_ls = resolve_loop_size(card_pk)
    print("card loop size is", card_ls)
    return transform_subject_num(door_pk, card_ls)

def run(label, input_file):
    door_pk, card_pk = read_input(input_file)

    start_time = time.time()
    encryption_key = resolve_encryption_key(door_pk, card_pk)
    print("{} 1: {} ({}s)".format(label, encryption_key, time.time() - start_time))

run("test", "day25-input-test")
run("part", "day25-input")