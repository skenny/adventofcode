package main

import (
	"fmt"
	"strconv"
	"strings"
	"unicode"

	"github.com/skenny/adventofcode/2023/util"
)

func main() {
	fmt.Println("Day 1")
	input, err := util.ReadFile("day1-input")
	if err != nil {
		fmt.Println("Error reading input", err)
		return
	}
	part1(input)
	part2(input)
}

func part1(input []string) {
	numbers := []int{}
	for _, line := range input {
		lineNumber, err := extractNumber(line, false)
		if err == nil {
			numbers = append(numbers, lineNumber)
		}
	}
	fmt.Printf("Part 1: %v\n", util.SumInts(numbers))
}

func part2(input []string) {
	numbers := []int{}
	for _, line := range input {
		lineNumber, err := extractNumber(line, true)
		if err == nil {
			numbers = append(numbers, lineNumber)
		}
	}
	fmt.Printf("Part 2: %v\n", util.SumInts(numbers))
}

func extractNumber(line string, checkWords bool) (int, error) {
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
	return strconv.Atoi(string(numberStr[0]) + string(numberStr[len(numberStr)-1]))
}
