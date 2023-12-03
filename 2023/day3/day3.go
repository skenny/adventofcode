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

type PartNumber struct {
	Number int
	Points []Point
}

func main() {
	fmt.Printf("Day %v\n", day)
	input := util.ReadInput(day)
	part1(input)
	part2(input)
}

func part1(input []string) {
	symbols, partNumbers := parseInput(input)

	// adjacent point offsets to check
	adjacentOffsets := []Point{
		{-1, -1}, {0, -1}, {1, -1},
		{-1, 0}, {1, 0},
		{-1, 1}, {0, 1}, {1, 1},
	}

	sumValidPartNumbers := 0
	for _, partNumber := range partNumbers {
		valid := false
		for _, occupyingPoint := range partNumber.Points {
			for _, offsetPoint := range adjacentOffsets {
				checkPoint := Point{occupyingPoint.X + offsetPoint.X, occupyingPoint.Y + offsetPoint.Y}
				_, found := symbols[checkPoint]
				if found {
					valid = true
					break
				}
			}
			if valid {
				break
			}
		}
		if valid {
			sumValidPartNumbers += partNumber.Number
		}
	}

	fmt.Printf("Part 1: %v\n", sumValidPartNumbers)
}

func part2(input []string) {
	symbols, partNumbers := parseInput(input)

	// adjacent point offsets to check
	adjacentOffsets := []Point{
		{-1, -1}, {0, -1}, {1, -1},
		{-1, 0}, {1, 0},
		{-1, 1}, {0, 1}, {1, 1},
	}

	const gear = "*"
	sumGearRatios := 0

	for symbolPoint, symbol := range symbols {
		if symbol == gear {
			touchingPartNumbers := []int{}
			for _, partNumber := range partNumbers {
				touching := false
				for _, partNumberPoint := range partNumber.Points {
					for _, offsetPoint := range adjacentOffsets {
						checkPoint := Point{partNumberPoint.X + offsetPoint.X, partNumberPoint.Y + offsetPoint.Y}
						if checkPoint == symbolPoint {
							touching = true
							break
						}
					}
					if touching {
						break
					}
				}
				if touching {
					touchingPartNumbers = append(touchingPartNumbers, partNumber.Number)
				}
			}
			if len(touchingPartNumbers) == 2 {
				sumGearRatios += (touchingPartNumbers[0] * touchingPartNumbers[1])
			}
		}
	}

	fmt.Printf("Part 2: %v\n", sumGearRatios)
}

func parseInput(input []string) (map[Point]string, []PartNumber) {
	symbols := make(map[Point]string)
	partNumbers := []PartNumber{}
	checkedPoints := make(map[Point]bool)

	for y, row := range input {
		for x, ch := range row {
			currentPoint := Point{x, y}

			if checkedPoints[currentPoint] {
				continue
			}

			checkedPoints[currentPoint] = true

			if unicode.IsNumber(ch) {
				occupyingPoints := []Point{currentPoint}
				partNumberArr := []string{string(ch)}

				// check if the number continues to the right
				for nextX := currentPoint.X + 1; nextX < len(row); nextX++ {
					nextPoint := Point{nextX, y}

					adjacentRune := rune(row[nextX])
					if unicode.IsNumber(adjacentRune) {
						occupyingPoints = append(occupyingPoints, nextPoint)
						partNumberArr = append(partNumberArr, string(adjacentRune))
						checkedPoints[nextPoint] = true
					} else {
						break
					}
				}

				partNumberStr := strings.Join(partNumberArr[:], "")
				partNumber, err := strconv.Atoi(partNumberStr)

				if err != nil {
					panic(fmt.Sprintf("unable to convert part number %v to an int: %v\n", partNumberStr, err))
				}

				partNumbers = append(partNumbers, PartNumber{partNumber, occupyingPoints})
			} else if ch != '.' {
				symbols[currentPoint] = string(ch)
			}
		}
	}

	return symbols, partNumbers
}
