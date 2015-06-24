package dao

import (
	"fmt"
	"reflect"
	"time"
	"errors"
	"database/sql"
	"strconv"
)

//implements databas/sql.Scanner
type ReflectScanner struct {
	Value *reflect.Value
}

func (scanner *ReflectScanner) Scan(src interface{}) error {
	if src == nil {
		return nil
	}

	if timeVal, ok := src.(time.Time); ok {
		scanner.Value.Set(reflect.ValueOf(timeVal))
	} else if bytes, ok := src.([]byte); ok {
		timemills, err := strconv.ParseInt(string(bytes), 10, 64)
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

func Scan2Struct(rows *sql.Rows, stru interface{}) error {
	beanVal := reflect.ValueOf(stru)
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
		fldName := convertColName2FldName(col)
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
