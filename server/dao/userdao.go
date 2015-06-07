package dao

import "time"
import (
	"database/sql"
	"github.com/cihub/seelog"
	_ "github.com/go-sql-driver/mysql"

	"fmt"
	"github.com/lankecheng/polyge/server/pgpub"
)

type PGUser struct {
	Uid         uint
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
	Birth       time.Time
	Country     int
	Province    int
	City        int
	CreatedAt   time.Time
	Description string
	Interest    string
}

var db *sql.DB

func init() {
	var err error
	db, err = sql.Open("mysql", "root:123456@tcp(192.168.41.45:3306)/lkc_test?charset=utf8")
	if err != nil {
		seelog.Criticalf("open mysql %v", err)
	}
}

func IfUserNameExists(uname string) (exists bool, err error) {
	err = db.Ping()
	if err != nil {
		seelog.Errorf("uname %v ping mysql %v", uname, err)
		return
	}

	rs, err := db.Query("select 1 from user where uname=?", uname)
	if err != nil {
		seelog.Errorf("uname %v query %v", uname, err)
	}

	if err = rs.Err(); err != nil {
		seelog.Errorf("uname %v read rows %v", uname, err)
	}

	return rs.Next(), err
}

func CreateUser(pguser *PGUser) (err error) {
	err = db.Ping()
	if err != nil {
		seelog.Errorf("user %v ping mysql %v", pguser, err)
		return
	}

	insertSql := "insert into pguser"
	insertSql += "(uname,pwd,phone,email,gender,language,occup,user_type,avatar,audio,"
	insertSql += "birth,country,province,city,created_at,description,interest)"
	insertSql += " values(%v)"
	insertSql = fmt.Sprintf(insertSql, pgpub.RepeatChar("?", ",", 17))
	//	stmt, err := db.Prepare(insertSql)
	//	if err != nil {
	//		seelog.Errorf("user %v prepare insert sql %v %v", user, insertSql, err)
	//	}
	//	defer stmt.Close()
	//	var args []interface{}
	args := make([]interface{}, 17)
	args[0] = pguser.Uname
	args[1] = pguser.Pwd
	args[2] = pguser.Phone
	args[3] = pguser.Email
	args[4] = pguser.Gender
	args[5] = pguser.Language
	args[6] = pguser.Occup
	args[7] = pguser.UserType
	args[8] = pguser.Avatar
	args[9] = pguser.Audio
	args[10] = pguser.Birth
	args[11] = pguser.Country
	args[12] = pguser.Province
	args[13] = pguser.City
	//	args[14] = user.CreatedAt.Unix()
	args[14] = time.Now().Unix()
	args[15] = pguser.Description
	args[16] = pguser.Interest

	_, err = db.Exec(insertSql, args...)
	if err != nil {
		seelog.Errorf("user %v exec sql %v %v", pguser, insertSql, err)
	}

	return
}

func QueryUserByUname(uname string) (pguser *PGUser, err error) {
	err = db.Ping()
	if err != nil {
		seelog.Errorf("uname %v open mysql %v", uname, err)
		return
	}

	qrySql := "select "
	qrySql += "uname,pwd,phone,email,gender,language,occup,user_type,avatar,"
	qrySql += "audio,birth,country,province,city,created_at,description,interest,uid"
	qrySql += " from pguser where uname=?"

	rs, err := db.Query(qrySql, uname)
	if err != nil {
		seelog.Errorf("uname %v qry sql %v %v", uname, qrySql, err)
	}

	if rs.Next() {
		pguser := PGUser{}
		args := make([]interface{}, 18)
		args[0] = &pguser.Uname
		args[1] = &pguser.Pwd
		args[2] = &pguser.Phone
		args[3] = &pguser.Email
		args[4] = &pguser.Gender
		args[5] = &pguser.Language
		args[6] = &pguser.Occup
		args[7] = &pguser.UserType
		args[8] = &pguser.Avatar
		args[9] = &pguser.Audio
		args[10] = &pguser.Birth
		args[11] = &pguser.Country
		args[12] = &pguser.Province
		args[13] = &pguser.City
		//	args[14] = user.CreatedAt.Unix()
		args[14] = &pguser.CreatedAt
		args[15] = &pguser.Description
		args[16] = &pguser.Interest
		args[17] = &pguser.Uid
		rs.Scan(args...)
	}

	if rs.Next() {
		err = fmt.Errorf("uname %d more than one", uname)
	}

	if err = rs.Err(); err != nil {
		seelog.Errorf("uname %v read rows %v", uname, err)
	}

	return
}