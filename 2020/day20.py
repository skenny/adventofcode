import math
from functools import reduce

class Tile:

    def __init__(self, id, rows):
        self.id = id
        self.rows = rows
        self.dimensions = len(rows)
        self.neighbours = set()

    def print(self):
        print("\n".join(self.rows))

    def is_corner(self):
        return len(self.neighbours) == 2

    def edges(self):
        return [self.top_edge(), self.right_edge(), self.bottom_edge(), self.left_edge()]

    def top_edge(self):
        return self.rows[0]

    def right_edge(self):
        return "".join([row[-1] for row in self.rows])

    def bottom_edge(self):
        return self.rows[-1]

    def left_edge(self):
        return "".join([row[0] for row in self.rows])

    def reverse_edge(self, edge):
        return edge[::-1]

    def test_fit(self, other_tile):
        other_edges = other_tile.edges()
        for edge in self.edges():
            if edge in other_edges or self.reverse_edge(edge) in other_edges:
                self.neighbours.add(other_tile)

    def find_neighbour_edges(self):
        attachable_neighbour_edges = []

        for neighbour in self.neighbours:
            neighbour_edges = neighbour.edges()

            right = self.right_edge()
            if right in neighbour_edges or self.reverse_edge(right) in neighbour_edges:
                attachable_neighbour_edges.append("right")

            left = self.left_edge()
            if left in neighbour_edges or self.reverse_edge(left) in neighbour_edges:
                attachable_neighbour_edges.append("left")

            top = self.top_edge()
            if top in neighbour_edges or self.reverse_edge(top) in neighbour_edges:
                attachable_neighbour_edges.append("top")

            bottom = self.bottom_edge()
            if bottom in neighbour_edges or self.reverse_edge(bottom) in neighbour_edges:
                attachable_neighbour_edges.append("bottom")

        return attachable_neighbour_edges

    def flip_horizontal(self):
        self.rows = [self.reverse_edge(row) for row in self.rows]

    def flip_vertical(self):
        self.rows = list(reversed(self.rows))

    def rotate(self, n):
        for i in range(n):
            new_rows = []
            for i in range(self.dimensions):
                row = ""
                for j in reversed(range(self.dimensions)):
                    row += self.rows[j][i]
                new_rows.append(row)
            self.rows = new_rows

    def remove_borders(self):
        result = []
        for row in self.rows[1:len(self.rows) - 1]:
            result.append(row[1:len(row) - 1])
        return result

    def set_pixel(self, y, x, v):
        row = list(self.rows[y])
        row[x] = v
        self.rows[y] = "".join(row)

def read_input(file):
    with open(file, "r") as fin:
        lines = [l.strip() for l in fin.readlines()]
        tile_id = None
        tile_rows = None
        tiles = []
        for line in lines:
            if len(line) == 0:
                continue
            if line.startswith("Tile "):
                if tile_id != None:
                    tiles.append(Tile(tile_id, tile_rows))
                tile_id = int(line[5:-1])
                tile_rows = []
                continue
            tile_rows.append(line)
        tiles.append(Tile(tile_id, tile_rows))
        return tiles

def test_fit_tiles(tiles):
    for target_tile in tiles:
        for test_tile in tiles:
            if not target_tile.id == test_tile.id:
                target_tile.test_fit(test_tile)

def find_corners(tiles):
    return list(filter(lambda tile: tile.is_corner(), tiles))

