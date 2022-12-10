input = ARGF.readlines

def calculate_signal_strength(cycle, x)
    if [20, 60, 100, 140, 180, 220].include?(cycle)
        signal_str = cycle * x
        puts "cycle #{cycle} has signal strength of #{signal_str}"
        signal_str
    else
        0
    end
end

def part1(program)
    cycle = 1
    x = 1
    signal_strengths = []
    
    program.each do |instr|
        cmd, amt = instr.split(" ")
        if cmd == "addx"
            cycle += 1
            signal_strengths.push(calculate_signal_strength(cycle, x))
            x += amt.to_i
        end
        cycle += 1
        signal_strengths.push(calculate_signal_strength(cycle, x))
    end

    signal_strengths.sum
end

def part2(input)
end

puts part1(input)
puts part2(input)
