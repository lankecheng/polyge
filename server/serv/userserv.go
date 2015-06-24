package serv

import (
	"github.com/lankecheng/polyge/server/dao"
	"github.com/lankecheng/polyge/server/pgpub"
	"errors"
	"sync"
)

var registerLock *sync.Mutex = new(sync.Mutex)

func Register(uname string, phone string, email string, pwd string, userType int) (success bool, err error) {
	registerLock.Lock()
	defer registerLock.Unlock()

	pguser := dao.PGUser{Pwd: pwd, UserType: userType, Uname:uname, Phone:phone, Email:email,}
	exists, err := CheckUserExists(pguser.Uname, pguser.Phone, pguser.Email)
	if err != nil {
		return
	}

	if exists {
		err = pgpub.ErrUserExist
		return
	}

	err = dao.CreateUser(&pguser, "Uname", "Phone", "Email", "Pwd", "UserType")
	if err != nil {
		return
	}

	success = true
	return
}

func CheckUserExists(uname string, phone string, email string) (exists bool, err error) {
	if uname != "" {
		exists, err = dao.IfUnameExists(uname)
	} else if phone != "" {
		exists, err = dao.IfPhoneExists(phone)
	} else if email != "" {
		exists, err = dao.IfEmailExists(email)
	} else {
		err = errors.New("serv.QueryUser args are all empty string")
	}

	return
}

func Login(uname string, phone string, email string, pwd string) (pguser dao.PGUser, err error){
	if uname != "" {
		pguser, err = dao.QueryUserByUname(uname)
	} else if phone != "" {
		pguser, err = dao.QueryUserByPhone(phone)
	} else if email != "" {
		pguser, err = dao.QueryUserByEmail(email)
	} else {
		err = errors.New("serv.QueryUser args are all empty string")
		return
	}

	if err != nil {
		return
	}

	if pguser.Pwd != pwd {
		err = pgpub.ErrPwdWrong
		return
	}

	return
}