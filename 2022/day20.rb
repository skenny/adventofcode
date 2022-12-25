class Node
    attr_accessor :num, :prev, :next
    
    def initialize(num)
        @num = num
        @prev = nil
        @next = nil
    end

    def sign
        @num <=> 0
    end

    def to_s
        "#{@num} [prev=#{@prev.num}, next=#{@next.num}]"
    end
end

def create_nodes(numbers)
    nodes = numbers.map { |v| Node.new(v) }
    nodes.zip(nodes.rotate).each do |n1, n2|
        n1.next = n2
        n2.prev = n1
    end
    nodes
end

def mix(nodes, iterations=1)
    node_count = nodes.size

    node_order = nodes.map do |node|
        [node.num, node]
    end

    # puts "before"
    # puts nodes.map(&:to_s)

    iterations.times do |i|
        node_order.each do |num, node|
            if num != 0
                # detach
                node.prev.next = node.next
                node.next.prev = node.prev

                # find target node
                direction = node.sign
                target = node

                # -1 so that if we have a non-zero node num equal to the number of nodes we still move it
                steps = node.num.abs % (node_count - 1)
                
                steps.times do
                    target = direction == -1 ? target.prev : target.next
                end

                # from target, determine new next/prev
                if direction == -1
                    new_next = target
                    new_prev = new_next.prev
                else
                    new_prev = target
                    new_next = new_prev.next
                end

                # puts "#{node.num} moves between #{new_prev.num} and #{new_next.num}"

                # re-attach
                new_prev.next = node
                new_next.prev = node
                node.prev = new_prev
                node.next = new_next
            end
        end

        # puts "after #{i+1} round(s) of mixing:"
        # puts nodes.map(&:to_s)
    end
end

def find_grove_coordinates(numbers, decryption_key=1, mix_iterations=1)
    nodes = create_nodes(numbers.map { |n| n * decryption_key })
    mix(nodes, mix_iterations)

    # TODO prolly faster to build an array and then use index access
    current = nodes.find { |node| node.num == 0 }
    grove_coordinates = []
    3001.times do |i|
        if i > 0 and i % 1000 == 0
            grove_coordinates.push(current.num)
        end
        current = current.next
    end
    grove_coordinates
end

def part1(numbers)
    grove_coords = find_grove_coordinates(numbers)
    puts "#{grove_coords} -> #{grove_coords.sum}"
end

def part2(numbers)
    grove_coords = find_grove_coordinates(numbers, 811589153, 10)
    puts "#{grove_coords} -> #{grove_coords.sum}"

    # guesses:
    # 13802696725071 is too high
end

numbers = ARGF.read.split("\n").map(&:to_i)
part1(numbers)
part2(numbers)