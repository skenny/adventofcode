input = File.read("2022/day5input.txt").split("\n")

def part1(input)
    stacks, steps = parse_input(input)
    steps.each do |num_crates, from, to|
        (0...num_crates).each do |i|
            stacks[to - 1].push(stacks[from - 1].pop)
        end
    end
    stacks.map { |stack| stack.last }.join
end

def part2(input)
    stacks, steps = parse_input(input)
    steps.each do |num_crates, from, to|
        stacks[to - 1] += stacks[from - 1].pop(num_crates)
    end
    stacks.map { |stack| stack.last }.join
end

def parse_input(input)
    stacks_lines = input.take_while { |line| line.length > 0 }
    steps_lines = input.drop(stacks_lines.length + 1)

    num_stacks = (stacks_lines[0].length + 1) / 4
    stacks_lines.pop # remove stack numbers
    stacks_lines.reverse!

    stacks = []
    (0...num_stacks).each do |col|
        crate_idx = 1 + (col * 4)
        stacks_lines.each do |line|
            crate_val = line[crate_idx].strip
            if !stacks[col]
                stacks[col] = []
            end
            if crate_val.length > 0
                stacks[col].push(crate_val)
            end
        end
    end

    steps = steps_lines.map do |step|
        /move (\d+) from (\d+) to (\d+)/.match(step).captures.map(&:to_i)
    end

    [stacks, steps]
end

puts part1(input)
puts part2(input)
