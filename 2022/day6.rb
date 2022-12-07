input = File.read("2022/day6input.txt")

def scan(datastream, marker_len)
    i = 0
    until datastream[i, marker_len].chars.uniq.length == marker_len do
        i += 1
    end
    i
end

puts scan(input, 4)
puts scan(input, 14)