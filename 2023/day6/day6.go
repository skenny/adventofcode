package main

import (
	"fmt"
	"strconv"
	"strings"

	"github.com/skenny/adventofcode/2023/util"
)

const day int = 6

type Race struct {
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
	races := parseInput(input)
	fmt.Printf("Part 1: %v\n", product(waysToWin(races)))
}

func part2(input []string) {
	races := parseInput(input)
	times := util.MapSlice(races, func(td Race) string { return strconv.Itoa(td.Time) })
	distances := util.MapSlice(races, func(td Race) string { return strconv.Itoa(td.Distance) })
	combinedTime := util.MustAtoi(strings.Join(times, ""))
	combinedDistance := util.MustAtoi(strings.Join(distances, ""))
	fmt.Printf("Part 2: %v\n", waysToWin([]Race{{combinedTime, combinedDistance}})[0])
}

func waysToWin(races []Race) []int {
	waysToWin := []int{}
	for _, race := range races {
		winningDistances := []int{}
		for buttonPressDuration := 1; buttonPressDuration < race.Time; buttonPressDuration++ {
			speed := buttonPressDuration
			movedDistance := (race.Time - buttonPressDuration) * speed
			if movedDistance > race.Distance {
				winningDistances = append(winningDistances, movedDistance)
			}
		}
		waysToWin = append(waysToWin, len(winningDistances))
	}
	return waysToWin
}

func parseInput(input []string) []Race {
	times := util.MapSlice(strings.Fields(input[0])[1:], util.MustAtoi)
	distances := util.MapSlice(strings.Fields(input[1])[1:], util.MustAtoi)
	timesAndDistances := []Race{}
	for i := 0; i < len(times); i++ {
		time := times[i]
		distance := distances[i]
		timesAndDistances = append(timesAndDistances, Race{time, distance})
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
