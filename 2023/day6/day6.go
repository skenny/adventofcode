package main

import (
	"fmt"
	"strings"

	"github.com/skenny/adventofcode/2023/util"
)

const day int = 6

type TimeAndDistance struct {
	Time     int
	Distance int
}

func main() {
	fmt.Printf("Day %v\n", day)
	input := util.ReadInput(day)
	part1(input)
	part2(input)
}

func part1(input []string) {
	timesAndDistances := parseInput(input)
	waysToWin := []int{}
	for _, td := range timesAndDistances {
		fmt.Printf("This race lasts %v ms, and the record distance is %v mm\n", td.Time, td.Distance)
		winningDistances := []int{}
		for buttonPressDuration := 1; buttonPressDuration < td.Time; buttonPressDuration++ {
			speed := buttonPressDuration
			movedDistance := (td.Time - buttonPressDuration) * speed
			if movedDistance > td.Distance {
				winningDistances = append(winningDistances, movedDistance)
			}
		}
		waysToWin = append(waysToWin, len(winningDistances))
	}
	fmt.Printf("Part 1: %v", product(waysToWin))
}

func part2(input []string) {
}

func parseInput(input []string) []TimeAndDistance {
	times := util.MapSlice(strings.Fields(input[0])[1:], util.MustAtoi)
	distances := util.MapSlice(strings.Fields(input[1])[1:], util.MustAtoi)
	timesAndDistances := []TimeAndDistance{}
	for i := 0; i < len(times); i++ {
		time := times[i]
		distance := distances[i]
		timesAndDistances = append(timesAndDistances, TimeAndDistance{time, distance})
	}
	return timesAndDistances
}

func product(values []int) int {
	product := 1
	for _, v := range values {
		product *= v
	}
	return product
}
