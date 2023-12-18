package main

import (
	"fmt"
	"slices"
	"strings"

	"github.com/skenny/adventofcode/2023/util"
	"golang.org/x/exp/maps"
)

const day int = 10

const NORTH = 0
const EAST = 1
const SOUTH = 2
const WEST = 3

var Vectors = []Vertex{{0, -1}, {1, 0}, {0, 1}, {-1, 0}}

var Pipes = map[string]string{
	"|": "|",
	"-": "-",
	"L": "└",
	"J": "┘",
	"7": "┐",
	"F": "┌",
}

var PipeConnections = map[string][]bool{
	//     N      E      S      W
	"|": {true, false, true, false},
	"-": {false, true, false, true},
	"L": {true, true, false, false},
	"J": {true, false, false, true},
	"7": {false, false, true, true},
	"F": {false, true, true, false},
	"S": {true, true, true, true},
}

type Vertex struct {
	X int
	Y int
}

type Tile struct {
	Vertex Vertex
	Type   string
}

type Field struct {
	Tiles  map[Vertex]Tile
	Width  int
	Height int
	Start  Tile
}

func (vertex Vertex) Shift(vector Vertex) Vertex {
	return Vertex{vertex.X + vector.X, vertex.Y + vector.Y}
}

func (tile Tile) IsPipe() bool {
	_, yep := Pipes[tile.Type]
	return yep
}

func (field Field) TileAt(v Vertex) Tile {
	tile, ok := field.Tiles[v]
	if !ok {
		return Tile{v, ""}
	}
	return tile
}

func (field Field) ConnectedNeighbours(tile Tile) []Tile {
	connectedTiles := []Tile{}

	vertex := tile.Vertex
	connectedDirections := PipeConnections[tile.Type]

	if connectedDirections[NORTH] {
		north := field.TileAt(Vertex{vertex.X, vertex.Y - 1})
		if north.IsPipe() && PipeConnections[north.Type][SOUTH] {
			connectedTiles = append(connectedTiles, north)
		}
	}

	if connectedDirections[EAST] {
		east := field.TileAt(Vertex{vertex.X + 1, vertex.Y})
		if east.IsPipe() && PipeConnections[east.Type][WEST] {
			connectedTiles = append(connectedTiles, east)
		}
	}

	if connectedDirections[SOUTH] {
		south := field.TileAt(Vertex{vertex.X, vertex.Y + 1})
		if south.IsPipe() && PipeConnections[south.Type][NORTH] {
			connectedTiles = append(connectedTiles, south)
		}
	}

	if connectedDirections[WEST] {
		west := field.TileAt(Vertex{vertex.X - 1, vertex.Y})
		if west.IsPipe() && PipeConnections[west.Type][EAST] {
			connectedTiles = append(connectedTiles, west)
		}
	}

	return connectedTiles
}

func (field Field) Rasterize() {
	for y := 0; y < field.Height; y++ {
		for x := 0; x < field.Width; x++ {
			tile := field.TileAt(Vertex{x, y})
			out := tile.Type
			glyph, ok := Pipes[out]
			if ok {
				out = glyph
			}
			fmt.Print(out)
		}
		fmt.Println()
	}
}

func (field Field) Walk() map[Vertex]int {
	visited := map[Vertex]int{
		field.Start.Vertex: 0,
	}
	neighbours := field.ConnectedNeighbours(field.Start)
	steps := 0
	for {
		if len(neighbours) == 0 {
			break
		}
		steps += 1
		newNeighbours := []Tile{}
		for _, neighbour := range neighbours {
			_, alreadyVisited := visited[neighbour.Vertex]
			if !alreadyVisited {
				visited[neighbour.Vertex] = steps
				newNeighbours = append(newNeighbours, field.ConnectedNeighbours(neighbour)...)
			}
		}
		neighbours = newNeighbours
	}
	return visited
}

func (field Field) Flood() int {
	visited := field.Walk()

	// prune off unreachable pipes
	for y := 0; y < field.Height; y++ {
		for x := 0; x < field.Width; x++ {
			v := Vertex{x, y}
			_, reachable := visited[v]
			if !reachable {
				field.Tiles[v] = Tile{v, "."}
			}
		}
	}

	inside := 0
	for y := 0; y < field.Height; y++ {
		edges := 0
		for x := 0; x < field.Width; x++ {
			v := Vertex{x, y}
			tile := field.Tiles[v].Type
			if tile == "F" || tile == "|" || tile == "7" {
				edges += 1
			} else if tile == "." {
				if edges%2 == 1 {
					inside += 1
				}
			}
		}
	}

	return inside
}

func main() {
	fmt.Printf("Day %v\n", day)
	input := util.ReadInput(day)
	part1(input)
	part2(input)
}

func part1(input []string) {
	field := parseInput(input)
	visited := field.Walk()
	mostStepsAway := slices.Max(maps.Values(visited))
	fmt.Printf("Part 1: %v\n", mostStepsAway)
}

func part2(input []string) {
	field := parseInput(input)
	fmt.Printf("Part 2: %v\n", field.Flood())
}

func parseInput(input []string) Field {
	tileMap := make(map[Vertex]Tile)
	startVertex := Vertex{0, 0}
	for y, line := range input {
		for x, tile := range strings.Split(line, "") {
			vertex := Vertex{x, y}
			if tile == "S" {
				startVertex = vertex
			}
			tileMap[vertex] = Tile{vertex, tile}
		}
	}
	return Field{tileMap, len(input[0]), len(input), tileMap[startVertex]}
}
