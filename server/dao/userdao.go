package dao

import (
	"fmt"
	"github.com/cihub/seelog"
	"github.com/lankecheng/polyge/server/pgpub"
	"time"
	"strings"
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
	Birth       time.Time
	Country     int
	Province    int
	City        int
	CreatedAt   time.Time
	Description string
	Interest    string
}

func IfUserNameExists(uname string) (exists bool, err error) {
	err = db.Ping()
	if err != nil {
		seelog.Errorf("uname %v ping mysql %v", uname, err)
		return
	}

	rs, err := db.Query("select 1 from pguser where uname=?", uname)
	if err != nil {
		seelog.Errorf("uname %v query %v", uname, err)
		return
	}
	exists = rs.Next()

	if err = rs.Err(); err != nil {
		seelog.Errorf("uname %v read rows %v", uname, err)
	}

	return
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
	args[14] = time.Now().Unix()
	args[15] = pguser.Description
	args[16] = pguser.Interest

	_, err = db.Exec(insertSql, args...)
	if err != nil {
		seelog.Errorf("user %v exec sql %v %v", pguser, insertSql, err)
	}

	return
}

func QueryUserByUname(uname string) (pguser PGUser, err error) {
	err = db.Ping()
	if err != nil {
		seelog.Errorf("uname %v open mysql %v", uname, err)
		return
	}

	qrySql := "select " + strings.Join(getDBColNamesFromBean(pguser), ",") + " from pguser where uname=?"
	seelog.Debugf("QueryUserByUname(%v) sql: %v", uname, qrySql)

	rs, err := db.Query(qrySql, uname)
	if err != nil {
		seelog.Errorf("uname %v qry sql %v %v", uname, qrySql, err)
	}

	if rs.Next() {
		if err = Scan2Bean(rs, &pguser); err != nil {
			fmt.Println(err)
			return
		}
	}

	if rs.Next() {
		err = fmt.Errorf("uname %d more than one", uname)
	}

	if err = rs.Err(); err != nil {
		seelog.Errorf("uname %v read rows %v", uname, err)
	}

	return
}

//func QueryTest() error {
//	t_uname := "lankc"
//	err := db.Ping()
//	if err != nil {
//		seelog.Errorf("uname %v open mysql %v", t_uname, err)
//		return err
//	}
//
//	qrySql := "select uname,birth,created_at from pguser"
////	qrySql := "select uname,birth,created_at from pguser where uid=?"
////	qrySql := "select * from pguser where uid=?"
////	qrySql := "select pid,f_tinyint,f_smallint,f_int,f_float,f_double,f_decimal,f_char,f_varchar" +
////				",f_date,f_datetime,f_timestamp,f_year from pg_test"
//
//	rs, err := db.Query(qrySql)
//	if err != nil {
//		seelog.Errorf("uname %v qry sql %v %v", t_uname, qrySql, err)
//	}
//
//	if rs.Next() {
//		if err = rs.Err(); err != nil {
//			seelog.Errorf("uname %v read rows %v", t_uname, err)
//		}
//		typScan := TypeTestScanner{}
//		cols, _ := rs.Columns()
//		dest := make([]interface{}, len(cols))
//		for i,_ := range dest {
//			dest[i] = &typScan
//		}
//
//		if err = rs.Scan(dest...); err != nil {
//			fmt.Println(err)
//			return err
//		}
//	}
//
//	return err
//}