package main

import (
	"fmt"
	"strconv"
	"strings"
	"unicode"

	"github.com/skenny/adventofcode/2023/util"
)

const day int = 1

func main() {
	fmt.Printf("Day %v\n", day)
	input := util.ReadInput(day)
	part1(input)
	part2(input)
}

func part1(input []string) {
	fmt.Printf("Part 1: %v\n", util.SumInts(util.MapSlice(input, extractNumber1)))
}

func part2(input []string) {
	fmt.Printf("Part 2: %v\n", util.SumInts(util.MapSlice(input, extractNumber2)))
}

func extractNumber1(line string) int {
	return parseNumber(line, false)
}

func extractNumber2(line string) int {
	return parseNumber(line, true)
}

func parseNumber(line string, checkWords bool) int {
	numberWords := []string{"one", "two", "three", "four", "five", "six", "seven", "eight", "nine"}

	var numberStrBuilder strings.Builder

	for i, ch := range line {
		if unicode.IsNumber(ch) {
			numberStrBuilder.WriteRune(ch)
		}
		if checkWords {
			remainingLine := line[i:]
			for i, word := range numberWords {
				if strings.HasPrefix(remainingLine, word) {
					numberStrBuilder.WriteString(strconv.Itoa(i + 1))
				}
			}
		}
	}

	numberStr := numberStrBuilder.String()
	number := string(numberStr[0]) + string(numberStr[len(numberStr)-1])

	i, err := strconv.Atoi(number)
	if err != nil {
		panic(fmt.Sprintf("%v -> %v -> %v, but %v is not a number", line, numberStr, number, number))
	}

	return i
}
