input = File.read("2022/day6input.txt")

def scan_input(datastream, marker_len)
    i = 0
    until datastream[i, marker_len].chars.uniq.length == marker_len do
        i += 1
    end
    i
end

puts scan_input(input, 4)
puts scan_input(input, 14)