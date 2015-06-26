package pgpub

import "errors"

var (
	ErrUserExist = errors.New("user already exists")
	ErrPwdWrong  = errors.New("password is wrong")
	ErrNotExist  = errors.New("target not exists")
)

var (
	TypeStudent = 1
	TypeTeacher = 2
)
