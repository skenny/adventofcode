input = ARGF.readlines

class Sensor
    def initialize(loc_x, loc_y, beacon_x, beacon_y)
        @loc_x = loc_x
        @loc_y = loc_y
    
        # use the beacon coordinates to determine the sensor diamond "radius"

        d_x = beacon_x - @loc_x     # negative means beacon is left
        d_y = beacon_y - @loc_y     # negative means beacon is above

        # OPTIMIZATION - no need to step if the beacon is on an axis with the sensor, just use the deviation on the other axis

        step_x = beacon_x < @loc_x ?  1 : beacon_x > @loc_x ? -1 : 0
        step_y = beacon_y < @loc_y ? -1 : beacon_y > @loc_y ?  1 : 0

        # from d_x, d_y, use manhattan stepping to find a point of coverage
        at_x = beacon_x
        at_y = beacon_y
        while at_x != @loc_x and at_y != @loc_y do
            at_x += step_x
            at_y += step_y
        end

        # the radius is the distance from the sensor on either the x or y axis (whichever we hit)
        if at_x == @loc_x
            @radius = (at_y - @loc_y).abs
        else
            @radius = (at_x - @loc_x).abs
        end

        @top = [@loc_x, @loc_y - @radius]
        @bottom = [@loc_x, @loc_y + @radius]
        @left = [@loc_x - @radius, @loc_y]
        @right = [@loc_x + @radius, @loc_y]
    end

    def intersects(y_line)
        y_line >= @top[1] and y_line <= @bottom[1]
    end

    def coverage_range(y_line)
        if intersects(y_line)
            d_y = (y_line - @loc_y).abs
            [@loc_x - @radius + d_y, @loc_x + @radius - d_y]
        else
            nil
        end
    end
end

def parse_input(input)
    sensors = []
    beacons = []

    input.each do |line|
        sensor_x, sensor_y, beacon_x, beacon_y = /Sensor at x=([-\d]+), y=([-\d]+): closest beacon is at x=([-\d]+), y=([-\d]+)/.match(line).captures.map(&:to_i)
        sensors.push(Sensor.new(sensor_x, sensor_y, beacon_x, beacon_y))
        beacons.push([beacon_x, beacon_y])
    end

    [sensors, beacons]
end

def part1(sensors, beacons, test_line_y)
    coverage_ranges = []
    beacons_on_test_line = beacons.uniq.count { |beacon| beacon[1] == test_line_y }

    sensors.each do |sensor|
        if sensor.intersects(test_line_y)
            coverage_range = sensor.coverage_range(test_line_y)
            coverage_ranges.push(coverage_range) if coverage_range
        end
    end

    coverage_ranges.sort!

    puts coverage_ranges.map { |p| "[#{p[0]},#{p[1]}]" }.join(',')
    coverage_ranges.uniq.count - beacons_on_test_line

    coverage = 0
    current_x = nil
    while not coverage_ranges.empty? do
        range = coverage_ranges.shift
        range_start = range[0]
        range_end = range[1]

        puts "coverage is #{coverage}, current_x is #{current_x}, range is #{range_start}..#{range_end}"

        # TODO limit range for part 2

        if coverage == 0
            puts "starting!"
            coverage += (range_end - range_start) + 1
            current_x = range_end
            next
        end

        # if this range is already covered, skip it
        if range_end <= current_x
            puts "already covered"
            next
        end
        
        # if the next range starts before our current spot, add current -> end
        if range_start < current_x
            coverage += range_end - current_x
            current_x = range_end
            next
        end

        coverage += range_end - range_start
        current_x = range_end
    end

    coverage - beacons_on_test_line
end

def part2(sensors, beacons)
    distress_beacon = [0,0]

    (0...4_000_000).each do |y|
        points_on_line = part1(sensors, beacons, y)
        if 4_000_000 - points_on_line == 1
            puts "it's on line #{y}"
        end
    end

    4_000_000 * distress_beacon[0] + distress_beacon[1]
end

sensors, beacons = parse_input(input)

a = Time.new.to_i * 1000
puts part1(sensors, beacons, 2000000)
puts "part 1 took #{Time.new.to_i * 1000 - a}ms"

a = Time.new.to_i * 1000
#puts part2(sensors, beacons)
#puts "part 2 took #{Time.new.to_i * 1000 - a}ms"



=begin
                 1    1    2    2
       0    5    0    5    0    5
 9 ...#########################...
10 ..####B######################..
11 .###S#############.###########.
=end