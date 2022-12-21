class Valve
    attr_accessor :name, :flow_rate, :connected_valves

    def initialize(name, flow_rate)
        @name = name
        @flow_rate = flow_rate
        @connected_valves = []
    end

    def connect(other_valves)
        @connected_valves = other_valves
    end

    def shortest_paths_to_valves(valves)
        @dists.select { |other_valve, dist| valves.include?(other_valve) }
    end

    def compute_shortest_paths
        neighbours = @connected_valves
        dist = 0
        
        dists = {}
        dists[self] = dist
    
        while not neighbours.empty?
            dist += 1
    
            new_neighbours = []
            neighbours.each do |neighbour|
                if not dists.has_key?(neighbour)
                    dists[neighbour] = dist
                    new_neighbours += neighbour.connected_valves
                end
            end
    
            neighbours = new_neighbours
        end
    
        @dists = dists
    end

    def to_s
        "#{@name}"
    end

    def inspect
        "#{@name}"
    end
end

def parse_input(input)
    valves = {}

    # create each valve
    input.each do |line|
        name, flow_rate, connected_valves_str = /Valve ([A-Z]+) has flow rate=(\d+); tunnels? leads? to valves? (.*)/.match(line).captures
        valves[name] = Valve.new(name, flow_rate.to_i)
    end

    # hook 'em all up
    input.each do |line|
        name, flow_rate, connected_valves_str = /Valve ([A-Z]+) has flow rate=(\d+); tunnels? leads? to valves? (.*)/.match(line).captures
        connected_valves = connected_valves_str.split(', ').map { |valve_name| valves[valve_name] }
        valves[name].connect(connected_valves)
    end

    valves
end

def search_paths(current_valve, to_visit, time_allowed, time_taken = 0, total_flow = 0)
    best_flow = current_valve
        .shortest_paths_to_valves(to_visit)
        .select { |valve, dist| time_taken + dist + 1 < time_allowed }
        .map { |next_valve, dist|
            search_paths(
                next_valve,
                to_visit - [next_valve],
                time_allowed,
                time_taken + dist + 1,
                total_flow + (next_valve.flow_rate * (time_allowed - time_taken - dist - 1))
            )
        }
        .max
    best_flow || total_flow
end

def part1(valves)
    start_time = Time.new
    puts "Starting at #{start_time}..."

    time_limit = 30
    start = valves['AA']
    valves_to_open = valves.values.select { |v| v.flow_rate > 0 }

    best = valves_to_open
        .combination(valves_to_open.size)
        .map { |path| search_paths(start, valves_to_open, time_limit) }
        .max

    end_time = Time.new

    puts "Part 1: #{best}"
    puts "Finished at #{end_time}, #{end_time.to_i * 1000 - start_time.to_i * 1000}ms..."
end

def part2(valves)
    start_time = Time.new
    puts "Starting at #{start_time}..."

    time_limit = 26
    start = valves['AA']
    valves_to_open = valves.values.select { |v| v.flow_rate > 0 }

    best = valves_to_open
        .combination(valves_to_open.size / 2)
        .map { |half_path| search_paths(start, half_path, time_limit) + search_paths(start, valves_to_open - half_path, time_limit) }
        .max

    end_time = Time.new

    puts "Part 2: #{best}"
    puts "Finished at #{end_time}, #{end_time.to_i * 1000 - start_time.to_i * 1000}ms..."
end

valves = parse_input(ARGF.readlines)
valves.values.each { |valve| valve.compute_shortest_paths }

part1(valves)
part2(valves)