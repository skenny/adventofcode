input = ARGF.read.split("\n\n")

@operations = {
    "+" => :+,
    "*" => :*
}

class Monkey
    attr_accessor :items
    attr_accessor :operation
    attr_accessor :test
    
    def initialize(items, operation, test)
        @items = items
        @operation = operation
        @test = test
    end
end

def parse_input(input)
    input.map do |monkey_def|
        monkey_def.split("\n").each do |monkey_def_line|
            puts monkey_def_line + "\n"
        end

        monkey_id, items_def, operation_def, test_def, test_true_def, test_false_def = monkey_def.split("\n")
        items = /Starting items: ([\d, ]*)/.match(items_def).captures[0].split(", ").map(&:to_i)
        operation = /Operation: new = old (.*)/.match(operation_def).captures[0].split(" ")
        test_divisor = /Test: divisible by (\d+)/.match(test_def).captures[0]
        test_true = /If true: throw to monkey (\d)*/.match(test_true_def).captures[0]
        test_false = /If false: throw to monkey (\d)*/.match(test_false_def).captures[0]
        test = [test_divisor, test_true, test_false]
        puts [items.to_s, operation.to_s, test.to_s].join(", ")

        Monkey.new(items, operation, test)
    end
end

monkeys = parse_input(input)

def play_round(monkeys)
    monkeys.each_with_index do |monkey, i|
        puts "Monkey #{i}:"
        monkey.items.each do |item|
            puts "\tMonkey inspects an item with a worry level of #{item}."
            
            operation_s, amount_s = monkey.operation
            operation = @operations[operation_s]
            amount = amount_s == "old" ? item : amount_s.to_i
            new_item = amount.send(operation, item)
            puts "\t\tWorry level is #{operation_s} by #{amount_s} to #{new_item}."
            
            new_item /= 3
            puts "\t\tMonkey gets bored with item. Worry level is divided by 3 to #{new_item}."
            
            divisor = monkey.test[0].to_i
            test_result = new_item % divisor == 0
            puts "\t\tCurrent worry level #{test_result ? 'is' : 'is not'} divisible by #{divisor}."

            new_monkey = monkey.test[test_result ? 1 : 2].to_i
            puts "\t\tItem with worry level #{new_item} is thrown to monkey #{new_monkey}."
            
            monkeys[new_monkey].items.push(new_item)
        end

        # the monkey threw all the items to other monkeys
        monkey.items = []
    end
end

20.times do |round|
    play_round(monkeys)

    puts "After round #{round + 1}, the monkeys are holding items with these worry levels:"
    monkeys.each_with_index do |monkey, i|
        puts "Monkey #{i}: #{monkey.items.join(', ')}"
    end
end