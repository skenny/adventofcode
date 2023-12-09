package main

import (
	"fmt"
	"slices"
	"strings"

	"github.com/skenny/adventofcode/2023/util"
)

const day int = 9

func main() {
	fmt.Printf("Day %v\n", day)
	input := util.ReadInput(day)
	part1(input)
	part2(input)
}

func part1(input []string) {
	fmt.Printf("Part 1: %v\n", sumNewNumbers(input, false))
}

func part2(input []string) {
	fmt.Printf("Part 2: %v\n", sumNewNumbers(input, true))
}

func sumNewNumbers(input []string, part2 bool) int {
	sum := 0
	for _, line := range input {
		vals := util.MapSlice(strings.Fields(line), util.MustAtoi)
		if part2 {
			slices.Reverse(vals)
		}
		sum += nextNumber(vals)
	}
	return sum
}

func nextNumber(vals []int) int {
	if allZero(vals) {
		return 0
	}
	return vals[len(vals)-1] + nextNumber(diffs(vals))
}

func allZero(vals []int) bool {
	return util.AllMatch(vals, func(v int) bool {
		return v == 0
	})
}

func diffs(vals []int) []int {
	count := len(vals)
	diffs := make([]int, count-1)
	for i := 1; i < count; i++ {
		diffs[i-1] = vals[i] - vals[i-1]
	}
	return diffs
}
