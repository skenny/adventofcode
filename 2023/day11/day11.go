package main

import (
	"fmt"
	"strings"

	"github.com/skenny/adventofcode/2023/util"
)

const day int = 11

type Vertex struct {
	X int
	Y int
}

func main() {
	fmt.Printf("Day %v\n", day)
	grid := parseInput(util.ReadInput(day))
	fmt.Printf("Part 1: %v\n", solveTheUniverse(grid, 2))
	fmt.Printf("Part 2: %v\n", solveTheUniverse(grid, 1000000))
}

func solveTheUniverse(grid [][]string, expandBy int) int {
	emptyRows := []int{}
	emptyCols := []int{}
	galaxies := []Vertex{}
	for y, row := range grid {
		if rowEmpty(y, grid) {
			emptyRows = append(emptyRows, y)
		}
		for x, cell := range row {
			if cell == "#" {
				galaxies = append(galaxies, Vertex{x, y})
			}
			if y == 0 && colEmpty(x, grid) {
				emptyCols = append(emptyCols, x)
			}
		}
	}

	distances := []int{}
	for i := 0; i < len(galaxies); i++ {
		for j := i + 1; j < len(galaxies); j++ {
			galaxy1, galaxy2 := galaxies[i], galaxies[j]
			manhattanDistance := abs(galaxy2.X-galaxy1.X) + abs(galaxy2.Y-galaxy1.Y)
			xExpansion := countInRange(emptyCols, min(galaxy1.X, galaxy2.X), max(galaxy1.X, galaxy2.X))
			yExpansion := countInRange(emptyRows, min(galaxy1.Y, galaxy2.Y), max(galaxy1.Y, galaxy2.Y))
			distances = append(distances, manhattanDistance+(xExpansion*(expandBy-1))+(yExpansion*(expandBy-1)))
		}
	}

	return util.SumInts(distances)
}

func rowEmpty(row int, grid [][]string) bool {
	for _, cell := range grid[row] {
		if cell != "." {
			return false
		}
	}
	return true
}

func colEmpty(col int, grid [][]string) bool {
	for _, row := range grid {
		if row[col] != "." {
			return false
		}
	}
	return true
}

func countInRange(vals []int, min, max int) int {
	count := 0
	for _, v := range vals {
		if v >= min && v <= max {
			count += 1
		}
	}
	return count
}

func abs(v int) int {
	if v < 0 {
		return -v
	}
	return v
}

func min(v1, v2 int) int {
	if v1 < v2 {
		return v1
	}
	return v2
}

func max(v1, v2 int) int {
	if v1 > v2 {
		return v1
	}
	return v2
}

func parseInput(input []string) [][]string {
	grid := make([][]string, len(input))
	for y, line := range input {
		grid[y] = strings.Split(line, "")
	}
	return grid
}
