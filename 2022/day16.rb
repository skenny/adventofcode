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

def find_paths_old(valves_to_open)
    current = valves['AA']
    paths = []
    valves_to_open.sort { |a,b| b.flow_rate - a.flow_rate }

    30.times do |minute|
        puts "minute #{minute}..."

        new_paths = []
        paths.each do |path|
            #puts "current path length is #{path.size}; #{path.map(&:name)}"
            current_valve = path.last
            if current_valve.flow_rate > 0
                new_paths.append(path + [current_valve])    # stay here to open the valve
            end
            current_valve.connected_valves.each do |neighbour|
                new_paths.append(path + [neighbour])
            end
        end

        if new_paths.size > 10_000
            new_paths = new_paths.sort { |a,b| run_path(b) - run_path(a) }
        end

        paths = new_paths[0..10_000]
    end

    paths
end

def find_valve_paths(valve, valves_to_open, time_left)
    paths = []
    dfs(valve, valves_to_open, time_left, [], paths)
    paths
end

def dfs(valve, valves_to_open, time_left, visited, paths)
    if time_left > 0
        valves_to_open.each do |next_valve|
            if visited.include?(next_valve)
                next
            end
            time_to_move_and_open = valve.distance_to(next_valve) - 1
            if time_left - time_to_move_and_open <= 0
                next
            end
            dfs(next_valve, valves_to_open, time_left - time_to_move_and_open, visited + [next_valve], paths)
        end
    end
    paths.append(visited)
end

def part1(valves)
    puts "Starting at #{Time.new}..."
    start = valves['AA']

    valves_to_open = valves.values.select { |v| v.flow_rate > 0 }
    valve_paths = find_valve_paths(start, valves_to_open, 30)
    num_possible_paths = valve_paths.size
    puts "Found #{num_possible_paths} possible paths..."

    best = 0
    count = 0
    start_time_s = Time.new.to_i
    valve_paths.each do |path|
        path_flow = compute_flow(start, path)
        best = [best, path_flow].max
        if count % 10_000_000 == 0
            pct = count / num_possible_paths * 100
            elapsed_s = Time.new.to_i - start_time_s
            puts "[#{elapsed_s}s #{pct}%] checked #{count}, best is #{best}, latest was #{path.map(&:name)} with #{path_flow}..."
        end
        count += 1
    end

    puts best.to_s
    puts "Finished at #{Time.new}..."
end

valves = parse_input(ARGF.readlines)
valves.values.each { |valve| valve.compute_distances }

part1(valves)
#part2(valves)