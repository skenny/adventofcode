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
	input := util.ReadInput(day)
	part1(input)
	part2(input)
}

func part1(input []string) {
	patterns := parseInput(input)
	fmt.Printf("Part 1: %v\n", summarize(patterns, 0))
}

func part2(input []string) {
	patterns := parseInput(input)
	fmt.Printf("Part 2: %v\n", summarize(patterns, 1))
}

func summarize(patterns []Pattern, expectedSmudge int) int {
	cols := 0
	rows := 0
	for i, pattern := range patterns {
		//pattern.rasterize()
		ih, foundHorizontal := findMirror(pattern.Rows, expectedSmudge)
		if foundHorizontal {
			rows += ih + 1
		} else {
			iv, foundVertical := findMirror(pattern.Cols, expectedSmudge)
			if foundVertical {
				cols += iv + 1
			} else {
				panic(fmt.Sprintf("no mirror found in pattern %v", i))
			}
		}
	}
	return cols + (rows * 100)
}

func findMirror(lines []string, expectedSmudge int) (int, bool) {
	for i := 0; i < len(lines)-1; i++ {
		left := lines[i]
		right := lines[i+1]
		smudge := difference(left, right)
		if smudge <= expectedSmudge {
			for x := 1; x < len(lines); x++ {
				lx := i - x
				lr := i + 1 + x
				if lx >= 0 && lr < len(lines) {
					left = lines[lx]
					right = lines[lr]
					smudge += difference(left, right)
					if smudge > expectedSmudge {
						// no match, not the mirror line
						break
					}
				} else if smudge == expectedSmudge {
					// out of bounds... must be the mirror line
					return i, true
				}
			}
		}
	}
	return -1, false
}

func difference(s1, s2 string) int {
	difference := 0
	for i := 0; i < len(s1); i++ {
		if s1[i] != s2[i] {
			difference += 1
		}
	}
	return difference
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
