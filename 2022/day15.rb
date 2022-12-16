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

    def location
        [@loc_x, @loc_y]
    end
end

def part1(input)
    input.each do |line|
        puts line
    end

    # for each sensor, use closest beacon to find sensor diamond "radius"
    sensors = input.map do |line|
        sensor_x, sensor_y, beacon_x, beacon_y = /Sensor at x=([-\d]+), y=([-\d]+): closest beacon is at x=([-\d]+), y=([-\d]+)/.match(line).captures.map(&:to_i)
        
        sensor = Sensor.new(sensor_x, sensor_y)
        sensor.detect_beacon(beacon_x, beacon_y)

        puts "sensor at #{sensor.location} has radius #{sensor.radius}"
    end

    # for each sensor, use closest beacon to find sensor diamond "radius"
    # using sensor diamond radius, calculate top/right/bottom/left points of sensor diamond
    # for each sensor diamond that intersect with target line, generate a range of points on the line
    # push each point in range into a set
    # count points in set
end

part1(input)

