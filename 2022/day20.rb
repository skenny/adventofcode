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

input = ARGF.read.split("\n").map(&:to_i)

def part1(input)
    nodes = input.map { |num| Node.new(num) }
    nodes.zip(nodes.rotate).each do |n1, n2|
        n1.next = n2
        n2.prev = n1
    end

    # puts "before"
    # puts nodes.map(&:to_s)

    input.each do |num|
        if num != 0
            nodes.select { |node| node.num == num }.each do |node|
                # detach
                node.prev.next = node.next
                node.next.prev = node.prev

                direction = node.sign
                target = node
                node.num.abs.times do
                    target = direction == -1 ? target.prev : target.next
                end

                # attach
                if direction == -1
                    new_next = target
                    new_prev = new_next.prev
                else
                    new_prev = target
                    new_next = new_prev.next
                end
                # puts "#{node.num} moves between #{new_prev.num} and #{new_next.num}"
                new_prev.next = node
                new_next.prev = node
                node.prev = new_prev
                node.next = new_next
            end
        end
    end

    # puts "after"
    # puts nodes.map(&:to_s)

    # TODO use start to walk nodes and build an array?
    start = nodes.find { |node| node.num == 0 }
    sum = 0
    3001.times do |i|
        if i > 0 and i % 1000 == 0
            # puts "#{i} is #{start.num}"
            sum += start.num
        end
        start = start.next
    end
    puts sum
end

part1(input)