package dao

import (
	"database/sql"
	"errors"
	"fmt"
	"github.com/cihub/seelog"
	_ "github.com/go-sql-driver/mysql"
	"reflect"
	"strings"
	"time"
	"strconv"
	"bytes"
)

var db *sql.DB

func init() {
	var err error
	db, err = sql.Open("mysql", "root:123456@tcp(192.168.41.45:3306)/lkc_test?charset=utf8&parseTime=true")
	if err != nil {
		seelog.Criticalf("open mysql %v", err)
	}
}

//implements databas/sql.Scanner
type ReflectScanner struct {
	Value *reflect.Value
}

func (scanner *ReflectScanner) Scan(src interface{}) error {
	if src == nil {
		return nil
	}

	if timeVal, ok:= src.(time.Time); ok {
		scanner.Value.Set(reflect.ValueOf(timeVal))
	} else if bytes, ok := src.([]byte); ok {
		timemills, err := strconv.ParseInt(string(bytes),10, 64)
		if err != nil {
			return fmt.Errorf("RflValScanner error getting timemils %v", err)
		}
		scanner.Value.Set(reflect.ValueOf(time.Unix(timemills, 0)))
	} else if timemills, ok := src.(int64); ok {
		scanner.Value.Set(reflect.ValueOf(time.Unix(timemills, 0)))
	} else {
		panic(fmt.Sprintf("RflValScanner %v not support", scanner.Value.Type().String()))
	}

	return nil
}

//implements databas/sql.Scanner, just for test
type TypeTestScanner struct {
}

func (scanner *TypeTestScanner) Scan(src interface{}) error {
	val := src
	switch s := src.(type) {
		case []byte:
		val = string(s)
	}
	fmt.Printf("Type Scan %v:%v\n", reflect.TypeOf(src), val)
	return nil
}

func Scan2Bean(rows *sql.Rows, bean interface{}) error {
	beanVal := reflect.ValueOf(bean)
	if beanVal.Kind() != reflect.Ptr {
		return errors.New("Scan2Bean bean not a pointer")
	}
	beanVal = beanVal.Elem()

	cols, err := rows.Columns()
	if err != nil {
		return err
	}

	dest := make([]interface{}, len(cols))
	for i, col := range cols {
		fldName := convertDBColName2PropName(col)
		fldVal := beanVal.FieldByName(fldName)
		if fldVal.Kind() != reflect.Struct && fldVal.Kind() != reflect.Ptr {
			dest[i] = fldVal.Addr().Interface()
		} else if fldVal.Type().String() == "time.Time" {
			dest[i] = &ReflectScanner{Value: &fldVal}
//			dest[i] = &TypeTestScanner{}
		} else {
			panic(fmt.Sprintf("Scan2Bean %v %v not support", fldName, fldVal.Type().String()))
		}
	}

	return rows.Scan(dest...)
}

func convertDBColName2PropName(dbColName string) string {
	parts := strings.Split(dbColName, "_")
	var fld string
	for _, part := range parts {
		partAry := []rune(strings.ToLower(part))
		partAry[0] = partAry[0] - 32
		fld += string(partAry)
	}
	return fld
}

func getDBColNamesFromBean(bean interface{}) []string{
	beanType := reflect.TypeOf(bean)
	if beanType.Kind() == reflect.Ptr {
		beanType = beanType.Elem()
	}

	dbCols := make([]string, beanType.NumField())
	for i := 0; i < beanType.NumField(); i++ {
		dbCols[i] = convertPropName2DBColName(beanType.Field(i).Name)
	}

	return dbCols
}

func convertPropName2DBColName(propName string) string {
	buf := bytes.NewBufferString(strings.ToLower(string(propName[0])))
	for i := 1; i < len(propName); i++ {
		c := propName[i]
		if c >= 65 && c <= 90 {
			buf.WriteString("_")
			buf.WriteString(strings.ToLower(string(c)))
		} else {
			buf.WriteString(string(c))
		}
	}

	return buf.String()
}
