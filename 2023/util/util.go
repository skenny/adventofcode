package util

import (
	"os"
	"strings"
)

func ReadFile(filename string) ([]string, error) {
	content, err := os.ReadFile(filename)
	if err != nil {
		return nil, err
	}
	lines := strings.Split(string(content), "\n")
	return lines, nil
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
