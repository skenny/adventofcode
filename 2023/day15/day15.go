package main

import (
	"fmt"
	"regexp"
	"strings"

	"github.com/skenny/adventofcode/2023/util"
)

const day int = 15

type Lens struct {
	Label string
	F     int
}

func main() {
	fmt.Printf("Day %v\n", day)
	input := util.ReadInput(day)
	part1(input)
	part2(input)
}

func part1(input []string) {
	steps := strings.Split(input[0], ",")
	fmt.Printf("Part 1: %v\n", util.SumInts(util.MapSlice(steps, hash)))
}

func part2(input []string) {
	steps := strings.Split(input[0], ",")
	stepPattern := regexp.MustCompile(`([a-z]+)([-=])(\d*)`)
	boxes := make(map[int][]Lens)

	for _, step := range steps {
		stepParts := stepPattern.FindStringSubmatch(step)
		label, op := stepParts[1], stepParts[2]
		box := hash(label)

		lenses, exists := boxes[box]
		if !exists {
			lenses = []Lens{}
		}

		lensIndex := -1
		for i, lens := range lenses {
			if lens.Label == label {
				lensIndex = i
			}
		}

		switch op {
		case "-":
			if lensIndex != -1 {
				lenses = append(lenses[:lensIndex], lenses[lensIndex+1:]...)
			}
		case "=":
			lens := Lens{F: util.MustAtoi(stepParts[3]), Label: label}
			if lensIndex == -1 {
				lenses = append(lenses, lens)
			} else {
				lenses[lensIndex] = lens
			}
		default:
			panic(fmt.Sprintf("unexpected op (step %v): %v", step, op))
		}

		boxes[box] = lenses
	}

	totalFocusingPower := 0
	for box, boxContents := range boxes {
		for slot, lens := range boxContents {
			totalFocusingPower += (box + 1) * (slot + 1) * lens.F
		}
	}

	fmt.Printf("Part 2: %v\n", totalFocusingPower)
}

func hash(str string) int {
	hash := 0
	for _, c := range str {
		hash += int(c)
		hash = (hash * 17) % 256
	}
	return hash
}
