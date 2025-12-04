input = []
with open('input/day3.txt', 'r') as input_file:
    input = [v.strip() for v in input_file.readlines()]

def part1():
    joltages = []
    for battery_bank in input:
        max_joltage = 0
        for i in range(0, len(battery_bank) - 1):
            for j in range(i + 1, len(battery_bank)):
                joltage = int(battery_bank[i] + battery_bank[j])
                max_joltage = max(joltage, max_joltage)
        joltages.append(max_joltage)
    print(f"Part 1: {sum(joltages)}")

def part2():
    joltages = []
    for battery_bank_str in input:
        #print(f"considering bank {battery_bank_str}")
        battery_bank = list(map(int, list(battery_bank_str)))
        active_batteries = []
        i = 0
        while len(active_batteries) < 12:
            num_batteries_to_keep = 12 - len(active_batteries) - 1
            batteries_to_consider = battery_bank[i:len(battery_bank) - num_batteries_to_keep]
            #print(f"\tkeeping {batteries_to_keep}; considering {batteries_to_consider} out of {battery_bank}...")
            max_battery = max(batteries_to_consider)
            max_battery_i = batteries_to_consider.index(max_battery)
            active_batteries.append(max_battery)
            #print(f"\tmax battery is {max_battery} at {max_battery_i}; active batteries is {active_batteries}")
            i += max_battery_i + 1
        max_joltage = int("".join(map(str, active_batteries)))
        #print(f"\tmax joltage is {max_joltage}")
        joltages.append(max_joltage)
    print(f"Part 2: {sum(joltages)}")

part1()
part2()
