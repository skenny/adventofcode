#input = "R 4\nU 4\nL 3\nD 1\nR 4\nD 1\nL 5\nR 2".split("\n")
input = File.read("2022/day9input.txt").split("\n")

@directions = {
    "U" => [0, 1],
    "D" => [0, -1],
    "L" => [-1, 0],
    "R" => [1, 0]
}

def play_rope(motions, num_knots)
    knots = Array.new(num_knots) { [0, 0] }
    tail_visits = { knots[0] => true }

    motions.each do |motion|
        direction, steps = motion.split(" ")
        steps.to_i.times do
            knots[0] = move(knots[0], @directions[direction])
            (1...num_knots).each do |i|
                knots[i] = catch_up(knots[i - 1], knots[i])
            end
            tail_visits[knots.last] = true
        end
    end

    tail_visits.keys.count
end

def move(knot, vector)
    [knot[0] + vector[0], knot[1] + vector[1]]
end

def catch_up(head, tail)
    delta_x = head[0] - tail[0]
    delta_y = head[1] - tail[1]

    catch_up_tail = delta_x.abs > 1 || delta_y.abs > 1

    if catch_up_tail
        if (delta_x != 0)
            tail = move(tail, @directions[delta_x > 0 ? "R" : "L"])
        end
        if (delta_y != 0)
            tail = move(tail, @directions[delta_y > 0 ? "U" : "D"])
        end
    end

    tail
end

puts play_rope(input, 2)
puts play_rope(input, 10)