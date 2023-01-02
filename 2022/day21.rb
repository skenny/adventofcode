class NumberMonkey
    attr_accessor :name

    def initialize(name, num)
        @name = name
        @num = num
    end

    def set_num(new_num)
        @num = new_num
    end

    def yell
        @num
    end

    def has_monkey(monkey_name)
        @name == monkey_name
    end
end

class OpMonkey
    attr_accessor :name, :op, :left, :right

    def initialize(name, op, left, right)
        @name = name
        @op = op
        @left = left
        @right = right
    end

    def set_op(new_op)
        @op = new_op
    end

    def inverse_op
        case @op
        when "+"
            "-"
        when "-"
            "+"
        when "*"
            "/"
        when "/"
            "*"
        else
            @op
        end
    end

    def split(search_monkey)
        @left.has_monkey(search_monkey) ? [@left, @right] : [@right, @left]
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
            @left.yell.to_f / @right.yell.to_f
        when "="
            @left.yell == @right.yell
        else
            "Invalid op: #{op}!"
            exit
        end
    end

    def has_monkey(monkey_name)
        if @name == monkey_name
            true
        else
            @left.has_monkey(monkey_name) || @right.has_monkey(monkey_name)
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
        NumberMonkey.new(name, yells.to_i)
    else
        left, op, right = /([a-z]{4}) (\S) ([a-z]{4})/.match(yells).captures
        OpMonkey.new(name, op, parse_monkey(left, monkey_lookup), parse_monkey(right, monkey_lookup))
    end
end

def solve_for(root_monkey, solve_for_monkey)
    # rotate tree and solve
    variable_side, constant_side = root_monkey.split(solve_for_monkey)
    solved = NumberMonkey.new("solved", constant_side.yell)
    while variable_side.name != solve_for_monkey
        new_variable_side, new_constant_side = variable_side.split(solve_for_monkey)
        new_known_number = NumberMonkey.new("foo2", new_constant_side.yell)

        combination_op = variable_side.inverse_op
        combination_left = solved
        combination_right = new_known_number
        if variable_side.op == "/" && new_constant_side == variable_side.left
            combination_left = new_known_number
            combination_right = solved
        end

        combined = OpMonkey.new("comb", combination_op, combination_left, combination_right).yell
        solved.set_num(combined)

        variable_side = new_variable_side
    end
    solved.yell
end

def part1(root_monkey)
    puts root_monkey.yell
end

def part2(root_monkey)
    root_monkey.set_op("=")
    puts solve_for(root_monkey, "humn")
end

input = ARGF.read.split("\n")
root_monkey = parse_input(input)

part1(root_monkey)
part2(root_monkey)