#input = "R 4\nU 4\nL 3\nD 1\nR 4\nD 1\nL 5\nR 2".split("\n")
input = File.read("2022/day9input.txt").split("\n")

def part1(motions)
    head_x, head_y, tail_x, tail_y = [0, 0, 0, 0]
    tail_visits = { [0,0] => true }

    motions.each do |motion|
        direction, amount = motion.split(" ")
        amount.to_i.times do |v|
            puts "moving head in " + direction
            head_x, head_y = move(head_x, head_y, direction)
            puts "\thead is now at #{head_x},#{head_y}"
            
            catch_up_tail = (head_x-tail_x).abs > 1 || (head_y-tail_y).abs > 1

            if catch_up_tail
                puts "catching up tail..."
                delta_x = head_x - tail_x
                if (delta_x != 0)
                    tail_direction = delta_x > 0 ? "R" : "L"
                    puts "\tmoving tail in " + tail_direction
                    tail_x, tail_y = move(tail_x, tail_y, tail_direction)
                    puts "\t\ttail is now at #{tail_x},#{tail_y}"
                end

                delta_y = head_y - tail_y
                if (delta_y != 0)
                    tail_direction = delta_y > 0 ? "U" : "D"
                    puts "\tmoving tail in " + tail_direction
                    tail_x, tail_y = move(tail_x, tail_y, tail_direction)
                    puts "\t\ttail is now at #{tail_x},#{tail_y}"
                end

                tail_visits[[tail_x, tail_y]] = true
            end
        end
    end

    tail_visits.keys.count
end

def move(x, y, direction)
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

puts part1(input)