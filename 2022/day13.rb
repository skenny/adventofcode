require 'json'

input = ARGF.read.split("\n\n")

def parse_input(input)
    input.map do |pair|
        left, right = pair.split("\n")
        [JSON.parse(left), JSON.parse(right)]
    end
end

def comp(a, b)
    comp_and_destroy(a.map(&:clone), b.map(&:clone))
end

def comp_and_destroy(left, right)
    loop do
        if left.empty? and right.empty?
            return 0
        elsif left.empty? and not right.empty?
            return -1
        elsif right.empty?
            return 1
        end

        l = left.shift
        r = right.shift

        l_is_array = Array.try_convert(l) != nil
        r_is_array = Array.try_convert(r) != nil

        if !l_is_array and !r_is_array
            if l < r
                return -1
            elsif r < l
                return 1
            else
                if left.empty? and right.empty?
                    return 0
                end
            end
        else
            if !r_is_array
                r = [r]
            elsif !l_is_array
                l = [l]
            end

            rez = comp_and_destroy(l, r)
            if rez != 0
                return rez
            end
        end
    end
end

def part1(input)
    pairs = parse_input(input)
    ordered_pairs = 0
    pairs.each_with_index do |pair, i|
        #puts "== Pair #{i+1} =="
        left, right = pair
        ordered_pairs += (i+1) if comp(left, right) == -1
    end
    ordered_pairs
end

def part2(input)
    pairs = parse_input(input)
    divider_packets = [[[2]],[[6]]]
    pairs.push(divider_packets)
    sorted_packets = pairs.flatten(1).sort { |a, b| comp(a, b) }
    # sorted_packets.each do |packet|
    #     puts "#{packet}"
    # end
    (sorted_packets.index(divider_packets[0]) + 1) * (sorted_packets.index(divider_packets[1]) + 1)
end

puts part1(input)
puts part2(input)