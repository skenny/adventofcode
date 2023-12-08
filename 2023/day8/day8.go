package main

import (
	"fmt"
	"regexp"
	"strings"

	"github.com/skenny/adventofcode/2023/util"
)

const day int = 8

type Node struct {
	Element string
	Left    string
	Right   string
}

type Map struct {
	Instructions []string
	Network      map[string]Node
}

var NODE_PATTERN = regexp.MustCompile(`^([A-Z]{3}) = \(([A-Z]{3}), ([A-Z]{3})\)$`)

func main() {
	fmt.Printf("Day %v\n", day)
	input := util.ReadInput(day)
	part1(input)
	part2(input)
}

func part1(input []string) {
	inputMap := parseInput(input)
	fmt.Printf("Part 1: %v\n", countSteps(inputMap, "AAA", "ZZZ"))
}

func part2(input []string) {
}

func countSteps(inputMap Map, start string, end string) int {
	steps := 0
	instructionCount := len(inputMap.Instructions)
	current := start
	for {
		if current == end {
			break
		}

		node := inputMap.Network[current]
		nextInstruction := inputMap.Instructions[steps%instructionCount]

		switch nextInstruction {
		case "L":
			current = node.Left
		case "R":
			current = node.Right
		default:
			panic(fmt.Sprintf("unexpected instruction %v", nextInstruction))
		}

		steps += 1
	}
	return steps
}

func parseInput(input []string) Map {
	instructions := strings.Split(input[0], "")
	network := make(map[string]Node)
	for _, nodeDesc := range input[2:] {
		nodePatternMatches := NODE_PATTERN.FindStringSubmatch(nodeDesc)
		element, left, right := nodePatternMatches[1], nodePatternMatches[2], nodePatternMatches[3]
		network[element] = Node{element, left, right}
	}
	return Map{instructions, network}
}
