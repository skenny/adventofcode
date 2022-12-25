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
    node_order = nodes.map do |node|
        [node.num, node]
    end

    # puts "before"
    # puts nodes.map(&:to_s)

    iterations.times do
        node_order.each do |num, node|
            if num != 0
                # detach
                node.prev.next = node.next
                node.next.prev = node.prev

                # find target node
                direction = node.sign
                target = node
                node.num.abs.times do
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
    end

    # puts "after"
    # puts nodes.map(&:to_s)
end

def find_grove_coordinates(nodes)
    start = nodes.find { |node| node.num == 0 }
    grove_coordinates = []
    3001.times do |i|
        if i > 0 and i % 1000 == 0
            grove_coordinates.push(start.num)
        end
        start = start.next
    end
    grove_coordinates
end

def part1(numbers)
    nodes = create_nodes(numbers)
    mix(nodes)
    puts find_grove_coordinates(nodes).sum
end

def part2(numbers)
    decryption_key = 811589153
    nodes = create_nodes(numbers.map { |n| n * decryption_key })
    mix(nodes, 10)
    puts find_grove_coordinates(nodes).sum
end

numbers = ARGF.read.split("\n").map(&:to_i)
part1(numbers)
#part2(numbers)