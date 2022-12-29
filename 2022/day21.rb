NumberMonkey = Struct.new(:num) do
    def yell
        num
    end
end

OpMonkey = Struct.new(:op, :left, :right) do
    def yell
        case op
        when "+"
            left.yell + right.yell
        when "-"
            left.yell - right.yell
        when "*"
            left.yell * right.yell
        when "/"
            left.yell / right.yell
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
    parse_monkey("root", monkey_lookup)
end

def parse_monkey(name, monkey_lookup)
    yells = monkey_lookup[name]
    if /(\d+)/.match?(yells)
        NumberMonkey.new(yells.to_i)
    else
        left, op, right = /([a-z]{4}) (\S) ([a-z]{4})/.match(yells).captures
        OpMonkey.new(op, parse_monkey(left, monkey_lookup), parse_monkey(right, monkey_lookup))
    end
end

def part1(root_monkey)
    puts root_monkey.yell
end

input = ARGF.read.split("\n")
root_monkey = parse_input(input)

part1(root_monkey)