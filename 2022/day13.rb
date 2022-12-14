require 'json'

input = ARGF.read.split("\n\n")

def parse_input(input)
    input.map do |pair|
        left, right = pair.split("\n")
        [JSON.parse(left), JSON.parse(right)]
    end
end

def is_ordered_3(left, right)
    debug = true
    puts "- Compare #{left} vs #{right}"
    loop do
        if left.empty? and not right.empty?
            puts "- Left side ran out of items, so inputs are in the right order"
            return true
        elsif right.empty?
            puts "- Right side ran out of items, so inputs are not in the right order"
            return false
        end

        l = left.shift
        r = right.shift
        if debug
            puts "popped l #{l}"
            puts "popped r #{r}"
        end

        l_is_array = Array.try_convert(l) != nil
        r_is_array = Array.try_convert(r) != nil
        if debug
            puts "l is array? #{l_is_array}"
            puts "r is array? #{r_is_array}"
        end

        if !l_is_array and !r_is_array
            puts "- Compare #{l} vs #{r}"

            if l < r
                puts "- Left side is smaller, so inputs are in the right order"
                return true
            elsif r < l
                puts "- Right side is smaller, so inputs are not in the right order"
                return false
            else
                return nil
            end
        else
            if !r_is_array
                puts "- Compare #{l} vs #{r}"
                puts "- Mixed types; convert right to [#{r}] and retry comparison"
                rez = is_ordered_3(l, [r])
                if rez != nil
                    if debug
                        puts "- After converting right from int->array we are ordered!"
                    end
                    return rez
                end
            elsif !l_is_array
                puts "- Compare #{l} vs #{r}"
                puts "- Mixed types; convert left to [#{l}] and retry comparison"
                rez = is_ordered_3([l], r)
                if rez != nil
                    if debug
                        puts "- After converting left from int->array we are ordered!"
                    end
                    return rez
                end
            else
                if debug
                    puts "- Left #{l} and right #{r} are arrays, recursing..."
                end
                rez = is_ordered_3(l, r)
                if rez != nil
                    if debug
                        puts "- Arrays match, we are ordered!"
                    end
                    return rez
                end
            end
        end
    end
end

def part1(pairs)
    ordered_pairs = []
    pairs.each_with_index do |pair, i|
        left, right = pair
        puts "== Pair #{i+1} =="
        ordered = is_ordered_3(left, right)
        ordered_pairs << i+1 if ordered
    end
    ordered_pairs.sum
end

pairs = parse_input(input)

puts part1(pairs)