require 'json'

input = ARGF.read.split("\n\n")

def parse_input(input)
    input.map do |pair|
        left, right = pair.split("\n")
        [JSON.parse(left), JSON.parse(right)]
    end
end

def compare(left, right)
    left_is_array = Array.try_convert(left) != nil
    right_is_array = Array.try_convert(right) != nil

    if !left_is_array and !right_is_array
        return left - right
    elsif !left_is_array
        return compare([left], right)
    elsif !right_is_array
        return compare(left, [right])
    else
        (0...[left.size, right.size].min).each do |i|
            result = compare(left[i], right[i])
            if result != 0
                return result
            end
        end
        return left.size - right.size
    end
end

def part1(input)
    pairs = parse_input(input)
    ordered_pairs = 0
    pairs.each_with_index do |pair, i|
        left, right = pair
        ordered_pairs += (i+1) if compare(left, right) < 0
    end
    ordered_pairs
end

def part2(input)
    divider_packets = [[[2]],[[6]]]
    pairs = parse_input(input)
    pairs.push(divider_packets)
    sorted_packets = pairs.flatten(1).sort { |a, b| compare(a, b) }
    (sorted_packets.index(divider_packets[0]) + 1) * (sorted_packets.index(divider_packets[1]) + 1)
end

puts part1(input)
puts part2(input)
