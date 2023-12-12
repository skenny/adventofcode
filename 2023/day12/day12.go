package main

import (
	"fmt"
	"strings"

	"github.com/skenny/adventofcode/2023/util"
)

const day int = 12

type SpringGroup struct {
	CriteriaGroups []string
	GroupCounts    []int
}

func main() {
	fmt.Printf("Day %v\n", day)
	input := util.ReadTestInput(day)
	part1(input)
	part2(input)
}

func part1(input []string) {
	springGroups := parseInput(input)
	for _, springGroup := range springGroups {
		fmt.Println(springGroup)
	}
}

func part2(input []string) {
}

func parseInput(input []string) []SpringGroup {
	springGroups := []SpringGroup{}
	for _, line := range input {
		parts := strings.Fields(line)

		criteriaDesc := parts[0]
		groupLengthsDesc := parts[1]

		criteriaGroups := []string{}
		currentGroup := []string{}
		for _, c := range strings.Split(criteriaDesc, "") {
			if c == "." {
				if len(currentGroup) > 0 {
					criteriaGroups = append(criteriaGroups, strings.Join(currentGroup, ""))
					currentGroup = []string{}
				}
			} else {
				currentGroup = append(currentGroup, c)
			}
		}
		if len(currentGroup) > 0 {
			criteriaGroups = append(criteriaGroups, strings.Join(currentGroup, ""))
		}

		groupLengths := util.MapSlice(strings.Split(groupLengthsDesc, ","), util.MustAtoi)
		springGroups = append(springGroups, SpringGroup{criteriaGroups, groupLengths})
	}
	return springGroups
}
