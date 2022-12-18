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

    def compute_distances
        neighbours = @connected_valves
        dist = 0
        
        dists = {}
        dists[@name] = dist
    
        while not neighbours.empty?
            dist += 1
    
            new_neighbours = []
            neighbours.each do |neighbour|
                if not dists.has_key?(neighbour.name)
                    dists[neighbour.name] = dist
                    new_neighbours += neighbour.connected_valves
                end
            end
    
            neighbours = new_neighbours
        end
    
        @dists = dists
    end

    def distance_to(valve)
        @dists[valve.name]
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

def compute_flow(start, path)
    time = 30
    total_flow = 0
    current_valve = start
    path.each do |next_valve|
        time -= current_valve.distance_to(next_valve) + 1
        break if time < 0
        total_flow += time * next_valve.flow_rate
        current_valve = next_valve
    end
    total_flow
end

def find_valve_paths(start, valves_to_open, time_left)
    paths = []
    build_paths_recursive(start, valves_to_open, time_left, [], paths)
    paths
end

def build_paths_recursive(valve, valves_to_open, time_left, current_path, paths)
    valves_to_open.each do |next_valve|
        time_to_move_and_open = valve.distance_to(next_valve) + 1
        new_time_left = time_left - time_to_move_and_open
        if new_time_left > 0
            build_paths_recursive(next_valve, valves_to_open - [next_valve], new_time_left, current_path + [next_valve], paths)
        end
    end
    paths.append(current_path)
end

def part1(valves)
    start_time = Time.new
    puts "Starting at #{start_time}..."

    start = valves['AA']
    valves_to_open = valves.values.select { |v| v.flow_rate > 0 }
    possible_paths = find_valve_paths(start, valves_to_open, 30)
    num_possible_paths = possible_paths.size
    log_every = num_possible_paths / 10;
    best = 0
    count = 0
    start_time_s = Time.new.to_i

    puts "Found #{num_possible_paths} possible paths..."

    possible_paths.each do |path|
        path_flow = compute_flow(start, path)
        if path_flow > best
            puts "[#{Time.new.to_i - start_time_s}s #{(count.fdiv(num_possible_paths)).round(1) * 100}%] checked #{count}, found a new best path #{path} with #{path_flow}..."
            best = path_flow
        end
        if count % log_every == 0
            puts "[#{Time.new.to_i - start_time_s}s #{(count.fdiv(num_possible_paths)).round(1) * 100}%] checked #{count}, best is #{best}, latest was #{path.map(&:name)} with #{path_flow}..."
        end
        count += 1
    end

    end_time = Time.new

    puts "Best is #{best}"
    puts "Finished at #{end_time}, #{end_time.to_i * 1000 - start_time.to_i * 1000}ms..."
end

valves = parse_input(ARGF.readlines)
valves.values.each { |valve| valve.compute_distances }

part1(valves)
#part2(valves)