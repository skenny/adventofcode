package main

import (
	"fmt"
	"strconv"
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
	fmt.Printf("Part 1: %v\n", waysToWin(timesAndDistances))
}

func part2(input []string) {
	timesAndDistances := parseInput(input)
	times := util.MapSlice(timesAndDistances, func(td TimeAndDistance) string { return strconv.Itoa(td.Time) })
	distances := util.MapSlice(timesAndDistances, func(td TimeAndDistance) string { return strconv.Itoa(td.Distance) })
	combinedTime := util.MustAtoi(strings.Join(times, ""))
	combinedDistance := util.MustAtoi(strings.Join(distances, ""))
	fmt.Printf("Part 2: %v\n", waysToWin([]TimeAndDistance{{combinedTime, combinedDistance}}))
}

func waysToWin(timesAndDistances []TimeAndDistance) int {
	waysToWin := []int{}
	for _, td := range timesAndDistances {
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
	return product(waysToWin)
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
