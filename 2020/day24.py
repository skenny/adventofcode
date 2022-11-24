class TileFloor:

    def __init__(self, flipped_tile_paths):
        self.tiles = dict()

        # create center tile
        self.check_tile((0, 0))

        # set initial layout
        for tile_path in flipped_tile_paths:
            x = 0
            y = 0

            for direction in tile_path:
                if direction == "ne":
                    x += 1
                    y += 1
                if direction == "e":
                    x += 2
                if direction == "se":
                    x += 1
                    y -= 1
                if direction == "nw":
                    x -= 1
                    y += 1
                if direction == "w":
                    x -= 2
                if direction == "sw":
                    x -= 1
                    y -= 1

                # create each tile encountered
                self.check_tile((x, y))

            self.flip_tile((x, y))

    def cycle(self, num_days):
        for day in range(num_days):
            tiles_to_flip = []

            # enclose all placed tiles
            for tile_coord in list(self.tiles.keys()):
                num_black_neighbours = 0

                for v in [(1, 1), (2, 0), (1, -1), (-1, 1), (-2, 0), (-1, -1)]:
                    coord_v = (tile_coord[0] + v[0], tile_coord[1] + v[1])
                    self.check_tile(coord_v)

            # iterate full floor
            for tile_coord in list(self.tiles.keys()):
                num_black_neighbours = 0

                for v in [(1, 1), (2, 0), (1, -1), (-1, 1), (-2, 0), (-1, -1)]:
                    coord_v = (tile_coord[0] + v[0], tile_coord[1] + v[1])
                    if self.check_tile(coord_v):
                        num_black_neighbours += 1

                if self.check_tile(tile_coord):
                    if num_black_neighbours == 0 or num_black_neighbours > 2:
                        tiles_to_flip.append(tile_coord)
                else:
                    if num_black_neighbours == 2:
                        tiles_to_flip.append(tile_coord)
            
            for tile_to_flip in tiles_to_flip:
                self.flip_tile(tile_to_flip)

            if (day + 1) % 10 == 0:
                print("Day {}: {}".format(day + 1, self.count_black_tiles()))

    def flip_tile(self, coord):
        self.tiles[coord] = not self.check_tile(coord)

    def check_tile(self, coord):
        return self.tiles.setdefault(coord, False)

    def count_black_tiles(self):
        num_tiles = len(self.tiles)
        num_black_tiles = sum([1 if tile else 0 for tile in self.tiles.values()])
        return num_black_tiles

def read_input(file):
    with open(file, "r") as fin:
        instrs = []
        for line in fin.readlines():
            instr = []
            instr_chars = list(line.strip())
            while len(instr_chars) > 0:
                c = instr_chars.pop(0)
                if c == "s" or c == "n":
                    c += instr_chars.pop(0)
                instr.append(c)
            instrs.append(instr)
        return instrs

def run(label, input_file):
    instrs = read_input(input_file)
    tile_floor = TileFloor(instrs)

    print("{} 1: {}".format(label, tile_floor.count_black_tiles()))

    tile_floor.cycle(100)
    print("{} 2: {}".format(label, tile_floor.count_black_tiles()))

#run("test", "day24-input-test")
run("part", "day24-input")