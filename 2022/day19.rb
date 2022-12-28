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

def crack_geodes(blueprint, state, time_allowed=24)
    # TODO (haha)
    0
end

def part1(input)
    blueprints = parse_input(input)
    quality_levels = blueprints.map { |blueprint| blueprint.id * crack_geodes(blueprint, State.new(1, 0, 0, 0, 0, 1, 0, 0, 0)) }
    puts quality_levels.sum
end

input = ARGF.read.split("\n")
part1(input)
