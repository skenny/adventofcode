input = File.read("2022/day6input.txt")

def part1(input)
    i = 4
    until input[i-4, 4].chars.uniq.length == 4 do
        i += 1
    end
    i
end

def part2(input)
    i = 14
    until input[i-14, 14].chars.uniq.length == 14 do
        i += 1
    end
    i
end

puts part1(input)
puts part2(input)