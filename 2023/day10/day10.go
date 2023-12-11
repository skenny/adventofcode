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

var Pipes = []string{"|", "-", "L", "J", "7", "F"}

var PipeConnections = map[string][]bool{
	//     N      E      S      W
	"|": {true, false, true, false},
	"-": {false, true, false, true},
	"L": {true, true, false, false},
	"J": {true, false, false, true},
	"7": {false, false, true, true},
	"F": {false, true, true, false},
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
}

func (t Tile) IsPipe() bool {
	return slices.Contains(Pipes, t.Type)
}

func (f Field) TileAt(v Vertex) Tile {
	tile, ok := f.Tiles[v]
	if !ok {
		return Tile{v, "."}
	}
	return tile
}

func main() {
	fmt.Printf("Day %v\n", day)
	input := util.ReadInput(day)
	part1(input)
	part2(input)
}

func part1(input []string) {
	field, startVertex := parseInput(input)
	fmt.Printf("Part 1: %v", walk(field, startVertex))
}

func part2(input []string) {
}

func walk(field Field, startVertex Vertex) int {
	dists := make(map[Vertex]int)
	dists[startVertex] = 0

	neighbours := connectedNeighbours(field, startVertex)
	dist := 0

	for {
		if len(neighbours) == 0 {
			break
		}
		dist += 1
		newNeighbours := []Tile{}
		for _, neighbour := range neighbours {
			_, ok := dists[neighbour.Vertex]
			if !ok {
				dists[neighbour.Vertex] = dist
				newNeighbours = append(newNeighbours, connectedNeighbours(field, neighbour.Vertex)...)
			}
		}
		neighbours = newNeighbours
	}

	return slices.Max(maps.Values(dists))
}

func connectedNeighbours(field Field, vertex Vertex) []Tile {
	north := field.TileAt(Vertex{vertex.X, vertex.Y - 1})
	east := field.TileAt(Vertex{vertex.X + 1, vertex.Y})
	south := field.TileAt(Vertex{vertex.X, vertex.Y + 1})
	west := field.TileAt(Vertex{vertex.X - 1, vertex.Y})

	connectedTiles := []Tile{}
	if north.IsPipe() && PipeConnections[north.Type][SOUTH] {
		connectedTiles = append(connectedTiles, north)
	}
	if east.IsPipe() && PipeConnections[east.Type][WEST] {
		connectedTiles = append(connectedTiles, east)
	}
	if south.IsPipe() && PipeConnections[south.Type][NORTH] {
		connectedTiles = append(connectedTiles, south)
	}
	if west.IsPipe() && PipeConnections[west.Type][EAST] {
		connectedTiles = append(connectedTiles, west)
	}
	return connectedTiles
}

func parseInput(input []string) (Field, Vertex) {
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
	return Field{tileMap, len(input[0]), len(input)}, startVertex
}
