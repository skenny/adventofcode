package main

import (
	"fmt"
	"math"
	"slices"
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
	expanded := expand(grid)
	galaxies := findGalaxies(expanded)
	galaxyPairs := findGalaxyPairs(galaxies)
	shortestDistances := util.MapSlice(galaxyPairs, func(galaxyPair VertexPair) int {
		xDistance := int(math.Abs(float64(galaxyPair.Vertex2.X - galaxyPair.Vertex1.X)))
		yDistance := int(math.Abs(float64(galaxyPair.Vertex2.Y - galaxyPair.Vertex1.Y)))
		return xDistance + yDistance
	})
	fmt.Printf("Part 1: %v", util.SumInts(shortestDistances))
}

func part2(input []string) {
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

func expand(grid [][]string) [][]string {
	emptyCols := []int{}
	for x := 0; x < len(grid[0]); x++ {
		if isColEmpty(x, grid) {
			emptyCols = append(emptyCols, x)
		}
	}

	expanded := [][]string{}
	for y, row := range grid {
		newRow := []string{}
		for x, cell := range row {
			newRow = append(newRow, cell)
			if slices.Contains(emptyCols, x) {
				newRow = append(newRow, cell)
			}
		}

		expanded = append(expanded, newRow)
		if isRowEmpty(y, grid) {
			expanded = append(expanded, newRow)
		}
	}

	return expanded
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

func rasterize(grid [][]string) {
	for _, row := range grid {
		fmt.Println(strings.Join(row, ""))
	}
}

func parseInput(input []string) [][]string {
	grid := make([][]string, len(input))
	for y, line := range input {
		grid[y] = strings.Split(line, "")
	}
	return grid
}
