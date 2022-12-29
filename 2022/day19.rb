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

    max_orebots_needed = [blueprint.ore_robot_ore_cost, blueprint.obsidian_robot_ore_cost, blueprint.geode_robot_ore_cost].max
    max_claybots_needed = blueprint.obsidian_robot_clay_cost
    max_obsidibots_needed = blueprint.geode_robot_obsidian_cost

    while not states.empty?
        puts "\tMinute #{minute}, #{states.size} state(s)..."
        next_states = Set.new

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

            can_buy_orebot = state.ore >= blueprint.ore_robot_ore_cost
            can_buy_claybot = state.ore >= blueprint.clay_robot_ore_cost
            can_buy_obsidibot = state.ore >= blueprint.obsidian_robot_ore_cost && state.clay >= blueprint.obsidian_robot_clay_cost
            can_buy_geodebot = state.ore >= blueprint.geode_robot_ore_cost && state.obsidian >= blueprint.geode_robot_obsidian_cost

            if can_buy_orebot && state.ore_robots < max_orebots_needed
                next_states.add(State.new(next_minute, new_ore - blueprint.ore_robot_ore_cost, new_clay, new_obsidian, new_geodes, state.ore_robots + 1, state.clay_robots, state.obsidian_robots, state.geode_robots))
            end
            if can_buy_claybot && state.clay_robots < max_claybots_needed
                next_states.add(State.new(next_minute, new_ore - blueprint.clay_robot_ore_cost, new_clay, new_obsidian, new_geodes, state.ore_robots, state.clay_robots + 1, state.obsidian_robots, state.geode_robots))
            end
            if can_buy_obsidibot && state.obsidian_robots < max_obsidibots_needed
                next_states.add(State.new(next_minute, new_ore - blueprint.obsidian_robot_ore_cost, new_clay - blueprint.obsidian_robot_clay_cost, new_obsidian, new_geodes, state.ore_robots, state.clay_robots, state.obsidian_robots + 1, state.geode_robots))
            end
            if can_buy_geodebot
                next_states.add(State.new(next_minute, new_ore - blueprint.geode_robot_ore_cost, new_clay, new_obsidian - blueprint.geode_robot_obsidian_cost, new_geodes, state.ore_robots, state.clay_robots, state.obsidian_robots, state.geode_robots + 1))
            end

            next_states.add(State.new(next_minute, new_ore, new_clay, new_obsidian, new_geodes, state.ore_robots, state.clay_robots, state.obsidian_robots, state.geode_robots))
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

def part2(input)
    blueprints = parse_input(input).take(3)
    geodes = blueprints.map do |blueprint|
        start_time = Time.new
        puts "Testing blueprint #{blueprint}..."
        best_geodes = crack_geodes(blueprint, 32)
        puts "\tcracked #{best_geodes} in #{Time.new.to_i - start_time.to_i}s"
        best_geodes
    end
    puts geodes.to_s
    puts geodes.reduce(:*)
end

input = ARGF.read.split("\n")
#part1(input)
part2(input)
