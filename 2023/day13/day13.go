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
	lefts := 0
	aboves := 0
	for i, pattern := range patterns {
		//pattern.rasterize()
		h1, h2 := findMirror(pattern.Rows)
		hmf := h1 != -1 && h2 != -1
		if hmf {
			//fmt.Printf("Horizontal mirror between %v, %v\n", h1+1, h2+1)
			aboves += h1 + 1
		}
		v1, v2 := findMirror(pattern.Cols)
		vmf := v1 != -1 && v2 != -1
		if vmf {
			//fmt.Printf("Vertical mirror between %v, %v\n", v1+1, v2+1)
			lefts += v1 + 1
		}
		if !hmf && !vmf {
			panic(fmt.Sprintf("no mirror found in pattern %v", i))
		}
	}
	fmt.Printf("Part 1: %v\n", lefts+(aboves*100))
}

func part2(input []string) {
}

func findMirror(lines []string) (int, int) {
	for i := 0; i < len(lines)-1; i++ {
		left := lines[i]
		right := lines[i+1]
		if left == right {
			for x := 1; x < len(lines); x++ {
				lx := i - x
				lr := i + 1 + x
				if lx >= 0 && lr < len(lines) {
					left = lines[lx]
					right = lines[lr]
					if left != right {
						// no match, not the mirror line
						break
					}
				} else {
					// out of bounds... must be the mirror line
					return i, i + 1
				}
			}
		}
	}
	return -1, -1
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
