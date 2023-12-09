package main

import (
	"fmt"
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
	sum := 0
	for _, line := range input {
		vals := util.MapSlice(strings.Fields(line), util.MustAtoi)
		sum += nextNumber(vals)
	}
	fmt.Printf("Part 1: %v\n", sum)
}

func part2(input []string) {
	sum := 0
	for _, line := range input {
		vals := util.MapSlice(strings.Fields(line), util.MustAtoi)
		sum += prevNumber(vals)
	}
	fmt.Printf("Part 2: %v\n", sum)
}

func nextNumber(vals []int) int {
	if allZero(vals) {
		return 0
	}
	return vals[len(vals)-1] + nextNumber(diffs(vals))
}

func prevNumber(vals []int) int {
	if allZero(vals) {
		return 0
	}
	return vals[0] - prevNumber(diffs(vals))
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
