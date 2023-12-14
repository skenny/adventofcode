package main

import (
	"fmt"
	"strings"

	"github.com/skenny/adventofcode/2023/util"
)

const day int = 14

func main() {
	fmt.Printf("Day %v\n", day)
	input := util.ReadInput(day)
	part1(input)
	part2(input)
}

func part1(input []string) {
	columns := parseColumns(input)
	fmt.Printf("Part 1: %v\n", util.SumInts(util.MapSlice(columns, func(column string) int { return calculateLoad(tilt(column)) })))
}

func part2(input []string) {
}

func calculateLoad(column string) int {
	rowCount := len(column)
	load := 0
	for i, c := range column {
		if c == 'O' {
			load += rowCount - i
		}
	}
	return load
}

func tilt(column string) string {
	columnArr := strings.Split(column, "")
	for {
		swaps := 0
		for i := 1; i < len(columnArr); i++ {
			left, right := columnArr[i-1], columnArr[i]
			if left == "." && right == "O" {
				swaps += 1
				columnArr[i-1] = right
				columnArr[i] = left
			}
		}
		if swaps == 0 {
			break
		}
	}
	return strings.Join(columnArr, "")
}

func parseColumns(input []string) []string {
	columns := make([]string, len(input))
	for col := 0; col < len(input[0]); col++ {
		column := make([]string, len(input))
		for row, line := range input {
			column[row] = string(line[col])
		}
		columns[col] = strings.Join(column, "")
	}
	return columns
}
