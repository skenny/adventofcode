package main

import (
	"fmt"
	"strings"

	"github.com/skenny/adventofcode/2023/util"
)

const day int = 13

type Pattern struct {
	Rows []string
	Cols []string
}

func (p Pattern) rasterize() {
	for _, row := range p.Rows {
		fmt.Println(row)
	}
}

func main() {
	fmt.Printf("Day %v\n", day)
	input := util.ReadTestInput(day)
	part1(input)
	part2(input)
}

func part1(input []string) {
	patterns := parseInput(input)
	for _, pattern := range patterns {
		pattern.rasterize()
	}
}

func part2(input []string) {
}

func rowsToCols(rows []string) []string {
	cols := []string{}
	for col := 0; col < len(rows[0]); col++ {
		column := make([]string, len(rows))
		for row := 0; row < len(rows); row++ {
			column[row] = string(rows[row][col])
		}
		cols = append(cols, strings.Join(column, ""))
	}
	return cols
}

func parseInput(input []string) []Pattern {
	patterns := []Pattern{}
	patternRows := []string{}
	for _, line := range input {
		if len(line) == 0 {
			patterns = append(patterns, Pattern{patternRows, rowsToCols(patternRows)})
			patternRows = []string{}
			continue
		}
		patternRows = append(patternRows, line)
	}
	patterns = append(patterns, Pattern{patternRows, rowsToCols(patternRows)})
	return patterns
}
