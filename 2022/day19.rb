class Blueprint
    attr_accessor :id
    attr_accessor :ore_robot_ore_cost
    attr_accessor :clay_robot_ore_cost
    attr_accessor :obsidian_robot_ore_cost
    attr_accessor :obsidian_robot_clay_cost
    attr_accessor :geode_robot_ore_cost
    attr_accessor :geode_robot_obsidian_cost

    def initialize(blueprint_parts)
        @id = blueprint_parts[0]
        @ore_robot_ore_cost = blueprint_parts[1]
        @clay_robot_ore_cost = blueprint_parts[2]
        @obsidian_robot_ore_cost = blueprint_parts[3]
        @obsidian_robot_clay_cost = blueprint_parts[4]
        @geode_robot_ore_cost = blueprint_parts[5]
        @geode_robot_obsidian_cost = blueprint_parts[6]
    end

    def to_s
        "Blueprint #{@id}: ore=[#{@ore_robot_ore_cost} ore], clay=[#{@clay_robot_ore_cost} ore], obsidian=[#{@obsidian_robot_ore_cost} ore, #{@obsidian_robot_clay_cost} clay], geode=[#{@geode_robot_ore_cost} ore, #{@geode_robot_obsidian_cost} obsidian]"
    end
end

def parse_input(input)
    input.map do |blueprint_spec|
        blueprint_parts = /Blueprint (\d+): Each ore robot costs (\d+) ore. Each clay robot costs (\d+) ore. Each obsidian robot costs (\d+) ore and (\d+) clay. Each geode robot costs (\d+) ore and (\d+) obsidian./
            .match(blueprint_spec)
            .captures
            .map(&:to_i)
        Blueprint.new(blueprint_parts)
    end
end

def crack_geodes(blueprint, time_allowed=24)
    0
end

def part1(input)
    blueprints = parse_input(input)
    quality_levels = blueprints.map { |blueprint| blueprint.id * crack_geodes(blueprint) }
    puts quality_levels.sum
end

input = ARGF.read.split("\n")
part1(input)
