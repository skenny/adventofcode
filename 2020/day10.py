INPUT_FILE = "day10-input"
TEST_INPUT_FILE_1 = "day10-input-test"
TEST_INPUT_FILE_2 = "day10-input-test-2"
TEST_INPUT_FILE_3 = "day10-input-test-3"

DEVICE_ADAPTER_JOLTAGE_ADJ = 3
MAX_JOLTAGE_DIFFERENCE = 3
OUTLET_JOLTAGE = 0

def read_input(file):
    with open(file, "r") as fin:
        return [int(l) for l in fin.readlines()]

def connect(adapters):
    working_adapters = adapters.copy()
    joltage = adapters[0]

    # we always connect the built-in adapter to the last adapter
    deltas = [DEVICE_ADAPTER_JOLTAGE_ADJ]

    for adapter in adapters:
        working_adapters.remove(adapter)
        next_adapter_options = set(filter(lambda adapter_joltage: adapter_joltage - joltage <= MAX_JOLTAGE_DIFFERENCE, working_adapters))

        if not next_adapter_options:
            break

        # always connect to the lowest joltage adapter option to ensure all adapters are used
        next_adapter = min(next_adapter_options)

        deltas.append(next_adapter - joltage)
        joltage = next_adapter

    return deltas.count(1) *  deltas.count(3)

def count_paths(adapters):
    graph = {}
    for i, adapter in enumerate(adapters):
        remaining_adapters = adapters[i + 1:]
        graph[adapter] = set(filter(lambda other_adapter: other_adapter - adapter <= MAX_JOLTAGE_DIFFERENCE, remaining_adapters))
    
    path_counts = {}
    for adapter in reversed(adapters):
        adapter_options = graph[adapter]
        if not adapter_options:
            path_counts[adapter] = 1
        else:
            path_counts[adapter] = sum([path_counts[i] for i in adapter_options])
    
    return path_counts[min(adapters)]

def run(label, file):
    adapters = read_input(file)
    adapters.sort()
    adapters.insert(0, OUTLET_JOLTAGE)

    print("{} 1: {}".format(label, connect(adapters)))
    print("{} 2: {}".format(label, count_paths(adapters)))

run("test_1", TEST_INPUT_FILE_1)
run("test_2", TEST_INPUT_FILE_2)
run("test_3", TEST_INPUT_FILE_3)
run("part", INPUT_FILE)
