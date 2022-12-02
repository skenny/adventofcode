#!/usr/bin/ruby

input = File.read("2022/day1input.txt").split("\n")

elves = []
elf = 0
for line in input do
    if line.length > 0
        elf += line.to_i
    else
        elves.append(elf)
        elf = 0
    end
end
top3 = elves.max(3)
p top3.max
p top3.sum