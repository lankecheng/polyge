package pgpub

func SearchStringArray(ary []string, a string) int {
	for i, v := range ary {
		if v == a {
			return i
		}
	}
	return -1
}
