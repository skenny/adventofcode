input = File.read("2022/day4input.txt").split("\n")

def fully_overlap?(range_a, range_b)
    range_a.cover?(range_b) or range_b.cover?(range_a)
end

def partially_overlap?(range_a, range_b)
    !range_a.to_a.intersection(range_b.to_a).empty?
end

def part1(assignment_pairs)
    assignment_pairs.count { |a, b| fully_overlap?(a, b) }
end

def part2(assignment_pairs)
    assignment_pairs.count { |a, b| partially_overlap?(a, b) }
end

# "1-2,3-4" -> [1..2, 3..4]
assignment_pairs = input.map { |pair| pair.split(",").map { |range_s| range_s.split("-").map(&:to_i) }.map { |b, e| b..e } }

p part1(assignment_pairs)
p part2(assignment_pairs)