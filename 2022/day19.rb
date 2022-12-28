require 'set'

Blueprint = Struct.new(:id, :ore_robot_ore_cost, :clay_robot_ore_cost, :obsidian_robot_ore_cost, :obsidian_robot_clay_cost, :geode_robot_ore_cost, :geode_robot_obsidian_cost)
State = Struct.new(:minute, :ore, :clay, :obsidian, :geodes, :ore_robots, :clay_robots, :obsidian_robots, :geode_robots)

def parse_input(input)
    input.map do |blueprint_spec|
        blueprint_parts = /Blueprint (\d+): Each ore robot costs (\d+) ore. Each clay robot costs (\d+) ore. Each obsidian robot costs (\d+) ore and (\d+) clay. Each geode robot costs (\d+) ore and (\d+) obsidian./
            .match(blueprint_spec)
            .captures
            .map(&:to_i)
        Blueprint.new(*blueprint_parts)
    end
end

def crack_geodes(blueprint, time_allowed=24)
    states = Set.new([State.new(0, 0, 0, 0, 0, 1, 0, 0, 0)])
    finished_paths = []
    minute = 0

    while not states.empty?
        puts "\tMinute #{minute}, #{states.size} state(s)..."
        next_states = Set.new

        # TODO keep track of current max, and abandon state paths once they can't beat it in time?

        states.each do |state|
            next_minute = state.minute + 1

            if next_minute > time_allowed
                finished_paths.push(state)
                next
            end

            new_ore = state.ore + state.ore_robots
            new_clay = state.clay + state.clay_robots
            new_obsidian = state.obsidian + state.obsidian_robots
            new_geodes = state.geodes + state.geode_robots

            next_states.add(State.new(next_minute, new_ore, new_clay, new_obsidian, new_geodes, state.ore_robots, state.clay_robots, state.obsidian_robots, state.geode_robots))

            # TODO possible optimizations:
            # - once we have a geode robot, only try the state where we buy another geode robot?

            if state.ore >= blueprint.ore_robot_ore_cost
                next_states.add(State.new(next_minute, new_ore - blueprint.ore_robot_ore_cost, new_clay, new_obsidian, new_geodes, state.ore_robots + 1, state.clay_robots, state.obsidian_robots, state.geode_robots))
            end
            if state.ore >= blueprint.clay_robot_ore_cost
                next_states.add(State.new(next_minute, new_ore - blueprint.clay_robot_ore_cost, new_clay, new_obsidian, new_geodes, state.ore_robots, state.clay_robots + 1, state.obsidian_robots, state.geode_robots))
            end
            if state.ore >= blueprint.obsidian_robot_ore_cost and state.clay >= blueprint.obsidian_robot_clay_cost
                next_states.add(State.new(next_minute, new_ore - blueprint.obsidian_robot_ore_cost, new_clay - blueprint.obsidian_robot_clay_cost, new_obsidian, new_geodes, state.ore_robots, state.clay_robots, state.obsidian_robots + 1, state.geode_robots))
            end
            if state.ore >= blueprint.geode_robot_ore_cost and state.obsidian >= blueprint.geode_robot_obsidian_cost
                next_states.add(State.new(next_minute, new_ore - blueprint.geode_robot_ore_cost, new_clay, new_obsidian - blueprint.geode_robot_obsidian_cost, new_geodes, state.ore_robots, state.clay_robots, state.obsidian_robots, state.geode_robots + 1))
            end
        end

        states = next_states
        minute += 1
    end

    finished_paths.map(&:geodes).max || 0
end

def part1(input)
    blueprints = parse_input(input)
    quality_levels = blueprints.map do |blueprint|
        start_time = Time.new
        puts "Testing blueprint #{blueprint}..."
        best_geodes = crack_geodes(blueprint)
        puts "\tcracked #{best_geodes} for quality level #{blueprint.id * best_geodes} in #{Time.new.to_i - start_time.to_i}s"
        blueprint.id * best_geodes
    end
    puts quality_levels.sum
end

input = ARGF.read.split("\n")
part1(input)
