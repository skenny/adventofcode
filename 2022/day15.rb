input = ARGF.readlines

class Sensor
    attr_accessor :location

    def initialize(loc_x, loc_y)
        @loc_x = loc_x
        @loc_y = loc_y
    end

    def detect_beacon(beacon_x, beacon_y)
        # use the beacon coordinates to determine the sensor diamond "radius" so we can determine the top/right/bottom/left points of coverage

        #puts "detecting #{beacon_x}, #{beacon_y} from #{location}..."
        
        d_x = beacon_x - @loc_x     # negative means beacon is left
        d_y = beacon_y - @loc_y     # negative means beacon is above

        # OPTIMIZATION - no need to step if the beacon is on an axis with the sensor, just use the deviation on the other axis

        step_x = beacon_x < @loc_x ?  1 : beacon_x > @loc_x ? -1 : 0
        step_y = beacon_y < @loc_y ? -1 : beacon_y > @loc_y ?  1 : 0

        #puts "\tstepping #{step_x}, #{step_y}..."

        # from d_x, d_y, use manhattan stepping to find a point of coverage
        at_x = beacon_x
        at_y = beacon_y
        while at_x != @loc_x and at_y != @loc_y do
            #puts "\tat #{at_x}, #{at_y}..."
            at_x += step_x
            at_y += step_y
        end

        #puts "\tended at #{at_x}, #{at_y}..."

        # the radius is the distance from the sensor on either the x or y axis (whichever we hit)
        if at_x == @loc_x
            @radius = (at_y - @loc_y).abs
        else
            @radius = (at_x - @loc_x).abs
        end

        #puts "\tradius is #{@radius}..."
    end

    def intersects(y_line)
        y_line == @loc_y or (y_line >= @loc_y - @radius and y_line <= @loc_y + @radius)
    end

    def coverage_area(y_line)
        if intersects(y_line)
            d_y = (y_line - @loc_y).abs
            [@loc_x - @radius + d_y, @loc_x + @radius - d_y]
        else
            []
        end
    end

    def location
        [@loc_x, @loc_y]
    end
end

def parse_input(input)
    sensors = []
    beacons = []

    input.each do |line|
        sensor_x, sensor_y, beacon_x, beacon_y = /Sensor at x=([-\d]+), y=([-\d]+): closest beacon is at x=([-\d]+), y=([-\d]+)/.match(line).captures.map(&:to_i)

        sensor = Sensor.new(sensor_x, sensor_y)

        sensors.push(sensor)
        beacons.push([beacon_x, beacon_y])

        sensor.detect_beacon(beacon_x, beacon_y)
    end

    [sensors, beacons]
end

def part1(sensors, beacons, test_line_y)
    points_on_test_line = []
    beacons_on_test_line = beacons.uniq.count { |beacon| beacon[1] == test_line_y }

    sensors.each do |sensor|
        if sensor.intersects(test_line_y)
            x1, x2 = sensor.coverage_area(test_line_y)
            #puts "sensor at #{sensor.location} and radius #{sensor.radius} intersects #{test_line_y} with #{points_on_line.count} points (#{points_on_line[0]}..#{points_on_line.last})"
            points_on_test_line += (x1..x2).to_a
        end
    end

    puts points_on_test_line.uniq.count - beacons_on_test_line
end

def part2(sensors, beacons)
    (0...4_000_000).each do |y|
        points_on_line = part1(sensors, beacons, y)
        if 4_000_000 - points_on_line == 1
            puts "it's on line #{y}"
        end
    end
end

sensors, beacons = parse_input(input)

a = Time.new.to_i * 1000
part1(sensors, beacons, 2000000)
puts "part 1 took #{Time.new.to_i * 1000 - a}ms"

a = Time.new.to_i * 1000
part2(sensors, beacons)
puts "part 1 took #{Time.new.to_i * 1000 - a}ms"
