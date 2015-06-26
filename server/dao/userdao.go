package dao

import (
	"fmt"
	"github.com/cihub/seelog"
	"strings"
	"time"
	"github.com/lankecheng/polyge/server/pgpub"
)

type PGUser struct {
	Uid         int
	Uname       string
	Pwd         string
	Phone       string
	Email       string
	Gender      int
	Language    int
	Occup       string
	UserType    int
	Avatar      string
	Audio       string
	Birth       time.Time `sql:"int"`
	Country     int
	Province    int
	City        int
	CreatedAt   time.Time `sql:"int"`
	Description string
	Interest    string
}

func IfUnameExists(uname string) (exists bool, err error) {
	return ifUserExists("uname", uname)
}

func IfPhoneExists(phone string) (exists bool, err error) {
	return ifUserExists("phone", phone)
}

func IfEmailExists(email string) (exists bool, err error) {
	return ifUserExists("email", email)
}

func ifUserExists(colName string, val string) (exists bool, err error) {
	err = db.Ping()
	if err != nil {
		seelog.Errorf("uname %v ping mysql %v", val, err)
		return
	}

	sql := fmt.Sprintf("select 1 from pg_user where %v=?", colName)
	rs, err := db.Query(sql, val)
	if err != nil {
		seelog.Errorf("IfUserExists(%v, %v) query : %v", colName, val, err)
		return
	}
	exists = rs.Next()

	if err = rs.Err(); err != nil {
		seelog.Errorf("IfUserExists(%v, %v) read rows : %v", colName, val, err)
	}

	return
}

func CreateUser(pguser *PGUser, struFlds ...string) error {
	pguser.CreatedAt = time.Now()
	newStruFlds := append(struFlds, "CreatedAt")
	return DBCreateIncludeFlds(pguser, newStruFlds...)
}

func UpdateUser(pguser *PGUser) (err error) {
	return DBUpdateExcludeFlds(pguser, "phone", "email")
}

func QueryUserByUname(uname string) (pguser PGUser, err error) {
	return queryUser("uname", uname)
}

func QueryUserByPhone(phone string) (pguser PGUser, err error) {
	return queryUser("phone", phone)
}

func QueryUserByEmail(email string) (pguser PGUser, err error) {
	return queryUser("email", email)
}

func QueryUsersByType(userType int, struFlds ...string) (pgusers []PGUser, err error) {
	err = db.Ping()
	if err != nil {
		seelog.Errorf("QueryUsersByType(%v) open db: %v", userType, err)
		return
	}

	var cols []string
	if len(struFlds) == 0 {
		cols = getStructCols(PGUser{})
	} else {
		cols = convertFldNames2ColNames(struFlds)
	}

	qrySql := "select " + strings.Join(cols, ",") + " from pg_user where user_type=?"
	seelog.Debugf("QueryUsersByType(%v) sql: %v", userType, qrySql)

	rs, err := db.Query(qrySql, userType)
	if err != nil {
		seelog.Errorf("QueryUsersByType(%v) sql: %v err: %v", userType, qrySql, err)
		return
	}

	for rs.Next() {
		if err = rs.Err(); err != nil {
			seelog.Errorf("QueryUsersByType(%v) read rows %v", userType, err)
			return
		}
		pguser := PGUser{}
		if err = Scan2Struct(rs, &pguser); err != nil {
			seelog.Error(err)
			return
		}
		pgusers = append(pgusers, pguser)
	}

	return
}


func queryUser(colName string, val string) (pguser PGUser, err error) {
	err = db.Ping()
	if err != nil {
		seelog.Errorf("queryUser(%v, %v) open db: %v", colName, val, err)
		return
	}

	qrySql := "select " + strings.Join(getStructCols(pguser), ",") + " from pg_user where " + colName + "=?"
	seelog.Debugf("queryUser(%v, %v) sql: %v", colName, val, qrySql)

	rs, err := db.Query(qrySql, val)
	if err != nil {
		seelog.Errorf("queryUser(%v, %v) qry %v %v", colName, val, qrySql, err)
	}

	if rs.Next() {
		if err = rs.Err(); err != nil {
			seelog.Errorf("queryUser(%v, %v) read rows %v", colName, val, err)
			return
		}

		if err = Scan2Struct(rs, &pguser); err != nil {
			seelog.Error(err)
			return
		}
	} else {
		err = pgpub.ErrNotExist
	}

	return
}
