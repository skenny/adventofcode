input = File.read("2022/day4input.txt").split("\n")

def fully_overlap?(range_a, range_b)
    range_a.cover?(range_b) or range_b.cover?(range_a)
end

def partially_overlap?(range_a, range_b)
    !range_a.to_a.intersection(range_b.to_a).empty?
end

def split_ranges(pair_s)
    pair_s.split(",").map { |range_s| to_range(range_s) }
end

def to_range(range_s)
    b, e = range_s.split("-").map(&:to_i)
    b..e
end

def part1(assignment_pairs)
    assignment_pairs.reduce(0) do |sum, pair|
        sections1, sections2 = split_ranges(pair)
        fully_overlap?(sections1, sections2) ? sum + 1 : sum
    end
end

def part2(assignment_pairs)
    assignment_pairs.reduce(0) do |sum, pair|
        sections1, sections2 = split_ranges(pair)
        partially_overlap?(sections1, sections2) ? sum + 1 : sum
    end
end

p part1(input)
p part2(input)