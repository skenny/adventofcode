def decode(snafu)
    multiplier = 1
    snafu.to_s.reverse.chars.reduce(0) do |sum, place|
        increase = 0
        if place == '='
            increase = -(2 * multiplier)
        elsif place == '-'
            increase = -multiplier
        else
            increase = multiplier * place.to_i
        end
        multiplier *= 5
        sum + increase
    end
end

def encode(number)
    snafu_places = []

end

def test_encoding()
    test_cases = {
        "1=-0-2" => 1747,
        "12111" => 906,
        "2=0=" => 198,
        "21" => 11,
        "2=01" => 201,
        "111" => 31,
        "20012" => 1257,
        "112" => 32,
        "1=-1=" => 353,
        "1-12" => 107,
        "12" => 7,
        "1=" => 3,
        "122" => 37
    }

    puts "=== Test encoding ==="
    test_cases.each do |snafu, expected_number|
        number = decode(snafu)
        puts "#{snafu} -> #{number}? #{expected_number == number}"
    end
    puts "\n"
end

def test_decoding()
    test_cases = {
        1 => "1",
        2 => "2",
        3 => "1=",
        4 => "1-",
        5 => "10",
        6 => "11",
        7 => "12",
        8 => "2=",
        9 => "2-",
        10 => "20",
        15 => "1=0",
        20 => "1-0",
        2022 => "1=11-2",
        12345 => "1-0---0",
        314159265 => "1121-1110-1=0"
    }

    puts "=== Test decoding ==="
    test_cases.each do |number, expected_snafu|
        snafu = encode(number)
        puts "#{number} -> #{snafu}? #{expected_snafu == snafu}"
    end
    puts "\n"
end

test_encoding
test_decoding

input = ARGF.read.split("\n")
