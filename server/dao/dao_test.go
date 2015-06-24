package dao

import (
	"fmt"
	"testing"
)

func Test_GetColNamesFromStruct(t *testing.T) {
	user := PGUser{}
	fmt.Println(getTableFromStruct(user))
	fmt.Println(getStructCols(user))
	fmt.Println(getStruFldsExceptAutoPK(PGToken{}))
	fmt.Println(getStructCols(PGToken{}))
}

func Test_meta(t *testing.T) {
	fmt.Printf(getTableFromStruct(PGToken{}))
}
//func Test_IfUserNameExists(t *testing.T) {
//	_, err := IfUserNameExists("lankc")
//	if err != nil {
//		t.Error(err)
//	}
//}

//func Test_CreateUser(t *testing.T) {
//	pguser := PGUser{}
//	pguser.Uname = "lankc"
//	pguser.Pwd = "123456"
//	pguser.Phone = "13599902xxx"
//	pguser.Email = "lkc@gmail.com"
//	pguser.Gender = 1
////	user.Language = 0
//	pguser.Occup = "Software Engineer"
//	pguser.UserType = 1
//	pguser.Birth, _ = time.Parse("2006-01-02", "1987-11-11")
//	pguser.CreatedAt = time.Now()
//	pguser.Description = "I'm so handsome"
//	pguser.Interest = "coding coding coding"
//
//	err := CreateUser(&pguser)
//	if err != nil {
//		t.Error(err)
//	}
//}

//func Test_QueryUser(t *testing.T) {
//	pguser, err := QueryUserByUname("lankc")
//	if err != nil {
//		t.Error(err)
//	} else {
//		fmt.Println(pguser)
//	}
//	fmt.Println("---------")
//	err := QueryTest()
//	if err != nil {
//		t.Error(err)
//	}
//}