input = File.read("2022/day6input.txt")

def scan_input(input, chunk_size)
    i = chunk_size
    until input[i-chunk_size, chunk_size].chars.uniq.length == chunk_size do
        i += 1
    end
    i
end

def part1(input)
    scan_input(input, 4)
end

def part2(input)
    scan_input(input, 14)
end

puts part1(input)
puts part2(input)