input = ARGF.read.split("\n\n")

class Monkey
    attr_accessor :items
    attr_accessor :items_inspected

    @@operations = {
        "+" => :+,
        "*" => :*
    }

    def initialize(items, operation, test_divisor, test_true_dest, test_false_dest)
        @items = items
        @operation = operation
        @test_divisor = test_divisor
        @test_true_dest = test_true_dest
        @test_false_dest = test_false_dest
        @items_inspected = 0
    end

    def inspect_items(monkeys, adjust_worry)
        @items.each do |item|
            #puts "\tMonkey inspects an item with a worry level of #{item}."
            
            operation_s, amount_s = @operation
            operation = @@operations[operation_s]
            amount = amount_s == "old" ? item : amount_s.to_i
            new_item = amount.send(operation, item)
            #puts "\t\tWorry level is #{operation_s} by #{amount_s} to #{new_item}."
            
            if adjust_worry
                new_item /= 3
                #puts "\t\tMonkey gets bored with item. Worry level is divided by 3 to #{new_item}."
            end
            
            test_result = new_item % @test_divisor == 0
            #puts "\t\tCurrent worry level #{test_result ? 'is' : 'is not'} divisible by #{@test_divisor}."

            dest_monkey = test_result ? @test_true_dest : @test_false_dest
            #puts "\t\tItem with worry level #{new_item} is thrown to monkey #{dest_monkey}."
            
            monkeys[dest_monkey].items.push(new_item)
        end

        @items_inspected += @items.length

        # monkey threw all the items away
        @items = []
    end
end

def parse_input(input)
    input.map do |monkey_def|
        # monkey_def.split("\n").each do |monkey_def_line|
        #     puts monkey_def_line + "\n"
        # end

        monkey_id, items_def, operation_def, test_def, test_true_def, test_false_def = monkey_def.split("\n")

        items = /Starting items: ([\d, ]*)/.match(items_def).captures[0].split(", ").map(&:to_i)
        operation = /Operation: new = old (.*)/.match(operation_def).captures[0].split(" ")
        test_divisor = /Test: divisible by (\d+)/.match(test_def).captures[0].to_i
        test_true_dest = /If true: throw to monkey (\d)*/.match(test_true_def).captures[0].to_i
        test_false_dest = /If false: throw to monkey (\d)*/.match(test_false_def).captures[0].to_i

        Monkey.new(items, operation, test_divisor, test_true_dest, test_false_dest)
    end
end

def play_round(monkeys, adjust_worry)
    monkeys.each_with_index do |monkey, i|
        monkey.inspect_items(monkeys, adjust_worry)
    end
end

def play(input, rounds, debug)
    monkeys = parse_input(input)

    rounds.times do |round|
        play_round(monkeys, true)

        if debug
            puts "== After round #{round + 1} =="
            monkeys.each_with_index do |monkey, i|
                #puts "Monkey #{i}: #{monkey.items.join(', ')}"
                puts "Monkey #{i} inspected items #{monkey.items_inspected} times."
            end
            puts "\n"
        end
    end

    monkeys.map(&:items_inspected).max(2).inject(:*)
end

puts play(input, 20, false)
#puts part2(input, 10000, true)