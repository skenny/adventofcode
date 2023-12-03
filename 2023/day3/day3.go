package main

import (
	"fmt"
	"strconv"
	"strings"
	"unicode"

	"github.com/skenny/adventofcode/2023/util"
)

const day int = 3

type Point struct {
	X int
	Y int
}

func main() {
	fmt.Printf("Day %v\n", day)
	input := util.ReadInput(day)
	part1(input)
	part2(input)
}

func part1(input []string) {
	// find all of the symbols
	symbols := make(map[Point]bool)
	for y, row := range input {
		for x, ch := range row {
			if !unicode.IsNumber(ch) && ch != '.' {
				symbols[Point{x, y}] = true
			}
		}
	}
	//fmt.Printf("Symbols are at %v\n", symbols)

	// adjacent point offsets to check
	adjacentOffsets := []Point{
		{-1, -1}, {0, -1}, {1, -1},
		{-1, 0}, {1, 0},
		{-1, 1}, {0, 1}, {1, 1},
	}

	// keep track of points we've looked at, so we can skip the following digit points for numbers we've already evaluated
	checkedPoints := make(map[Point]bool)

	validPartNumbers := []int{}

	// walk through and evaluate each number, checking if it touches a symbol
	for y, row := range input {
		for x, ch := range row {
			currentPoint := Point{x, y}
			if checkedPoints[currentPoint] {
				continue
			}

			if unicode.IsNumber(ch) {
				numberArr := []string{string(ch)}
				checkedPoints[currentPoint] = true

				// check if the number continues to the right
				for nextX := currentPoint.X + 1; nextX < len(row); nextX++ {
					adjacentRune := rune(row[nextX])
					if unicode.IsNumber(adjacentRune) {
						numberArr = append(numberArr, string(adjacentRune))
						checkedPoints[Point{nextX, y}] = true
					} else {
						break
					}
				}

				partNumberStr := strings.Join(numberArr[:], "")

				// check if any adjacent point has a symbol
				valid := false
				for i := range partNumberStr {
					for _, offsetPoint := range adjacentOffsets {
						checkPoint := Point{x + i + offsetPoint.X, y + offsetPoint.Y}
						if symbols[checkPoint] {
							partNumber, err := strconv.Atoi(partNumberStr)
							if err != nil {
								panic(fmt.Sprintf("unable to convert part number %v to an int: %v", partNumberStr, err))
							}
							//fmt.Printf("%v at %v is a valid part number! touches symbol at %v\n", partNumber, currentPoint, checkPoint)
							validPartNumbers = append(validPartNumbers, partNumber)
							valid = true
							break
						}
					}

					if valid {
						break
					}
				}

				if !valid {
					fmt.Printf("%v at %v is not a valid part number\n", partNumberStr, currentPoint)
				}
			}
		}
	}

	fmt.Printf("Part 1: %v\n", util.SumInts(validPartNumbers))
}

func part2(input []string) {
}