def arrange_tiles(tiles):
    dimensions = int(math.sqrt(len(tiles)))
    unplaced_tile_ids = [tile.id for tile in tiles]

    image = []
    for i in range(dimensions):
        image.append([None] * dimensions)

    # select a cornerstone and orient it so that it's the top left
    cornerstone = find_corners(tiles)[0]
    while True:
        neighbour_edges = cornerstone.find_neighbour_edges()
        if "right" in neighbour_edges and "bottom" in neighbour_edges:
            break
        if "right" in neighbour_edges and "top" in neighbour_edges:
            cornerstone.flip_vertical()
            break
        cornerstone.rotate(1)

    # place the cornerstone
    image[0][0] = cornerstone
    unplaced_tile_ids.remove(cornerstone.id)

    for y in range(0, dimensions):
        for x in range(0, dimensions):
            # skip the cornerstone
            if y == 0 and x == 0:
                continue

            prev_tile = image[y - 1][x] if x == 0 else image[y][x - 1]
            attaching_right = x != 0
            target_edge = prev_tile.right_edge() if attaching_right else prev_tile.bottom_edge()
            matching_tile = None

            for neighbour_tile in prev_tile.neighbours:
                if neighbour_tile.id not in unplaced_tile_ids:
                    continue

                if target_edge == neighbour_tile.top_edge():
                    if attaching_right:
                        neighbour_tile.flip_horizontal()
                        neighbour_tile.rotate(3)
                    matching_tile = neighbour_tile
                    break

                if target_edge == neighbour_tile.reverse_edge(neighbour_tile.top_edge()):
                    if attaching_right:
                        neighbour_tile.rotate(3)
                    else:
                        neighbour_tile.flip_horizontal()
                    matching_tile = neighbour_tile
                    break

                if target_edge == neighbour_tile.right_edge():
                    if attaching_right:
                        neighbour_tile.flip_horizontal()
                    else:
                        neighbour_tile.rotate(3)
                    matching_tile = neighbour_tile
                    break

                if target_edge == neighbour_tile.reverse_edge(neighbour_tile.right_edge()):
                    if attaching_right:
                        neighbour_tile.flip_vertical()
                        neighbour_tile.flip_horizontal()
                    else:
                        neighbour_tile.flip_vertical()
                        neighbour_tile.rotate(3)
                    matching_tile = neighbour_tile
                    break

                if target_edge == neighbour_tile.bottom_edge():
                    if attaching_right:
                        neighbour_tile.rotate(1)
                    else:
                        neighbour_tile.flip_vertical()
                    matching_tile = neighbour_tile
                    break

                if target_edge == neighbour_tile.reverse_edge(neighbour_tile.bottom_edge()):
                    if attaching_right:
                        neighbour_tile.rotate(1)
                        neighbour_tile.flip_vertical()
                    else:
                        neighbour_tile.flip_vertical()
                        neighbour_tile.flip_horizontal()
                    matching_tile = neighbour_tile
                    break

                if target_edge == neighbour_tile.left_edge():
                    if not attaching_right:
                        neighbour_tile.flip_vertical()
                        neighbour_tile.rotate(1)
                    matching_tile = neighbour_tile
                    break

                if target_edge == neighbour_tile.reverse_edge(neighbour_tile.left_edge()):
                    if attaching_right:
                        neighbour_tile.flip_vertical()
                    else:
                        neighbour_tile.rotate(1)
                    matching_tile = neighbour_tile
                    break

            image[y][x] = matching_tile
            unplaced_tile_ids.remove(matching_tile.id)
    
    return image

def rasterize(image):
    dimensions = len(image)

    image_without_borders = []
    for i in range(dimensions):
        image_without_borders.append([None] * dimensions)

    for y, row in enumerate(image):
        for x, tile in enumerate(row):
            image_without_borders[y][x] = tile.remove_borders()

    tile_dimensions = len(image_without_borders[0][0])

    raster_lines = []
    for row in image_without_borders:
        for i in range(0, tile_dimensions):
            raster_line = ""
            for tile in row:
                raster_line += tile[i]
            raster_lines.append(raster_line)

    return Tile("raster", raster_lines)

def search_for_sea_monsters(image):
    '''''''''''''''''''''''
    0                   # 
    1 #    ##    ##    ###
    2  #  #  #  #  #  #   
      01234567890123456789
    '''''''''''''''''''''''
    monster_mask = [
        (0, 18),
        (1, 0), (1, 5), (1, 6), (1, 11), (1, 12), (1, 17), (1, 18), (1, 19),
        (2, 1), (2, 4), (2, 7), (2, 10), (2, 13), (2, 16)
    ]

    raster_tile = rasterize(image)

    y_max = len(raster_tile.rows) - 2
    x_max = len(raster_tile.rows[0]) - 20

    rotations = 0
    flipped = False

    monster_coords = []

    print("Searching for sea monsters...")

    while True:
        for y in range(y_max):
            for x in range(x_max):
                sea_monsters_spotted = True
                for yo, xo in monster_mask:
                    if raster_tile.rows[y + yo][x + xo] == "#":
                        continue
                    sea_monsters_spotted = False
                    break
                if sea_monsters_spotted:
                    print("Sea monster spotted at ({}, {})!".format(y, x))
                    monster_coords.append((y, x))

        if len(monster_coords) > 0:
            break

        if rotations % 4 == 0:
            if not flipped:
                raster_tile.flip_horizontal()
            else:
                break

        raster_tile.rotate(1)
        rotations += 1

    num_sea_monsters_spotted = len(monster_coords)
    reveal_sea_monsters(raster_tile, monster_coords, monster_mask)

    print("Spotted {} sea monsters!!!".format(num_sea_monsters_spotted))
    raster_tile.print()

    water_roughness = sum([row.count("#") for row in raster_tile.rows])
    return water_roughness

def reveal_sea_monsters(tile, monster_coords, monster_mask):
    for y, x in monster_coords:
        for yo, xo in monster_mask:
            tile.set_pixel(y + yo, x + xo, "O")

def run(label, input_file):
    tiles = read_input(input_file)
    test_fit_tiles(tiles)

    print("{} 1: {}".format(label, reduce(lambda total, tile: total * tile.id, find_corners(tiles), 1)))
    
    image = arrange_tiles(tiles)
    water_roughness = search_for_sea_monsters(image)

    print("{} 2: {}".format(label, water_roughness))

run("test", "day20-input-test")
run("part", "day20-input")
