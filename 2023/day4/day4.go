package main

import (
	"fmt"
	"slices"
	"strings"

	"github.com/skenny/adventofcode/2023/util"
)

const day int = 4

func main() {
	fmt.Printf("Day %v\n", day)
	input := util.ReadInput(day)
	part1(input)
	part2(input)
}

func part1(input []string) {
	scores := []int{}
	for _, cardDesc := range input {
		cardParts := strings.Split(cardDesc, ":")
		numbersParts := strings.Split(cardParts[1], "|")
		winningNumbers := strings.Fields(strings.Trim(numbersParts[0], " "))
		cardNumbers := strings.Fields(strings.Trim(numbersParts[1], " "))

		score := 0
		for _, winningNumber := range winningNumbers {
			if slices.Contains(cardNumbers, winningNumber) {
				if score == 0 {
					score = 1
				} else {
					score *= 2
				}
			}
		}

		scores = append(scores, score)
	}

	fmt.Printf("Part 1: %v", util.SumInts(scores))
}

func part2(input []string) {
}
