package main

import (
	"fmt"
	"slices"
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
	fmt.Printf("Part 1: %v\n", calculateTotalLoad(fullTilt(columns)))
}

func part2(input []string) {
	columns := parseColumns(input)
	cycles := 1_000_000_000
	cycle := 0
	cache := make(map[string]int)
	jumped := false
	for cycle < cycles {
		for rotations := 0; rotations < 4; rotations++ {
			columns = rotateClockwise(fullTilt(columns))
		}
		cycle += 1
		cacheKey := strings.Join(columns, "")
		seenAtCycle, seen := cache[cacheKey]
		if seen && !jumped {
			period := cycle - seenAtCycle
			cycle = cycles - ((cycles - seenAtCycle) % period)
			jumped = true
		}
		cache[cacheKey] = cycle
	}
	fmt.Printf("Part 2: %v\n", calculateTotalLoad(columns))
}

func rotateClockwise(columns []string) []string {
	newRows := []string{}
	for _, column := range columns {
		split := strings.Split(column, "")
		slices.Reverse(split)
		newRows = append(newRows, strings.Join(split, ""))
	}
	return parseColumns(newRows)
}

func calculateTotalLoad(columns []string) int {
	return util.SumInts(util.MapSlice(columns, calculateColumnLoad))
}

func calculateColumnLoad(column string) int {
	rowCount := len(column)
	load := 0
	for i, c := range column {
		if c == 'O' {
			load += rowCount - i
		}
	}
	return load
}

func fullTilt(columns []string) []string {
	return util.MapSlice(columns, tilt)
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
