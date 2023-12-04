package main

import (
	"fmt"
	"slices"
	"strconv"
	"strings"

	"github.com/skenny/adventofcode/2023/util"
)

const day int = 4

type ScratchCard struct {
	Number         int
	WinningNumbers []string
	PickedNumbers  []string
}

func main() {
	fmt.Printf("Day %v\n", day)
	input := util.ReadTestInput(day)
	part1(input)
	part2(input)
}

func part1(input []string) {
	scratchCards := parseScratchCards(input)
	scores := []int{}
	for _, scratchCard := range scratchCards {
		score := 0
		for _, winningNumber := range scratchCard.WinningNumbers {
			if slices.Contains(scratchCard.PickedNumbers, winningNumber) {
				if score == 0 {
					score = 1
				} else {
					score *= 2
				}
			}
		}
		scores = append(scores, score)
	}
	fmt.Printf("Part 1: %v\n", util.SumInts(scores))
}

func part2(input []string) {
	scratchCards := parseScratchCards(input)
	cardCount := len(scratchCards)
	// TODO
	fmt.Printf("Part 2: %v\n", cardCount)
}

func parseScratchCards(input []string) []ScratchCard {
	return util.MapSlice(input, func(cardDesc string) ScratchCard {
		cardParts := strings.Split(cardDesc, ":")

		cardName := strings.Fields(strings.Trim(cardParts[0], " "))
		cardNumber, err := strconv.Atoi(cardName[1])
		if err != nil {
			panic(fmt.Sprintf("Error parsing card number from %v", cardName))
		}

		numbersParts := strings.Split(cardParts[1], "|")
		winningNumbers := strings.Fields(strings.Trim(numbersParts[0], " "))
		pickedNumbers := strings.Fields(strings.Trim(numbersParts[1], " "))

		return ScratchCard{cardNumber, winningNumbers, pickedNumbers}
	})
}
