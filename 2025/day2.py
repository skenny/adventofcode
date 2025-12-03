input = []
with open('input/day2.txt', 'r') as input_file:
    input = [list(map(int, v.split("-"))) for v in input_file.readline().split(",")]

def part1():
    invalid_ids = []
    for id_range in input:
        for id in range(id_range[0], id_range[1] + 1):
            id_str = str(id)
            id_str_len = len(id_str)
            #print(f"id {id}, length {id_str_len}")
            if id_str_len % 2 == 0:
                 sz = id_str_len // 2
                 #print(f"\teven! half length is {sz}")
                 h1 = id_str[:sz]
                 h2 = id_str[sz:]
                 #print(f"\tcomparing {h1} to {h2}")
                 if h1 == h2:
                     #print(f"\t{id} is invalid!")
                     invalid_ids.append(id)
    print(f"Part 1: {sum(invalid_ids)}")

def part2():
    answer = 0
    print(f"Part 2: {answer}")

part1()
part2()