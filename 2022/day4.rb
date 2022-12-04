input = File.read("2022/day4input.txt").split("\n")

def part1(assignment_pairs)
    assignment_pairs.count { |a, b| a.cover?(b) or b.cover?(a) }
end

def part2(assignment_pairs)
    assignment_pairs.count { |a, b| !a.to_a.intersection(b.to_a).empty? }
end

# "1-2,3-4" -> [[1,2], [3,4]] -> [1..2, 3..4]
assignment_pairs = input.map { |pair| pair.split(",").map { |range_s| range_s.split("-").map(&:to_i) }.map { |b, e| b..e } }

p part1(assignment_pairs)
p part2(assignment_pairs)