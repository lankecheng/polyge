package pgpub

import "os"

func IsFileExist(path string) (exists bool, err error) {
	_, err = os.Stat(path)
	exists = err == nil || os.IsExist(err)
	return
}
