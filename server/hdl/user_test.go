package user

import (
	"testing"
	"time"
)

func Test_IfUserNameExists(t *testing.T) {
	_, err := IfUserNameExists("lankc")
	if err != nil {
		t.Error(err)
	}
}

func Test_CreateUser(t *testing.T) {
	pguser := PGUser{}
	pguser.Uname = "lankc"
	pguser.Pwd = "123456"
	pguser.Phone = "13599902xxx"
	pguser.Email = "lkc@gmail.com"
	pguser.Gender = 1
//	user.Language = 0
	pguser.Occup = "Software Engineer"
	pguser.UserType = 1
	pguser.Birth, _ = time.Parse("2006-01-02", "1987-11-11")
	pguser.CreatedAt = time.Now()
	pguser.Description = "I'm so handsome"
	pguser.Interest = "coding coding coding"

	err := CreateUser(&pguser)
	if err != nil {
		t.Error(err)
	}
}