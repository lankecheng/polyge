package dao

import (
	"bytes"
	"reflect"
	"strings"
)

func getTableFromStruct(stru interface{}) string {
	if stru == nil {
		return ""
	}
	//all struct starts with "PG", all table starts with "pg_"
	var struName string
	if struVal, ok := stru.(reflect.Value); ok {
		struName = reflect.TypeOf(struVal.Interface()).Name()
	} else {
		struVal := reflect.ValueOf(stru)
		if struVal.Kind() == reflect.Ptr {
			struVal = struVal.Elem()
		}
		struName = struVal.Type().Name()
	}

	return "pg_" + strings.ToLower(string(struName[2:]))
}

func GetStructPKFld(stru interface{}) string {
	struType := reflect.TypeOf(stru)
	if struType.Kind() == reflect.Ptr {
		struType = struType.Elem()
	}

	return struType.Field(0).Name
}

func convertColName2FldName(dbColName string) string {
	parts := strings.Split(dbColName, "_")
	var fld string
	for _, part := range parts {
		partAry := []rune(strings.ToLower(part))
		partAry[0] = partAry[0] - 32
		fld += string(partAry)
	}
	return fld
}

//excep AUTO_INCREMENT pk
func getStruFldsExceptAutoPK(s interface{}) []string {
	struType := reflect.TypeOf(s)
	if struType.Kind() == reflect.Ptr {
		struType = struType.Elem()
	}
	dbCols := make([]string, 1)
	//if string, consider as not AUTO_INCREMENT
	if struType.Field(0).Type.Kind() == reflect.String {
		dbCols[0] = struType.Field(0).Name
	}

	//the first field is PK
	for i := 1; i < struType.NumField(); i++ {
		dbCols = append(dbCols, struType.Field(i).Name)
	}

	return dbCols
}

func getStructCols(s interface{}) []string {
	beanType := reflect.TypeOf(s)
	if beanType.Kind() == reflect.Ptr {
		beanType = beanType.Elem()
	}

	dbCols := make([]string, beanType.NumField())
	for i := 0; i < beanType.NumField(); i++ {
		dbCols[i] = convertFldName2ColName(beanType.Field(i).Name)
	}

	return dbCols
}

func convertFldName2ColName(fldName string) string {
	buf := bytes.NewBufferString(strings.ToLower(string(fldName[0])))
	for i := 1; i < len(fldName); i++ {
		c := fldName[i]
		if c >= 65 && c <= 90 {
			buf.WriteString("_")
			buf.WriteString(strings.ToLower(string(c)))
		} else {
			buf.WriteString(string(c))
		}
	}

	return buf.String()
}

func convertFldNames2ColNames(fldNames []string) []string {
	colNames := make([]string, len(fldNames))
	for i, fldName := range fldNames {
		colNames[i] = convertFldName2ColName(fldName)
	}
	return colNames
}