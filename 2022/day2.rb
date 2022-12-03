input = File.read("2022/day2input.txt").split("\n")

@opts = ["A", "B", "C"]  # rock, paper, scissors

def points(opt)
    @opts.index(opt) + 1
end

def victory_points(you, opponent)
    you == opponent ? 3 : you == winner(opponent) ? 6 : 0
end

def winner(opt)
    @opts[(@opts.index(opt) + 1) % 3]
end

def loser(opt)
    @opts[(@opts.index(opt) - 1) % 3]
end

# part 1
total = 0
input.each do |line|
    parts = line.split(" ")
    opponent = parts[0]
    you = @opts[parts[1].ord - 88]  # normalize X->A, etc
    total += points(you) + victory_points(you, opponent)
end
p total

# part 2
total = 0
input.each do |line|
    parts = line.split(" ")
    opponent = parts[0]
    you = parts[1] == 'X' ? loser(opponent) : parts[1] == 'Z' ? winner(opponent) : opponent
    total += points(you) + victory_points(you, opponent)
end
p total
