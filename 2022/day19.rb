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

def crack_geodes(blueprint, states_to_try, time_allowed=24)
    results = states_to_try.each do |state|
        if state.minute > time_allowed
            next
        end

        new_ore = state.ore + state.ore_robots
        new_clay = state.clay + state.clay_robots
        new_obsidian = state.obsidian + state.obsidian_robots
        new_geodes = state.geodes + state.geode_robots

        next_minute = state.minute + 1
        next_states = []
        next_states.push(State.new(next_minute, new_ore, new_clay, new_obsidian, new_geodes, state.ore_robots, state.clay_robots, state.obsidian_robots, state.geode_robots))

        # possible optimizations:
        # - once we have a geode robot, only try the state where we buy another geode robot

        if new_ore >= blueprint.ore_robot_ore_cost
            next_states.push(State.new(next_minute, new_ore - blueprint.ore_robot_ore_cost, new_clay, new_obsidian, new_geodes, state.ore_robots + 1, state.clay_robots, state.obsidian_robots, state.geode_robots))
        end
        if new_ore >= blueprint.clay_robot_ore_cost
            next_states.push(State.new(next_minute, new_ore - blueprint.clay_robot_ore_cost, new_clay, new_obsidian, new_geodes, state.ore_robots, state.clay_robots + 1, state.obsidian_robots, state.geode_robots))
        end
        if new_ore >= blueprint.obsidian_robot_ore_cost and new_clay >= blueprint.obsidian_robot_clay_cost
            next_states.push(State.new(next_minute, new_ore - blueprint.obsidian_robot_ore_cost, new_clay - blueprint.obsidian_robot_clay_cost, new_obsidian, new_geodes, state.ore_robots, state.clay_robots, state.obsidian_robots + 1, state.geode_robots))
        end
        if new_ore >= blueprint.geode_robot_ore_cost and new_obsidian >= blueprint.geode_robot_obsidian_cost
            next_states.push(State.new(next_minute, new_ore - blueprint.geode_robot_ore_cost, new_clay, new_obsidian - blueprint.geode_robot_obsidian_cost, new_geodes, state.ore_robots, state.clay_robots, state.obsidian_robots, state.geode_robots + 1))
        end

        crack_geodes(blueprint, next_states, time_allowed)
    end
    results.map(&:geodes).max
end

def part1(input)
    blueprints = parse_input(input)
    quality_levels = blueprints.map { |blueprint| blueprint.id * crack_geodes(blueprint, [State.new(1, 0, 0, 0, 0, 1, 0, 0, 0)]) }
    puts quality_levels.sum
end

input = ARGF.read.split("\n")
part1(input)
