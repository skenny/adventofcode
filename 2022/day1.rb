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
p elves.max
p elves.sort.slice(-3, 3).sum