Point = Struct.new(:x, :y, :z)

class World

    def initialize(grid_spec)
        @grid_sections = parse_grid_sections(grid_spec)
        @player = Point.new(0, 0, 0)
    end

    def parse_grid_sections(grid_spec)
        grid_size = grid_spec.size / 3
        blank_row = ' ' * grid_size
        sections = []
        grid_spec.each_slice(grid_size) do |grid_block|
            (grid_block[0].size / grid_size).times do |grid_i|
                grid = grid_block.map { |row| row.slice(grid_i * grid_size, grid_size) }
                sections.push(grid) if grid[0] != blank_row
            end
        end
        sections
    end

    def move_player(move)
    end
end

def parse_moves(moves_spec)
    moves_spec.scan(/\d+|\D+/)
end

def part1(grid_spec, moves_spec)
    world = World.new(grid_spec)
    moves = parse_moves(moves_spec)
    moves.each do |move|
        world.move_player(move)
    end
end

grid_spec, moves_spec = ARGF.read.split("\n\n").map{ |section_lines| section_lines.split("\n") }
part1(grid_spec, moves_spec[0])
