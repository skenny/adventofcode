input = ARGF.readlines

class Sensor
    attr_accessor :location, :radius

    def initialize(loc_x, loc_y)
        @loc_x = loc_x
        @loc_y = loc_y
    end

    def detect_beacon(beacon_x, beacon_y)
        # use the beacon coordinates to determine the sensor diamond "radius" so we can determine the top/right/bottom/left points of coverage
        puts "detecting #{beacon_x}, #{beacon_y} from #{location}..."
        
        d_x = beacon_x - @loc_x     # negative means beacon is left
        d_y = beacon_y - @loc_y     # negative means beacon is above

        # OPTIMIZATION - no need to step if the beacon is on an axis with the sensor, just use the deviation on the other axis

        step_x = beacon_x < @loc_x ?  1 : beacon_x > @loc_x ? -1 : 0
        step_y = beacon_y < @loc_y ? -1 : beacon_y > @loc_y ?  1 : 0

        puts "\tstepping #{step_x}, #{step_y}..."

        # from d_x, d_y, use manhattan stepping to find a point of coverage
        at_x = beacon_x
        at_y = beacon_y
        while at_x != @loc_x and at_y != @loc_y do
            #puts "\tat #{at_x}, #{at_y}..."
            at_x += step_x
            at_y += step_y
        end

        puts "\tended at #{at_x}, #{at_y}..."

        # the radius is the distance from the sensor on either the x or y axis (whichever we hit)
        if at_x == @loc_x
            @radius = (at_y - @loc_y).abs
        else
            @radius = (at_x - @loc_x).abs
        end

        puts "\tradius is #{@radius}..."
    end

    def points
        if @radius = nil
            puts "radius not computed, can't determine points"
            return []
        end
        return [
            [@loc_x, @loc_y - @radius],
            [@loc_x + @radius, @loc_y],
            [@loc_x, @loc_y + @radius],
            [@loc_x - @radius, @loc_y]
        ]
    end

    def intersects(y_line)
        if y_line == @loc_y
            #puts "y #{y_line} intersects sensor #{location} with radius #{@radius} diamond on y-axis"
            # on the sensor y-axis 
            true
        elsif y_line < @loc_y and y_line >= @loc_y - radius
            #puts "y #{y_line} intersects sensor #{location} with radius #{@radius} diamond above sensor"
            # above the sensor
            true
        elsif y_line > @loc_y and y_line <= @loc_y + radius
            #puts "y #{y_line} intersects sensor #{location} with radius #{@radius} diamond below sensor"
            # below the sensor
            true
        else
            #puts "y #{y_line} does not intersect sensor #{location} with radius #{@radius}"
            false
        end
    end

    def points_on_line(y_line)
        if intersects(y_line)
            d_y = (y_line - @loc_y).abs
            (@loc_x - @radius + d_y..@loc_x + @radius - d_y).to_a
        else
            []
        end
    end

    def location
        [@loc_x, @loc_y]
    end
end

def part1(input, test_line_y)
    input.each do |line|
        puts line
    end

    sensors = []
    beacons = []

    # for each sensor, use closest beacon to find sensor diamond "radius"
    input.each do |line|
        sensor_x, sensor_y, beacon_x, beacon_y = /Sensor at x=([-\d]+), y=([-\d]+): closest beacon is at x=([-\d]+), y=([-\d]+)/.match(line).captures.map(&:to_i)

        sensor = Sensor.new(sensor_x, sensor_y)

        sensors.push(sensor)
        beacons.push([beacon_x, beacon_y])

        # for each sensor, use closest beacon to find sensor diamond "radius"
        sensor.detect_beacon(beacon_x, beacon_y)
    end

    points_on_test_line = []
    beacons_on_test_line = beacons.uniq.count { |beacon| beacon[1] == test_line_y }

    sensors.each do |sensor|
        # using sensor diamond radius, calculate top/right/bottom/left points of sensor diamond
        # for each sensor diamond that intersect with target line, generate a range of points on the line
        # push each point in range into a set
        if sensor.intersects(test_line_y)
            points_on_line = sensor.points_on_line(test_line_y)
            puts "sensor at #{sensor.location} and radius #{sensor.radius} intersects #{test_line_y} with #{points_on_line.count} points (#{points_on_line[0]}..#{points_on_line.last})"
            points_on_test_line += points_on_line
        end
    end

    # count points in set
    #puts points_on_test_line.sort.uniq.join(",")
    puts points_on_test_line.uniq.count - beacons_on_test_line
end

#part1(input, 10)
part1(input, 2000000)

