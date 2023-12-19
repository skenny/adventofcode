package main

import (
	"fmt"
	"regexp"
	"slices"
	"strings"

	"github.com/skenny/adventofcode/2023/util"
)

const day int = 19

type Workflow struct {
	Name  string
	Rules []Rule
}

func (w Workflow) Process(part Part) string {
	for _, rule := range w.Rules {
		if rule.Test(part) {
			return rule.DestinationWorkflow
		}
	}
	panic(fmt.Sprintf("no destination from workflow %v for part %v!", w, part))
}

type Rule struct {
	PartCategory        string
	Operator            string
	Limit               int
	DestinationWorkflow string
}

func (r Rule) Test(part Part) bool {
	rating := part.Rating(r.PartCategory)
	if r.Operator == ">" {
		return rating > r.Limit
	}
	return rating < r.Limit
}

type Part struct {
	X int
	M int
	A int
	S int
}

func (p Part) Rating(category string) int {
	switch category {
	case "x":
		return p.X
	case "m":
		return p.M
	case "a":
		return p.A
	case "s":
		return p.S
	default:
		panic(fmt.Sprintf("no value for %v in part %v!\n", category, p))
	}
}

func (p Part) Sum() int {
	return p.X + p.M + p.A + p.S
}

func main() {
	fmt.Printf("Day %v\n", day)
	input := util.ReadInput(day)
	part1(input)
	part2(input)
}

func part1(input []string) {
	workflows, parts := parseInput(input)

	// build a lookup table of workflow name -> workflows
	workflowLookup := map[string]Workflow{}
	for _, workflow := range workflows {
		workflowLookup[workflow.Name] = workflow
	}

	accepted := []Part{}
	for _, part := range parts {
		destination := "in"
		for {
			destination = workflowLookup[destination].Process(part)
			if destination == "A" {
				accepted = append(accepted, part)
				break
			} else if destination == "R" {
				// rejected - throw it away
				break
			}
		}
	}

	sum := 0
	for _, part := range accepted {
		sum += part.Sum()
	}

	fmt.Printf("Part 1: %v\n", sum)
}

func part2(input []string) {
}

func parseInput(input []string) ([]Workflow, []Part) {
	split := slices.Index(input, "")
	workflowSpecs, partSpecs := input[0:split], input[split+1:]

	workflowSpecPattern := regexp.MustCompile(`([a-z]+){(.+)}`)
	ruleSpecPattern := regexp.MustCompile(`([xmas])([<>])([0-9]+):([a-z]+|[AR])`)
	workflows := []Workflow{}
	for _, workflowSpec := range workflowSpecs {
		workflowSpecMatches := workflowSpecPattern.FindStringSubmatch(workflowSpec)
		workflowName := workflowSpecMatches[1]
		rules := []Rule{}
		for _, ruleSpec := range strings.Split(workflowSpecMatches[2], ",") {
			if ruleSpecPattern.MatchString(ruleSpec) {
				ruleSpecMatches := ruleSpecPattern.FindStringSubmatch(ruleSpec)
				rules = append(rules, Rule{ruleSpecMatches[1], ruleSpecMatches[2], util.MustAtoi(ruleSpecMatches[3]), ruleSpecMatches[4]})
			} else {
				rules = append(rules, Rule{"x", ">", 0, ruleSpec})
			}
		}
		workflows = append(workflows, Workflow{workflowName, rules})
	}

	partSpecPattern := regexp.MustCompile(`\{x=([0-9]+),m=([0-9]+),a=([0-9]+),s=([0-9]+)\}`)
	parts := []Part{}
	for _, partSpec := range partSpecs {
		partSpecMatches := partSpecPattern.FindStringSubmatch(partSpec)
		x, m, a, s := partSpecMatches[1], partSpecMatches[2], partSpecMatches[3], partSpecMatches[4]
		parts = append(parts, Part{util.MustAtoi(x), util.MustAtoi(m), util.MustAtoi(a), util.MustAtoi(s)})
	}

	return workflows, parts
}
