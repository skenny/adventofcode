input = ARGF.readlines

class Sensor

    def initialize(loc_x, loc_y, beacon_x, beacon_y)
        @loc_x = loc_x
        @loc_y = loc_y
        @radius = determine_radius(beacon_x, beacon_y)
        @top = [@loc_x, @loc_y - @radius]
        @bottom = [@loc_x, @loc_y + @radius]
        @left = [@loc_x - @radius, @loc_y]
        @right = [@loc_x + @radius, @loc_y]
    end

    def determine_radius(beacon_x, beacon_y)
        # step from beacon to an intersection with the sensor axis; the deviation is the sensor coverage diamond "radius"
        step_x = beacon_x < @loc_x ?  1 : beacon_x > @loc_x ? -1 : 0
        step_y = beacon_y < @loc_y ? -1 : beacon_y > @loc_y ?  1 : 0

        at_x = beacon_x
        at_y = beacon_y
        while at_x != @loc_x and at_y != @loc_y do
            at_x += step_x
            at_y += step_y
        end

        at_x == @loc_x ? (at_y - @loc_y).abs : (at_x - @loc_x).abs
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

    [sensors, beacons.uniq]
end

def bound_range(range, bounds = nil)
    [
        bounds ? [range[0], bounds[0]].max : range[0], 
        bounds ? [range[1], bounds[1]].min : range[1]
    ]
end

def merge_ranges(ranges, bounds = nil)
    sorted_ranges = ranges.sort
    merged_ranges = []
    merged_ranges.unshift(bound_range(sorted_ranges[0], bounds))

    (1...sorted_ranges.size).each do |i|
        range = bound_range(sorted_ranges[i], bounds)
        working_range = merged_ranges.shift

        if working_range[0] <= range[1] and working_range[1] >= range[0]
            new_start = working_range[0]
            new_end = [range[1], working_range[1]].max
            merged_ranges.unshift([new_start, new_end])
            next
        end

        merged_ranges.unshift(working_range)
        merged_ranges.unshift(range)
    end

    merged_ranges.sort
end

def scan_line(sensors, beacons, test_line, bounds = nil)
    coverage_ranges = []

    sensors.each do |sensor|
        if sensor.intersects(test_line)
            coverage_range = sensor.coverage_range(test_line)
            coverage_ranges.push(coverage_range) if coverage_range
        end
    end

    merge_ranges(coverage_ranges, bounds)
end

def count_coverage(ranges)
    ranges.reduce(1) { |sum, range| sum + range[1] - range[0] }
end

def part1(sensors, beacons)
    a = Time.new.to_i * 1000

    test_line = 2_000_000
    coverage_ranges = scan_line(sensors, beacons, test_line)
    puts count_coverage(coverage_ranges) - beacons.count { |beacon| beacon[1] == test_line }

    puts "part 1 took #{Time.new.to_i * 1000 - a}ms"
end

def part2(sensors, beacons)
    a = Time.new.to_i * 1000

    distress_beacon = [0,0]
    bounds = [0, 4_000_000]

    (0...bounds[1]).each do |y|
        coverage_ranges = scan_line(sensors, beacons, y, bounds)
        coverage = count_coverage(coverage_ranges)
        if bounds[1] - coverage == 1
            x = coverage_ranges[0][1] + 1
            distress_beacon = [x, y]
            break
        end
    end

    puts 4_000_000 * distress_beacon[0] + distress_beacon[1]

    puts "part 2 took #{Time.new.to_i * 1000 - a}ms"
end

sensors, beacons = parse_input(input)
part1(sensors, beacons)
part2(sensors, beacons)
