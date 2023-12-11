package main

import (
	"fmt"
	"slices"
	"strings"

	"github.com/skenny/adventofcode/2023/util"
)

const day int = 11

func main() {
	fmt.Printf("Day %v\n", day)
	input := util.ReadTestInput(day)
	part1(input)
	part2(input)
}

func part1(input []string) {
	grid := parseInput(input)
	expanded := expand(grid)

}

func part2(input []string) {
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
