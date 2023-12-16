package main

import (
	"fmt"

	"github.com/skenny/adventofcode/2023/util"
	"golang.org/x/exp/maps"
)

const day int = 16

type Point struct {
	X int
	Y int
}

func (p Point) InBounds(w, h int) bool {
	return p.X >= 0 && p.X < w && p.Y >= 0 && p.Y < h
}

func (p Point) Advance(vector int) Point {
	vectorDirection := Vectors[vector]
	return Point{p.X + vectorDirection.X, p.Y + vectorDirection.Y}
}

type Beam struct {
	Direction int
	Position  Point
}

const (
	NORTH = 0
	EAST  = 1
	SOUTH = 2
	WEST  = 3
)

var Vectors = map[int]Point{
	NORTH: {0, -1},
	EAST:  {1, 0},
	SOUTH: {0, 1},
	WEST:  {-1, 0},
}

var Mirrors = []rune{'|', '-', '/', '\\'}

func main() {
	fmt.Printf("Day %v\n", day)
	input := util.ReadInput(day)
	part1(input)
	part2(input)
}

func part1(input []string) {
	grid := parseInput(input)
	fmt.Printf("Part 1: %v\n", beamMeUp(Beam{EAST, Point{-1, 0}}, grid))
}

func part2(input []string) {
	grid := parseInput(input)
	best := 0
	for x := 0; x < len(grid[0]); x++ {
		south := beamMeUp(Beam{SOUTH, Point{x, -1}}, grid)
		if south > best {
			best = south
		}
		north := beamMeUp(Beam{NORTH, Point{x, len(grid)}}, grid)
		if north > best {
			best = north
		}
	}
	for y := 0; y < len(grid); y++ {
		east := beamMeUp(Beam{EAST, Point{-1, y}}, grid)
		if east > best {
			best = east
		}
		west := beamMeUp(Beam{WEST, Point{len(grid[0]), y}}, grid)
		if west > best {
			best = west
		}
	}
	fmt.Printf("Part 2: %v\n", best)
}

func beamMeUp(start Beam, grid [][]rune) int {
	height, width := len(grid), len(grid[0])
	energized := map[Point]bool{}
	seenStates := map[Beam]bool{}
	beams := []Beam{start}

	for {
		if len(beams) == 0 {
			break
		}

		newBeams := []Beam{}

		for _, beam := range beams {
			_, seen := seenStates[beam]
			if seen {
				continue
			}
			seenStates[beam] = true

			if beam.Position.InBounds(width, height) {
				energized[beam.Position] = true
			}

			movesInto := beam.Position.Advance(beam.Direction)
			if movesInto.InBounds(width, height) {
				switch grid[movesInto.Y][movesInto.X] {
				case '.':
					newBeams = append(newBeams, Beam{beam.Direction, movesInto})
				case '|':
					if beam.Direction == EAST || beam.Direction == WEST {
						newBeams = append(newBeams, Beam{NORTH, movesInto})
						newBeams = append(newBeams, Beam{SOUTH, movesInto})
					} else {
						newBeams = append(newBeams, Beam{beam.Direction, movesInto})
					}
				case '-':
					if beam.Direction == NORTH || beam.Direction == SOUTH {
						newBeams = append(newBeams, Beam{EAST, movesInto})
						newBeams = append(newBeams, Beam{WEST, movesInto})
					} else {
						newBeams = append(newBeams, Beam{beam.Direction, movesInto})
					}
				case '/':
					if beam.Direction == NORTH {
						newBeams = append(newBeams, Beam{EAST, movesInto})
					} else if beam.Direction == EAST {
						newBeams = append(newBeams, Beam{NORTH, movesInto})
					} else if beam.Direction == SOUTH {
						newBeams = append(newBeams, Beam{WEST, movesInto})
					} else if beam.Direction == WEST {
						newBeams = append(newBeams, Beam{SOUTH, movesInto})
					}
				case '\\':
					if beam.Direction == NORTH {
						newBeams = append(newBeams, Beam{WEST, movesInto})
					} else if beam.Direction == EAST {
						newBeams = append(newBeams, Beam{SOUTH, movesInto})
					} else if beam.Direction == SOUTH {
						newBeams = append(newBeams, Beam{EAST, movesInto})
					} else if beam.Direction == WEST {
						newBeams = append(newBeams, Beam{NORTH, movesInto})
					}
				}
			}
		}

		beams = newBeams
	}

	return len(maps.Keys(energized))
}

func parseInput(input []string) [][]rune {
	grid := make([][]rune, len(input))
	for i, line := range input {
		grid[i] = []rune(line)
	}
	return grid
}
