class NumberMonkey
    def initialize(num)
        @num = num
    end

    def change_num(new_num)
        @num = new_num
    end

    def yell
        @num
    end
end

class OpMonkey
    def initialize(op, left, right)
        @op = op
        @left = left
        @right = right
    end

    def change_op(new_op)
        @op = new_op
    end

    def left_yell
        @left.yell
    end

    def right_yell
        @right.yell
    end

    def yell
        case @op
        when "+"
            @left.yell + @right.yell
        when "-"
            @left.yell - @right.yell
        when "*"
            @left.yell * @right.yell
        when "/"
            @left.yell / @right.yell
        when "="
            @left.yell == @right.yell
        else
            "Invalid op: #{op}!"
            exit
        end
    end
end

def parse_input(input)
    monkey_lookup = {}
    input.each do |line|
        monkey, yells = line.split(": ")
        monkey_lookup[monkey] = yells
    end
    [parse_monkey("root", monkey_lookup), monkey_lookup["node_humn"]]
end

def parse_monkey(name, monkey_lookup)
    yells = monkey_lookup[name]
    monkey = nil
    if /(\d+)/.match?(yells)
        monkey = NumberMonkey.new(yells.to_i)
    else
        left, op, right = /([a-z]{4}) (\S) ([a-z]{4})/.match(yells).captures
        monkey = OpMonkey.new(op, parse_monkey(left, monkey_lookup), parse_monkey(right, monkey_lookup))
    end
    monkey_lookup["node_" + name] = monkey
    monkey
end

def part1(root_monkey)
    puts root_monkey.yell
end

def part2(root_monkey, humn_monkey)
    root_monkey.change_op("=")
    num = 3_665_520_865_000
    loop do
        humn_monkey.change_num(num)
        break if root_monkey.yell
        num += 1
    end
    puts num
end

input = ARGF.read.split("\n")
root_monkey, humn_monkey = parse_input(input)

part1(root_monkey)
part2(root_monkey, humn_monkey)