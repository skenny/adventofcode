package util

import (
	"fmt"
	"os"
	"strconv"
	"strings"
)

func ReadInput(day int) []string {
	filename := fmt.Sprintf("day%v-input", day)
	return ReadFile(filename)
}

func ReadTestInput(day int) []string {
	filename := fmt.Sprintf("day%v-test-input", day)
	return ReadFile(filename)
}

func ReadTestInputN(day int, num int) []string {
	filename := fmt.Sprintf("day%v-test%v-input", day, num)
	return ReadFile(filename)
}

func ReadFile(filename string) []string {
	contents, err := os.ReadFile(filename)
	if err != nil {
		panic(err)
	}
	input := strings.Split(string(contents), "\n")
	return input
}

func MapSlice[T any, M any](a []T, f func(T) M) []M {
	n := make([]M, len(a))
	for i, e := range a {
		n[i] = f(e)
	}
	return n
}

func ReverseString(in string) string {
	out := ""
	for _, c := range in {
		out = string(c) + out
	}
	return out
}

func SumInts(ints []int) int {
	result := 0
	for _, i := range ints {
		result += i
	}
	return result
}

func MaxInt(ints []int) int {
	max := 0
	for i, val := range ints {
		if i == 0 || val > max {
			max = val
		}
	}
	return max
}

func MustAtoi(input string) int {
	parsed, err := strconv.Atoi(input)
	if err != nil {
		panic(fmt.Sprintf("Unable to convert %v to an int: %v", input, err))
	}
	return parsed
}

func StringsToInts(strs []string) []int {
	return MapSlice(strs, MustAtoi)
}
