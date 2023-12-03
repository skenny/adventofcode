package main

import (
	"fmt"
	"regexp"
	"strconv"
	"strings"

	"github.com/skenny/adventofcode/2023/util"
)

const day int = 2

type Reveal struct {
	Red   int
	Green int
	Blue  int
}

func main() {
	fmt.Printf("Day %v\n", day)
	input := util.ReadInput(day)
	part1(input)
	part2(input)
}

func part1(input []string) {
	const maxRed, maxGreen, maxBlue int = 12, 13, 14
	sumPossibleIds := 0
	for _, gameDesc := range input {
		id, reveals := parseGame(gameDesc)
		possible := true
		for _, reveal := range reveals {
			possible = possible && (reveal.Red <= maxRed && reveal.Green <= maxGreen && reveal.Blue <= maxBlue)
		}
		if possible {
			sumPossibleIds += id
		}
	}
	fmt.Printf("Part 1: %v\n", sumPossibleIds)
}

func part2(input []string) {
	sumPowerSets := 0
	for _, gameDesc := range input {
		_, reveals := parseGame(gameDesc)
		reds := util.MapSlice(reveals, func(r Reveal) int { return r.Red })
		greens := util.MapSlice(reveals, func(r Reveal) int { return r.Green })
		blues := util.MapSlice(reveals, func(r Reveal) int { return r.Blue })
		sumPowerSets += util.MaxInt(reds) * util.MaxInt(greens) * util.MaxInt(blues)
	}
	fmt.Printf("Part 2: %v\n", sumPowerSets)
}

func parseGame(gameDesc string) (int, []Reveal) {
	gamePattern := regexp.MustCompile(`^Game (\d+): (.+)$`)
	gameDescMatches := gamePattern.FindStringSubmatch(gameDesc)
	id, _ := strconv.Atoi(gameDescMatches[1])
	reveals := util.MapSlice(strings.Split(gameDescMatches[2], ";"), parseReveal)
	return id, reveals
}

func parseReveal(revealDesc string) Reveal {
	return Reveal{countColor("red", revealDesc), countColor("green", revealDesc), countColor("blue", revealDesc)}
}

func countColor(color string, revealDesc string) int {
	pattern := regexp.MustCompile(`(\d+) ` + color)
	if pattern.MatchString(revealDesc) {
		count, err := strconv.Atoi(pattern.FindStringSubmatch(revealDesc)[1])
		if err != nil {
			panic(fmt.Sprintf("error extracting %v count from %v: %v", color, revealDesc, err))
		}
		return count
	}
	return 0
}
