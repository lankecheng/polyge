package pgpub

import "strings"

func RepeatChar(char string, sep string, size int) string {
	ary := make([]string, size)
	for i := 0; i < size; i++ {
		ary[i] = char
	}
	return strings.Join(ary, sep)
}