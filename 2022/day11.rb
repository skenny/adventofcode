input = ARGF.read.split("\n\n")

class Monkey
    attr_accessor :items
    attr_accessor :operation
    attr_accessor :test
    attr_accessor :items_inspected
    
    @@operations = {
        "+" => :+,
        "*" => :*,
        "/" => :/
    }

    def initialize(items, operation, test)
        @items = items
        @operation = operation
        @test = test
        @items_inspected = 0
    end

    def inspect_items(monkeys, worry_adjustor)
        @items.each do |item|
            #puts "\tMonkey inspects an item with a worry level of #{item}."
            
            operation_s, amount_s = @operation
            operation = @@operations[operation_s]
            amount = amount_s == "old" ? item : amount_s.to_i
            new_item = amount.send(operation, item)
            #puts "\t\tWorry level is #{operation_s} by #{amount_s} to #{new_item}."
            
            worry_adjustor_operation_s, worry_adjustor_amount = worry_adjustor
            worry_adjustor_operation = @@operations[worry_adjustor_operation_s]
            new_item = new_item.send(worry_adjustor_operation, worry_adjustor_amount)
            #puts "\t\tMonkey gets bored with item. Worry level is #{worry_adjustor_operation_s} by #{worry_adjustor_amount} to #{new_item}."
            
            divisor = @test[0].to_i
            test_result = new_item % divisor == 0
            #puts "\t\tCurrent worry level #{test_result ? 'is' : 'is not'} divisible by #{divisor}."

            new_monkey = @test[test_result ? 1 : 2].to_i
            #puts "\t\tItem with worry level #{new_item} is thrown to monkey #{new_monkey}."
            
            monkeys[new_monkey].items.push(new_item)
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
        test_divisor = /Test: divisible by (\d+)/.match(test_def).captures[0]
        test_true = /If true: throw to monkey (\d)*/.match(test_true_def).captures[0]
        test_false = /If false: throw to monkey (\d)*/.match(test_false_def).captures[0]
        test = [test_divisor, test_true, test_false]
        #puts [items.to_s, operation.to_s, test.to_s].join(", ")

        Monkey.new(items, operation, test)
    end
end

def play_round(monkeys, worry_adjustor)
    monkeys.each do |monkey|
        monkey.inspect_items(monkeys, worry_adjustor)
    end
end

def part1(input)
    monkeys = parse_input(input)

    20.times do |round|
        play_round(monkeys, ["/", 3])

        # puts "After round #{round + 1}, the monkeys are holding items with these worry levels:"
        # monkeys.each_with_index do |monkey, i|
        #     puts "Monkey #{i}: #{monkey.items.join(', ')}"
        # end
    end

    puts monkeys.map(&:items_inspected).max(2).inject(:*)
end

def part2(input)
    monkeys = parse_input(input)
    
    10000.times do |round|
        play_round(monkeys, ["/", 3])

        if (round + 1) % 1000 == 0
            puts "== After round #{round + 1} =="
            monkeys.each_with_index do |monkey, i|
                puts "Monkey #{i} inspected items #{monkey.items_inspected} times."
            end
        end
    end

    puts monkeys.map(&:items_inspected).max(2).inject(:*)
end

part1(input)
#part2(input)