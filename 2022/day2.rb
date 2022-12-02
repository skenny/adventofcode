input = File.read("2022/day2input.txt").split("\n")

@opts = ["A", "B", "C"]  # rock, paper, scissors

def choice_points(you)
    @opts.index(you) + 1
end

def victory_points(you, opponent, winner)
    you == opponent ? 3 : you == winner ? 6 : 0
end

def winner(p)
    @opts[(@opts.index(p) + 1) % 3]
end

def loser(p)
    @opts[(@opts.index(p) - 1) % 3]
end

# part 1
total = 0
input.each do |line|
    parts = line.split(" ")
    opponent = parts[0]
    you = @opts[parts[1].ord - 88]
    winner = winner(opponent)
    #p parts.join("-") + " opponent=" + opponent + " you=" + you + " winner=" + winner
    total += choice_points(you) + victory_points(you, opponent, winner)
end
p total

# part 2
total = 0
input.each do |line|
    parts = line.split(" ")
    opponent = parts[0]
    you = parts[1] == 'X' ? loser(opponent) : parts[1] == 'Z' ? winner(opponent) : opponent
    winner = winner(opponent)
    #p parts.join("-") + " opponent=" + opponent + " you=" + you + " winner=" + winner
    total += choice_points(you) + victory_points(you, opponent, winner)
end
p total
