#input = "R 4\nU 4\nL 3\nD 1\nR 4\nD 1\nL 5\nR 2".split("\n")
input = File.read("2022/day9input.txt").split("\n")

def part1(motions)
    head = [0,0]
    tail = [0,0]
    tail_visits = { [0,0] => true }

    motions.each do |motion|
        direction, amount = motion.split(" ")
        amount.to_i.times do
            head = move(head, direction)
            tail = catch_up(head, tail)
            tail_visits[tail] = true
        end
    end

    tail_visits.keys.count
end

def part2(motions)
    knots = Array.new(10) { |i| [0,0] }
    tail_visits = { [0,0] => true }

    motions.each do |motion|
        direction, amount = motion.split(" ")
        amount.to_i.times do
            knots[0] = move(knots[0], direction)
            (1..9).each do |knot_i|
                knots[knot_i] = catch_up(knots[knot_i - 1], knots[knot_i])
            end
            tail_visits[knots[9]] = true
        end
    end

    tail_visits.keys.count
end

def move(knot, direction)
    x, y = knot

    case direction
    when 'U'
        [x, y+1]
    when 'D'
        [x, y-1]
    when 'L'
        [x-1, y]
    when 'R'
        [x+1, y]
    else
        puts "invalid direction " + direction
        [x,y]
    end
end

def catch_up(head, tail)
    head_x, head_y = head
    tail_x, tail_y = tail

    catch_up_tail = (head_x-tail_x).abs > 1 || (head_y-tail_y).abs > 1

    if catch_up_tail
        delta_x = head_x - tail_x
        if (delta_x != 0)
            tail_direction = delta_x > 0 ? "R" : "L"
            tail_x, tail_y = move([tail_x, tail_y], tail_direction)
        end

        delta_y = head_y - tail_y
        if (delta_y != 0)
            tail_direction = delta_y > 0 ? "U" : "D"
            tail_x, tail_y = move([tail_x, tail_y], tail_direction)
        end
    end

    [tail_x, tail_y]
end

puts part1(input)
puts part2(input)