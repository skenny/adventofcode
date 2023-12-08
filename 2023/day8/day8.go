package main

import (
	"fmt"
	"regexp"
	"strings"

	"github.com/skenny/adventofcode/2023/util"
	"golang.org/x/exp/maps"
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

var NODE_PATTERN = regexp.MustCompile(`^([A-Z0-9]{3}) = \(([A-Z0-9]{3}), ([A-Z0-9]{3})\)$`)

func main() {
	fmt.Printf("Day %v\n", day)
	input := util.ReadInput(day)
	part1(input)
	part2(input)
}

func part1(input []string) {
	inputMap := parseInput(input)
	fmt.Printf("Part 1: %v\n", walkPath(inputMap, "AAA", "ZZZ"))
}

func part2(input []string) {
	inputMap := parseInput(input)
	fmt.Printf("Part 2: %v\n", walkAllPaths(inputMap, "A", "Z"))
}

func walkAllPaths(inputMap Map, startSuffix string, endSuffix string) int {
	pathStepCounts := []int{}
	for _, element := range maps.Keys(inputMap.Network) {
		if strings.HasSuffix(element, startSuffix) {
			pathStepCounts = append(pathStepCounts, walkPath(inputMap, element, "Z"))
		}
	}
	totalSteps := 1
	for _, pathStepCount := range pathStepCounts {
		totalSteps = (totalSteps * pathStepCount) / gcd(totalSteps, pathStepCount)
	}
	return totalSteps
}

func walkPath(inputMap Map, start string, endSuffix string) int {
	instructionCount := len(inputMap.Instructions)
	steps := 0
	currentElement := start
	for {
		if strings.HasSuffix(currentElement, endSuffix) {
			break
		}

		elementNode := inputMap.Network[currentElement]
		nextInstruction := inputMap.Instructions[steps%instructionCount]

		switch nextInstruction {
		case "L":
			currentElement = elementNode.Left
		case "R":
			currentElement = elementNode.Right
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
		if len(nodePatternMatches) == 0 {
			panic(fmt.Sprintf("input line doesn't match node pattern: %v", nodeDesc))
		}
		element, left, right := nodePatternMatches[1], nodePatternMatches[2], nodePatternMatches[3]
		network[element] = Node{element, left, right}
	}
	return Map{instructions, network}
}

func gcd(a, b int) int {
	if b == 0 {
		return a
	}
	return gcd(b, a%b)
}
