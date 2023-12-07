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

var Cards = strings.Split("AKQJT98765432J", "")

const FIVE_OF_A_KIND = 1
const FOUR_OF_A_KIND = 2
const FULL_HOUSE = 3
const THREE_OF_A_KIND = 4
const TWO_PAIR = 5
const ONE_PAIR = 6
const HIGH_CARD = 7

func main() {
	fmt.Printf("Day %v\n", day)
	input := util.ReadInput(day)
	test()
	part1(input)
	part2(input)
}

func test() {
	//hands := []string{"AAAAA", "AA8AA", "23332", "TTT98", "23432", "A23A4", "23456"}
	jokerHands := []string{"JAAAA", "JAAA5", "JAA55", "JAA45", "JA345", "JJAAA", "JJAA5", "JJA45", "JJJAA", "JJJA5", "JJJJA"}
	for _, hand := range jokerHands {
		fmt.Printf("%v scores %v\n", hand, scoreHand(Hand{strings.Split(hand, ""), 1}, true))
	}
}

func part1(input []string) {
	const jokersAreWild = false
	hands := parseInput(input)
	fmt.Printf("Part 1: %v\n", calculateTotalWinnings(hands, jokersAreWild))
}

func part2(input []string) {
	const jokersAreWild = true
	hands := parseInput(input)
	fmt.Printf("Part 2: %v\n", calculateTotalWinnings(hands, jokersAreWild))
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

func calculateTotalWinnings(hands []Hand, jokersAreWild bool) int {
	sortedHands := sortHands(hands, jokersAreWild)
	numHands := len(sortedHands)
	totalWinnings := 0
	for i, hand := range sortedHands {
		totalWinnings += (numHands - i) * hand.Wager
	}
	return totalWinnings
}

func sortHands(hands []Hand, jokersAreWild bool) []Hand {
	sort.Slice(hands, func(i, j int) bool {
		hand1 := hands[i]
		hand2 := hands[j]
		hand1Score := scoreHand(hand1, jokersAreWild)
		hand2Score := scoreHand(hand2, jokersAreWild)

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

	return hands
}

func scoreHand(hand Hand, jokersAreWild bool) int {
	cardCounts := make(map[string]int)
	for _, card := range hand.Cards {
		cardCount, ok := cardCounts[card]
		if !ok {
			cardCount = 0
		}
		cardCounts[card] = cardCount + 1
	}

	jokers := 0
	if jokersAreWild {
		jokers = cardCounts["J"]
	}

	var countValues []int = maps.Values(cardCounts)
	slices.Sort(countValues)

	switch len(cardCounts) {
	case 1:
		return FIVE_OF_A_KIND
	case 2:
		fourOfAKind := countValues[0] == 1 && countValues[1] == 4
		fullHouse := countValues[0] == 2 && countValues[1] == 3

		if jokers > 0 {
			return FIVE_OF_A_KIND
		}

		if fourOfAKind {
			return FOUR_OF_A_KIND
		}

		if fullHouse {
			return FULL_HOUSE
		}

		panic(fmt.Sprintf("unexpected cards %v", hand.Cards))
	case 3:
		threeAndOneAndOne := countValues[0] == 1 && countValues[1] == 1 && countValues[2] == 3
		twoPairAndOne := countValues[0] == 1 && countValues[1] == 2 && countValues[2] == 2

		if threeAndOneAndOne {
			if jokers == 3 {
				return FOUR_OF_A_KIND
			}
			if jokers == 1 {
				return FOUR_OF_A_KIND
			}
			return THREE_OF_A_KIND
		}

		if twoPairAndOne {
			if jokers == 2 {
				return FOUR_OF_A_KIND
			}
			if jokers == 1 {
				return FULL_HOUSE
			}
			return TWO_PAIR
		}

		panic(fmt.Sprintf("unexpected cards %v", hand.Cards))
	case 4:
		one_pair := countValues[0] == 1 && countValues[1] == 1 && countValues[2] == 1 && countValues[3] == 2

		if one_pair {
			if jokers == 2 {
				return THREE_OF_A_KIND
			}
			if jokers == 1 {
				return THREE_OF_A_KIND
			}
			return ONE_PAIR
		}

		panic(fmt.Sprintf("unexpected cards %v", hand.Cards))
	case 5:
		if jokers == 1 {
			return ONE_PAIR
		}
		return HIGH_CARD
	default:
		panic(fmt.Sprintf("hand score is 0: %v", hand))
	}

}
