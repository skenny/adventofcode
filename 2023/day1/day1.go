package main

import (
	"fmt"
	"strconv"
	"unicode"

	"github.com/skenny/adventofcode/2023/util"
)

func main() {
	fmt.Println("Day 1")
	input, err := util.ReadFile("day1-test2-input")
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
		lineNumberStr := string(findFirstNumber(line)) + string(findFirstNumber(util.ReverseString(line)))
		lineNumber, err := strconv.Atoi(lineNumberStr)
		if err == nil {
			numbers = append(numbers, lineNumber)
		}
	}
	fmt.Printf("Part 1: %v\n", util.SumInts(numbers))
}

func part2(input []string) {
	//conversionInputs := []string{"one", "two", "three", "four", "five", "six", "seven", "eight", "nine"}
	//conversionOutputs := []int{1, 2, 3, 4, 5, 6, 7, 8, 9}
	numbers := []int{}
	for _, line := range input {
		/* this doesn't work:
		for i, word := range conversionInputs {
			line = strings.ReplaceAll(line, word, strconv.Itoa(conversionOutputs[i]))
		}
		*/

		/* maybe this would work:
		- check if word starts with a conversionInput; if so, replace
		- otherwise, pop the front character, and repeat
		*/

		lineNumberStr := string(findFirstNumber(line)) + string(findFirstNumber(util.ReverseString(line)))
		lineNumber, err := strconv.Atoi(lineNumberStr)
		if err == nil {
			numbers = append(numbers, lineNumber)
		}
	}
	fmt.Printf("Part 2: %v\n", util.SumInts(numbers))
}

func findFirstNumber(str string) int {
	for _, c := range str {
		if unicode.IsNumber(c) {
			return int(c)
		}
	}
	// should never happen
	return 0
}
