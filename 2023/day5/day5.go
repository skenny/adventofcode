package main

import (
	"fmt"
	"slices"
	"strings"
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

	seedRanges := []string{"1263068588 44436703", "1116624626 2393304", "2098781025 128251971", "2946842531 102775703", "2361566863 262106125", "221434439 24088025", "1368516778 69719147", "3326254382 101094138", "1576631370 357411492", "3713929839 154258863"}
	for i, sr := range seedRanges {
		parts := strings.Fields(sr)
		fmt.Printf("%v .. %v (%v)\n", parts[0], util.MustAtoi(parts[0])+util.MustAtoi(parts[1])-1, i+1)
	}
}

func part1(input []string) {
	seeds, conversionSteps, conversionMaps := parseInput(input)
	locations := []int{}
	for _, seed := range seeds {
		src := seed
		for _, cs := range conversionSteps {
			result := convert(src, conversionMaps[cs])
			//fmt.Printf("\t%v: %v -> %v\n", cs, src, result)
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
			continue
		}

		// conversion range
		conversionRanges, exists := conversionMaps[workingConversionMap]
		if !exists {
			conversionRanges = []ConversionRange{}
		}
		conversionRangeParts := strings.Fields(line)
		destStart, sourceStart, rangeLen := util.MustAtoi(conversionRangeParts[0]), util.MustAtoi(conversionRangeParts[1]), util.MustAtoi(conversionRangeParts[2])
		conversionRanges = append(conversionRanges, ConversionRange{sourceStart, destStart, rangeLen})
		conversionMaps[workingConversionMap] = conversionRanges
	}

	return seeds, conversionSteps, conversionMaps
}
