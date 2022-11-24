import copy

INPUT_FILE = "day17-input"
TEST_INPUT_FILE = "day17-input-test"

ACTIVE = "#"
INACTIVE = "."

class PocketDimension:
    cubes = {}
    min_x = 0
    max_x = 0
    min_y = 0
    max_y = 0
    min_z = 0
    max_z = 0
    min_w = 0
    max_w = 0

    def setup_grid(self, grid):
        for y, row in enumerate(grid):
            for x, col in enumerate(row):
                self.update_cube(x, y, 0, 0, col)

    def get_cube(self, x, y, z, w):
        return self.cubes.get((x, y, z, w), INACTIVE)

    def activate_cube(self, x, y, z, w):
        self.update_cube(x, y, z, w, ACTIVE)

    def deactivate_cube(self, x, y, z, w):
        self.update_cube(x, y, z, w, INACTIVE)

    def update_cube(self, x, y, z, w, state):
        self.cubes[(x, y, z, w)] = state
        if x > self.max_x: self.max_x = x
        if x < self.min_x: self.min_x = x
        if y > self.max_y: self.max_y = y
        if y < self.min_y: self.min_y = y
        if z > self.max_z: self.max_z = z
        if z < self.min_z: self.min_z = z
        if w > self.max_w: self.max_w = w
        if w < self.min_w: self.min_w = w

    def count_active_neighbours(self, x, y, z, w):
        offsets = (-1, 0, 1)
        neighbours = []
        for xo in offsets:
            for yo in offsets:
                for zo in offsets:
                    for wo in offsets:
                        if not (xo == 0 and yo == 0 and zo == 0 and wo == 0):
                            neighbours.append(self.get_cube(x + xo, y + yo, z + zo, w + wo))
        return neighbours.count(ACTIVE)

    def count_active_cubes(self):
        num_active = 0
        for k, v in self.cubes.items():
            num_active += 1 if v == ACTIVE else 0
        return num_active

    def make_copy(self):
        copy_version = PocketDimension()
        copy_version.cubes = copy.deepcopy(self.cubes)
        copy_version.min_x = self.min_x
        copy_version.max_x = self.max_x
        copy_version.min_y = self.min_y
        copy_version.max_y = self.max_y
        copy_version.min_z = self.min_z
        copy_version.max_z = self.max_z
        copy_version.min_w = self.min_w
        copy_version.max_w = self.max_w
        return copy_version

    def expanded_x_range(self):
        return self.expand_range(self.min_x, self.max_x)

    def expanded_y_range(self):
        return self.expand_range(self.min_y, self.max_y)

    def expanded_z_range(self):
        return self.expand_range(self.min_z, self.max_z)

    def expanded_w_range(self):
        return self.expand_range(self.min_w, self.max_w)

    def expand_range(self, min, max):
        return range(min - 1, max + 2)

    def print(self):
        for w in range(self.min_w, self.max_w + 1):
            for z in range(self.min_z, self.max_z + 1):
                grid = []
                for y in range(self.min_y, self.max_y + 1):
                    row = ""
                    for x in range(self.min_x, self.max_x + 1):
                        row += self.get_cube(x, y, z)
                    grid.append(row)
                print("z={}, w={}\n{}\n{}".format(z, w, "\n".join(grid), "=" * len(grid[0])))

def read_input(file):
    with open(file, "r") as fin:
        return [l.strip() for l in fin]

def run(label, input_file):
    pocket_dimension = PocketDimension()
    pocket_dimension.setup_grid(read_input(input_file))
    
    for cycle in range(6):
        #print("cycle", cycle + 1)
        #pocket_dimension.print()

        new_pocket_dimension = pocket_dimension.make_copy()

        for x in new_pocket_dimension.expanded_x_range():
            for y in new_pocket_dimension.expanded_y_range():
                for z in new_pocket_dimension.expanded_z_range():
                    for w in new_pocket_dimension.expanded_w_range():
                        cube = pocket_dimension.get_cube(x, y, z, w)
                        num_active_neighbours = pocket_dimension.count_active_neighbours(x, y, z, w)
                        if cube == ACTIVE and num_active_neighbours not in (2, 3):
                            new_pocket_dimension.deactivate_cube(x, y, z, w)
                        if cube == INACTIVE and num_active_neighbours == 3:
                            new_pocket_dimension.activate_cube(x, y, z, w)

        pocket_dimension = new_pocket_dimension

    print("{}: {}".format(label, pocket_dimension.count_active_cubes()))

run("test", TEST_INPUT_FILE)
run("part", INPUT_FILE)