require 'json'

input = ARGF.read.split("\n\n")

def parse_input(input)
    input.map do |pair|
        left, right = pair.split("\n")
        [JSON.parse(left), JSON.parse(right)]
    end
end

def is_ordered_3(left, right)
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
        #puts "popped l #{l}"
        #puts "popped r #{r}"

        l_is_array = Array.try_convert(l) != nil
        r_is_array = Array.try_convert(r) != nil
        #puts "l is array? #{l_is_array}"
        #puts "r is array? #{r_is_array}"

        if !l_is_array and !r_is_array
            puts "- Compare #{l} vs #{r}"

            if l < r
                puts "- Left side is smaller, so inputs are in the right order"
                return true
            elsif r < l
                puts "- Right side is smaller, so inputs are not in the right order"
                return false
            end

            if left.empty? and right.empty?
                #puts "- No more elements, arrays match"
                return nil
            end
        else
            if !r_is_array
                puts "- Compare #{l} vs #{r}"
                puts "- Mixed types; convert right to [#{r}] and retry comparison"
                rez = is_ordered_3(l, [r])
                if rez != nil
                    #puts "- After converting right from int->array we are ordered!"
                    return rez
                end
            elsif !l_is_array
                puts "- Compare #{l} vs #{r}"
                puts "- Mixed types; convert left to [#{l}] and retry comparison"
                rez = is_ordered_3([l], r)
                if rez != nil
                    #puts "- After converting left from int->array we are ordered!"
                    return rez
                end
            end

            #puts "- Left and right are arrays, recursing..."
            rez = is_ordered_3(l, r)
            if rez != nil
                #puts "- Arrays match, we are ordered!"
                return rez
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