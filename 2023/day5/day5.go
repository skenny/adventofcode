package main

import (
	"fmt"
	"math"
	"slices"
	"strings"
	"unicode"

	"github.com/skenny/adventofcode/2023/util"
)

const day int = 5

type SeedRange struct {
	Start int
	End   int
}

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
	locations := []int{}
	for _, seed := range seeds {
		locations = append(locations, locateSeed(seed, conversionSteps, conversionMaps))
	}
	fmt.Printf("Part 1: %v\n", slices.Min(locations))
}

func part2(input []string) {
	seeds, conversionSteps, conversionMaps := parseInput(input)
	seedRanges := buildSeedRanges(seeds)

	// determine the location start and end seed in each range, and use the minimum location as a ceiling for reverse lookups
	maxLocation := math.MaxInt64
	for _, seedRange := range seedRanges {
		startSeedLocation := locateSeed(seedRange.Start, conversionSteps, conversionMaps)
		endSeedLocation := locateSeed(seedRange.End, conversionSteps, conversionMaps)
		maxLocation = slices.Min([]int{maxLocation, startSeedLocation, endSeedLocation})
	}

	// reverse conversion steps
	for i, j := 0, len(conversionSteps)-1; i < j; i, j = i+1, j-1 {
		conversionSteps[i], conversionSteps[j] = conversionSteps[j], conversionSteps[i]
	}

	// deconvert from locations until we find a seed in the input
	for location := 0; location < maxLocation; location++ {
		seed := seedLocation(location, conversionSteps, conversionMaps)
		for _, seedRange := range seedRanges {
			if seed >= seedRange.Start && seed <= seedRange.End {
				fmt.Printf("Part 2: %v\n", location)
				return
			}
		}
	}
}

func locateSeed(seed int, conversionSteps []string, conversionMaps map[string][]ConversionRange) int {
	src := seed
	//fmt.Printf("[locateSeed] Seed %v\n", seed)
	for _, step := range conversionSteps {
		result := convert(src, conversionMaps[step])
		//fmt.Printf("[locateSeed]\t%v: %v -> %v\n", step, src, result)
		src = result
	}
	return src
}

func seedLocation(location int, conversionSteps []string, conversionMaps map[string][]ConversionRange) int {
	src := location
	//fmt.Printf("[seedLocation] Location %v\n", location)
	for _, step := range conversionSteps {
		result := deconvert(src, conversionMaps[step])
		//fmt.Printf("[seedLocation]\t%v: %v -> %v\n", step, src, result)
		src = result
	}
	return src
}

func convert(src int, conversionRanges []ConversionRange) int {
	for _, conversionRange := range conversionRanges {
		converted, ok := tryConvert(src, conversionRange)
		if ok {
			return converted
		}
	}
	return src
}

func deconvert(src int, conversionRanges []ConversionRange) int {
	for _, conversionRange := range conversionRanges {
		converted, ok := tryConvert(src, ConversionRange{conversionRange.DestStart, conversionRange.SourceStart, conversionRange.Length})
		if ok {
			return converted
		}
	}
	return src
}

func tryConvert(src int, conversionRange ConversionRange) (int, bool) {
	if src >= conversionRange.SourceStart && src < conversionRange.SourceStart+conversionRange.Length {
		return src + (conversionRange.DestStart - conversionRange.SourceStart), true
	}
	return src, false
}

func buildSeedRanges(seeds []int) []SeedRange {
	seedRanges := []SeedRange{}
	for i := 0; i < len(seeds); i += 2 {
		seedRanges = append(seedRanges, SeedRange{seeds[i], seeds[i] + seeds[i+1]})
	}
	return seedRanges
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
