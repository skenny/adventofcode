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
		nextNumber := nextNumber(vals)
		//fmt.Printf("next in %v is %v\n", vals, nextNumber)
		sum += nextNumber
	}
	fmt.Printf("Part 1: %v\n", sum)
}

func part2(input []string) {
}

func nextNumber(vals []int) int {
	allZero := true
	for _, v := range vals {
		allZero = allZero && v == 0
	}
	if allZero {
		return 0
	}
	return vals[len(vals)-1] + nextNumber(diffs(vals))
}

func diffs(vals []int) []int {
	count := len(vals)
	diffs := make([]int, count-1)
	for i := 1; i < count; i++ {
		diffs[i-1] = vals[i] - vals[i-1]
	}
	//fmt.Printf("diffs of %v are %v\n", vals, diffs)
	return diffs
}
