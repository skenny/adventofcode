input = File.read("2022/day7input.txt").split("\n")
#input = File.read("2022/day7testinput.txt").split("\n")

class AocDirectory
    attr_accessor :name

    def initialize(name)
        @name = name
        @child_dirs = []
        @files = []
    end

    def add_child_dir(dir)
        @child_dirs.push(dir)
    end

    def add_file(file)
        @files.push(file)
    end

    def size
        @files.map(&:size).sum + @child_dirs.map(&:size).sum
    end
end

class AocFile
    attr_accessor :name
    attr_accessor :size

    def initialize(name, size)
        @name = name
        @size = size
    end
end

def part1(dirs)
    dirs.select { |dir| dir.size < 100_000 }.map(&:size).sum
end

def part2(dirs)
    free_space = 70_000_000 - dirs[0].size
    extra_space_needed = 30_000_000 - free_space
    dirs.sort { |a, b| a.size - b.size }.find { |dir| dir.size >= extra_space_needed }.size
end

def parse_input(input)
    dirs = []
    path = []
    input.each do |line|
        if line.start_with?("$ cd")
            dir_name = line[5..]
            if dir_name == ".."
                path.pop
            else
                new_dir = AocDirectory.new(dir_name)
                path.last.add_child_dir(new_dir) unless path.empty?
                path.push(new_dir)
                dirs.push(new_dir)
            end
        elsif line[0].match(/\d/)
            file_size, file_name = line.split
            path.last.add_file(AocFile.new(file_name, file_size.to_i))
        end
    end
    dirs
end

dirs = parse_input(input)
puts part1(dirs)
puts part2(dirs)
