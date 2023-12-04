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
	input := util.ReadInput(day)
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
	originalScratchCards := parseScratchCards(input)

	// cache the winning number counts for each scratch card
	cardResults := make(map[int]int)
	for _, scratchCard := range originalScratchCards {
		cardResults[scratchCard.Number] = countWinningNumbers(scratchCard)
	}

	// make a working copy of the scratch cards to act as a stack for evaluation
	scratchCardStack := make([]ScratchCard, len(originalScratchCards))
	copy(scratchCardStack, originalScratchCards)

	cardCount := 0
	for {
		cardCount += 1

		// pop a card
		scratchCard := scratchCardStack[0]
		scratchCardStack = scratchCardStack[1:]
		for i := 1; i <= cardResults[scratchCard.Number]; i++ {
			scratchCardStack = append(scratchCardStack, originalScratchCards[scratchCard.Number-1+i])
		}

		if len(scratchCardStack) == 0 {
			break
		}
	}

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

func countWinningNumbers(scratchCard ScratchCard) int {
	count := 0
	for _, winningNumber := range scratchCard.WinningNumbers {
		if slices.Contains(scratchCard.PickedNumbers, winningNumber) {
			count += 1
		}
	}
	return count
}
