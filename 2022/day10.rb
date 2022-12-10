input = ARGF.readlines

def calculate_signal_strength(cycle, x)
    if [20, 60, 100, 140, 180, 220].include?(cycle)
        cycle * x
    else
        0
    end
end

def draw_pixel!(pixels, cycle, x)
    pixel_row_len = pixels[0].length
    pixel_row = (cycle - 1) / pixel_row_len
    pixel_pos = (cycle - 1) % pixel_row_len
    if [x-1, x, x+1].include?(pixel_pos)
        pixels[pixel_row][pixel_pos] = '#'
    end
end

def part1(program)
    cycle = 1
    x = 1
    signal_strengths = []
    
    program.each do |instr|
        cmd, amt = instr.split(" ")
        inc_x_amt = 0
        if cmd == "addx"
            inc_x_amt = amt.to_i
            cycle += 1
            signal_strengths.push(calculate_signal_strength(cycle, x))
        end
        cycle += 1
        x += inc_x_amt
        signal_strengths.push(calculate_signal_strength(cycle, x))
    end

    signal_strengths.sum
end

def part2(program)
    cycle = 1
    x = 1
    pixels = Array.new(6) { [" "] * 40 }

    program.each do |instr|
        cmd, amt = instr.split(" ")
        inc_x_amt = 0

        if cmd == "addx"
            draw_pixel!(pixels, cycle, x)
            inc_x_amt = amt.to_i
            cycle += 1
        end

        draw_pixel!(pixels, cycle, x)
        x += inc_x_amt
        cycle += 1
    end

    pixels.each do |row|
        puts row.join + "\n"
    end
end

puts part1(input)
part2(input)
