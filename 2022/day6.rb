input = File.read("2022/day6input.txt")

def scan_input(input, chunk_size)
    i = 0
    until input[i, chunk_size].chars.uniq.length == chunk_size do
        i += 1
    end
    i
end

puts scan_input(input, 4)
puts scan_input(input, 14)