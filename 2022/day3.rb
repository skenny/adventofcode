input = File.read('2022/day3input.txt').split("\n")

@alpha = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

def part1(rucksacks)
    rucksacks.reduce(0) do |sum, rucksack|
        comp1, comp2 = rucksack.chars.each_slice(rucksack.size / 2).map(&:join)
        duplicate = comp1.chars.intersection(comp2.chars)[0]
        sum += @alpha.index(duplicate) + 1
    end
end

def part2(rucksacks)
    rucksacks.each_slice(3).reduce(0) do |sum, elf_group|
        badge = elf_group[0].chars.intersection(elf_group[1].chars, elf_group[2].chars)[0]
        sum += @alpha.index(badge) + 1
    end
end

p part1(input)
p part2(input)