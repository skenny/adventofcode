package main

import (
	"fmt"
	"strings"
	"unicode/utf8"

	"github.com/skenny/adventofcode/2023/util"
)

const day int = 14

func main() {
	fmt.Printf("Day %v\n", day)
	input := util.ReadTestInput(day)
	part1(input)
	part2(input)
}

func part1(input []string) {
	columns := parseColumns(input)
	fmt.Printf("Part 1: %v\n", util.SumInts(util.MapSlice(columns, func(column string) int { return calculateLoad(tilt(column)) })))
}

func part2(input []string) {
	columns := parseColumns(input)
	for i := 0; i < 1_000_000_000; i++ {
		debug := i%100_000 == 0
		if debug {
			fmt.Printf("pass %v\n", i)
		}
		for j := 0; j < 4; j++ {
			columns = rotateCounterclockwise(util.MapSlice(columns, func(column string) string { return tilt(column) }))
		}
	}
	fmt.Printf("Part 2: %v\n", util.SumInts(util.MapSlice(columns, func(column string) int { return calculateLoad(column) })))
}

func rotateCounterclockwise(columns []string) []string {
	return util.MapSlice(columns, rotate)
}

func rotate(column string) string {
	size := len(column)
	buf := make([]byte, size)
	for start := 0; start < size; {
		r, n := utf8.DecodeRuneInString(column[start:])
		start += n
		utf8.EncodeRune(buf[size-start:], r)
	}
	return string(buf)
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
