input = File.read("2022/day6input.txt")

def part1(input)
    i = 4
    until input[i-4, 4].chars.uniq.length == 4 do
        i += 1
    end
    i
end

def part2(input)
    0
end

puts part1(input)
puts part2(input)