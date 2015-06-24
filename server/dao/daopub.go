package dao

import (
	"database/sql"
	"errors"
	"fmt"
	"github.com/cihub/seelog"
	_ "github.com/go-sql-driver/mysql"
	"reflect"
	"time"
	"bytes"
	"github.com/lankecheng/polyge/server/pgpub"
)

var db *sql.DB

func init() {
	var err error
	db, err = sql.Open("mysql", "root:root@tcp(120.26.212.134:3306)/polyge?charset=utf8&parseTime=true")
	if err != nil {
		seelog.Criticalf("open mysql %v", err)
	}
}

func DBCreateIncludeFlds(stru interface{}, inclStruFlds ...string) error {
	return dbCreate(stru, true, inclStruFlds...)
}

func DBCreateExcludeFlds(stru interface{}, exclStruFlds ...string) (err error) {
	return dbCreate(stru, false, exclStruFlds...)
}

func dbCreate(stru interface{}, include bool, flds ...string) error {
	//ensure struct
	struVal := reflect.ValueOf(stru)
	if struVal.Kind() == reflect.Ptr {
		struVal = struVal.Elem()
	}
	if struVal.Kind() != reflect.Struct {
		return errors.New("DBCreate arg stru isn't struct!")
	}
	//get effective fields
	var effFlds []string
	if include && len(flds) == 0 {
		effFlds = getStructCols(stru)
	} else if !include && len(flds) > 0 {
		dbCols := make([]string, 0)
		struFlds := getStructFldsExceptPK(stru)
		for _, struFld := range struFlds {
			if pgpub.SearchStringArray(flds, struFld) == -1 {
				dbCols = append(dbCols, convertFldName2ColName(struFld))
			}
		}
	} else {
		effFlds = flds
	}
	//assemble insert sql
	insertSql := bytes.NewBufferString("insert into ")
	insertSql.WriteString(getTableFromStruct(stru))
	insertSql.WriteString("(")
	for i, effFld := range effFlds {
		insertSql.WriteString(convertFldName2ColName(effFld))
		if i < len(effFlds) - 1 {
			insertSql.WriteString(",")
		}
	}
	insertSql.WriteString(") values(")
	insertSql.WriteString(pgpub.RepeatChar("?", ",", len(effFlds)))
	insertSql.WriteString(")")
	//assemble sql params
	args := make([]interface{}, len(effFlds))
	struType := struVal.Type()
	for i, effFld := range effFlds {
		struFld, exsits := struType.FieldByName(effFld)
		if !exsits {
			return fmt.Errorf("DBCreate struct field [%v] not exists!", effFld)
		}

		fldVal := struVal.FieldByName(effFld)
		if struFld.Tag == "" {
			args[i] = fldVal.Interface()
		} else if timeVal, ok:= fldVal.Interface().(time.Time); ok {
			//FIXME: more type convert
			args[i] = timeVal.Unix()
		}
	}
	//db operate
	err := db.Ping()
	if err != nil {
		seelog.Errorf("insert %v ping mysql %v", stru, err)
		return err
	}

	execSql := insertSql.String()
	_, err = db.Exec(execSql, args...)
	if err != nil {
		seelog.Errorf("insert %v exec sql %v %v", stru, execSql, err)
	}

	return err
}


func DBUpdateIncludeFlds(stru interface{}, inclFlds ...string) error {
	return dbUpdate(stru, true, inclFlds...)
}

func DBUpdateExcludeFlds(stru interface{}, exclFlds ...string) (err error) {
	return dbUpdate(stru, false, exclFlds...)
}

func dbUpdate(stru interface{}, include bool, flds ...string) error {
	//ensure struct
	struVal := reflect.ValueOf(stru).Elem()
	if struVal.Kind() != reflect.Struct {
		return errors.New("DBCreate arg stru isn't struct!")
	}
	//get effective fields
	effFlds := make([]string, 0)
	if include && len(flds) == 0 {
		effFlds = getStructFldsExceptPK(stru)
	} else if !include {
		struFlds := getStructFldsExceptPK(stru)
		for _, struFld := range struFlds {
			if pgpub.SearchStringArray(flds, struFld) == -1 {
				effFlds = append(effFlds, struFld)
			}
		}
	}
	//assemble insert sql
	updateSql := bytes.NewBufferString("update ")
	updateSql.WriteString(getTableFromStruct(stru))
	updateSql.WriteString(" set ")
	for i, effFld := range effFlds {
		updateSql.WriteString(effFld)
		updateSql.WriteString("=?")
		if i < len(effFlds) - 1 {
			updateSql.WriteString(",")
		}
	}
	updateSql.WriteString(" where ")
	pkFld := GetStructPKFld(stru)
	updateSql.WriteString(convertFldName2ColName(pkFld))
	updateSql.WriteString("=?")
	//assemble sql params
	args := make([]interface{}, len(effFlds) + 1)
	struType := reflect.TypeOf(stru)
	for i, effFld := range effFlds {
		struFld, exsits := struType.FieldByName(effFld)
		if !exsits {
			return fmt.Errorf("DBCreate struct field [%v] not exists!", effFld)
		}

		fldVal := struVal.FieldByName(effFld)
		if struFld.Tag == "" {
			args[i] = fldVal.Interface()
		} else if timeVal, ok:= fldVal.Interface().(time.Time); ok {
			//FIXME: more type convert
			args[i] = timeVal.Unix()
		}
	}
	args[len(args) - 1] = struVal.FieldByName(pkFld).Interface()
	//db operate
	err := db.Ping()
	if err != nil {
		seelog.Errorf("user %v ping mysql %v", stru, err)
		return err
	}

	execSql := updateSql.String()
	_, err = db.Exec(execSql, args...)
	if err != nil {
		seelog.Errorf("update %v exec sql %v %v", stru, execSql, err)
	}

	return err
}