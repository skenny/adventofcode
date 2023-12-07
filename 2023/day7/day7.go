package main

import (
	"fmt"
	"slices"
	"sort"
	"strings"

	"github.com/skenny/adventofcode/2023/util"
	"golang.org/x/exp/maps"
)

const day int = 7

type Hand struct {
	Cards []string
	Wager int
}

var Cards = strings.Split("AKQJT98765432", "")

func main() {
	fmt.Printf("Day %v\n", day)
	input := util.ReadInput(day)
	test()
	part1(input)
	part2(input)
}

func test() {
	hands := []string{"AAAAA", "AA8AA", "23332", "TTT98", "23432", "A23A4", "23456"}
	for _, hand := range hands {
		fmt.Printf("%v scores %v\n", hand, scoreHand(Hand{strings.Split(hand, ""), 1}))
	}
}

func part1(input []string) {
	hands := parseInput(input)
	sort.Slice(hands, func(i, j int) bool {
		hand1 := hands[i]
		hand2 := hands[j]
		hand1Score := scoreHand(hand1)
		hand2Score := scoreHand(hand2)

		if hand1Score != hand2Score {
			return hand1Score < hand2Score
		}

		// tie breaker
		for i := 0; i < len(hand1.Cards); i++ {
			card1Rank := slices.Index(Cards, hand1.Cards[i])
			card2Rank := slices.Index(Cards, hand2.Cards[i])
			if card1Rank != card2Rank {
				return card1Rank < card2Rank
			}
		}

		return false
	})

	numHands := len(hands)
	totalWinnings := 0
	for i, hand := range hands {
		totalWinnings += (numHands - i) * hand.Wager
	}

	fmt.Printf("Part 1: %v", totalWinnings)
}

func part2(input []string) {
}

func parseInput(input []string) []Hand {
	hands := []Hand{}
	for _, line := range input {
		parts := strings.Fields(line)
		cards := strings.Split(parts[0], "")
		wager := util.MustAtoi(parts[1])
		hands = append(hands, Hand{cards, wager})
	}
	return hands
}

func scoreHand(hand Hand) int {
	cardCounts := make(map[string]int)
	for _, card := range hand.Cards {
		cardCount, ok := cardCounts[card]
		if !ok {
			cardCount = 0
		}
		cardCounts[card] = cardCount + 1
	}

	switch len(cardCounts) {
	case 1:
		// 5 of a kind
		return 1
	case 2:
		var countValues []int = maps.Values(cardCounts)
		slices.Sort(countValues)

		if countValues[1] == 4 {
			// 4 of a kind
			return 2
		}

		// full house
		return 3
	case 3:
		var countValues []int = maps.Values(cardCounts)
		slices.Sort(countValues)

		if countValues[2] == 3 {
			// 3 of a kind
			return 4
		}
		// 3 of a kind, 2 pair
		return 5
	case 4:
		// pair
		return 6
	case 5:
		// high card
		return 7
	default:
		panic(fmt.Sprintf("hand score is 0: %v", hand))
	}

}
