package main

import (
	"fmt"
	"slices"
	"strings"
	"time"
	"unicode"

	"github.com/skenny/adventofcode/2023/util"
)

const day int = 5

type ConversionRange struct {
	SourceStart int
	DestStart   int
	Length      int
}

func main() {
	fmt.Printf("Day %v\n", day)
	input := util.ReadInput(day)
	part1(input)
	part2(input)
}

func part1(input []string) {
	seeds, conversionSteps, conversionMaps := parseInput(input)
	// fmt.Printf("Seeds: %v\n", seeds)
	// fmt.Printf("Conversion Steps: %v\n", conversionSteps)
	// for _, cs := range conversionSteps {
	// 	fmt.Println(cs)
	// 	for k, v := range conversionMaps[cs] {
	// 		fmt.Printf("\t%v -> %v\n", k, v)
	// 	}
	// }

	fmt.Println("Converting...")

	locations := []int{}
	for _, seed := range seeds {
		fmt.Println(seed)
		src := seed
		for _, cs := range conversionSteps {
			conversionRanges, ok := conversionMaps[cs]
			if !ok {
				panic(fmt.Sprintf("No conversion range mapped for %v", cs))
			}
			result := convert(src, conversionRanges)
			fmt.Printf("\t%v: %v -> %v\n", cs, src, result)
			src = result
		}
		locations = append(locations, src)
	}

	fmt.Printf("Part 1: %v\n", slices.Min(locations))
}

func part2(input []string) {
}

func convert(src int, conversionRanges []ConversionRange) int {
	for _, conversionRange := range conversionRanges {
		if src >= conversionRange.SourceStart && src < conversionRange.SourceStart+conversionRange.Length {
			return src + (conversionRange.DestStart - conversionRange.SourceStart)
		}
	}
	return src
}

func parseInput(input []string) ([]int, []string, map[string][]ConversionRange) {
	seeds := util.StringsToInts(strings.Fields(strings.Split(input[0], ": ")[1]))
	conversionSteps := []string{}
	conversionMaps := make(map[string][]ConversionRange)

	fmt.Printf("Started parsing input at %v\n", time.Now())

	workingConversionMap := ""
	for _, line := range input[1:] {
		// skip blanks
		if len(strings.TrimSpace(line)) == 0 {
			continue
		}

		// conversion map name
		if unicode.IsLetter(rune(line[0])) {
			workingConversionMap = strings.Fields(line)[0]
			conversionSteps = append(conversionSteps, workingConversionMap)
			fmt.Printf("%v...\n", workingConversionMap)
			continue
		}

		// conversion range
		conversionRanges, exists := conversionMaps[workingConversionMap]
		if !exists {
			conversionRanges = []ConversionRange{}
		}

		// TODO do not expand all ranges, it'll never complete on the real input
		conversionRangeParts := strings.Fields(line)
		destStart, sourceStart, rangeLen := util.MustAtoi(conversionRangeParts[0]), util.MustAtoi(conversionRangeParts[1]), util.MustAtoi(conversionRangeParts[2])
		//fmt.Printf("\t%v -> %v, range=%v...\n", sourceStart, destStart, rangeLen)
		conversionRanges = append(conversionRanges, ConversionRange{sourceStart, destStart, rangeLen})
		conversionMaps[workingConversionMap] = conversionRanges
	}

	fmt.Printf("Finished parsing input at %v\n", time.Now())

	return seeds, conversionSteps, conversionMaps
}
