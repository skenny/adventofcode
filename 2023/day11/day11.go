package main

import (
	"fmt"
	"math"
	"strings"

	"github.com/skenny/adventofcode/2023/util"
)

const day int = 11

type Vertex struct {
	X int
	Y int
}

type VertexPair struct {
	Vertex1 Vertex
	Vertex2 Vertex
}

func main() {
	fmt.Printf("Day %v\n", day)
	input := util.ReadInput(day)
	part1(input)
	part2(input)
}

func part1(input []string) {
	grid := parseInput(input)
	fmt.Printf("Part 1: %v\n", findShortestDistances(grid, 2))
}

func part2(input []string) {
	grid := parseInput(input)
	fmt.Printf("Part 2: %v\n", findShortestDistances(grid, 1000000))
}

func findShortestDistances(grid [][]string, expansionAmount int) int {
	emptyRows, emptyCols := findEmptyRowsAndCols(grid)
	galaxies := findGalaxies(grid)
	galaxyPairs := findGalaxyPairs(galaxies)
	shortestDistances := util.MapSlice(galaxyPairs, func(galaxyPair VertexPair) int {
		xDistance := int(math.Abs(float64(galaxyPair.Vertex2.X - galaxyPair.Vertex1.X)))
		yDistance := int(math.Abs(float64(galaxyPair.Vertex2.Y - galaxyPair.Vertex1.Y)))

		// for each vertex pair, count the number of empty rows and cols between them, and add in the expansion distance factor for each dimension

		minX := int(math.Min(float64(galaxyPair.Vertex1.X), float64(galaxyPair.Vertex2.X)))
		maxX := int(math.Max(float64(galaxyPair.Vertex1.X), float64(galaxyPair.Vertex2.X)))
		xExpansionFactor := 0
		for _, x := range emptyCols {
			if x >= minX && x <= maxX {
				xExpansionFactor += 1
			}
		}

		minY := int(math.Min(float64(galaxyPair.Vertex1.Y), float64(galaxyPair.Vertex2.Y)))
		maxY := int(math.Max(float64(galaxyPair.Vertex1.Y), float64(galaxyPair.Vertex2.Y)))
		yExpansionFactor := 0
		for _, y := range emptyRows {
			if y >= minY && y <= maxY {
				yExpansionFactor += 1
			}
		}

		return xDistance + (xExpansionFactor * (expansionAmount - 1)) + yDistance + (yExpansionFactor * (expansionAmount - 1))
	})

	return util.SumInts(shortestDistances)
}

func findGalaxyPairs(galaxies []Vertex) []VertexPair {
	galaxyPairs := []VertexPair{}
	for i := 0; i < len(galaxies); i++ {
		for j := i + 1; j < len(galaxies); j++ {
			galaxyPairs = append(galaxyPairs, VertexPair{galaxies[i], galaxies[j]})
		}
	}
	return galaxyPairs
}

func findGalaxies(grid [][]string) []Vertex {
	galaxies := []Vertex{}
	for y, row := range grid {
		for x, cell := range row {
			if cell == "#" {
				galaxies = append(galaxies, Vertex{x, y})
			}
		}
	}
	return galaxies
}

func findEmptyRowsAndCols(grid [][]string) (rows []int, cols []int) {
	emptyRows := []int{}
	for y := 0; y < len(grid); y++ {
		if isRowEmpty(y, grid) {
			emptyRows = append(emptyRows, y)
		}
	}

	emptyCols := []int{}
	for x := 0; x < len(grid[0]); x++ {
		if isColEmpty(x, grid) {
			emptyCols = append(emptyCols, x)
		}
	}

	return emptyRows, emptyCols
}

func isRowEmpty(row int, grid [][]string) bool {
	rowIsEmpty := true
	for _, cell := range grid[row] {
		rowIsEmpty = rowIsEmpty && cell == "."
	}
	return rowIsEmpty
}

func isColEmpty(col int, grid [][]string) bool {
	colIsEmpty := true
	for _, row := range grid {
		colIsEmpty = colIsEmpty && row[col] == "."
	}
	return colIsEmpty
}

func parseInput(input []string) [][]string {
	grid := make([][]string, len(input))
	for y, line := range input {
		grid[y] = strings.Split(line, "")
	}
	return grid
}
