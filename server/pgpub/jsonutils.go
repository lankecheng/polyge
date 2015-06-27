package pgpub

import (
	"encoding/json"
	"reflect"
	"github.com/cihub/seelog"
	"fmt"
	"strings"
)

func ConvertStruct2Map(stru interface{}, flds ...string) map[string]interface{} {
	struVal := reflect.ValueOf(stru)
	if struVal.Kind() == reflect.Ptr {
		struVal = struVal.Elem()
	}
	struType := struVal.Type()

	retMap := make(map[string]interface{})
	for i := 0; i < struType.NumField(); i++ {
		fldName := struType.Field(i).Name
		if SearchStringArray(flds, fldName) != -1 {
			retMap[strings.ToLower(fldName)] = struVal.FieldByName(fldName).Interface()
		}
	}
	return retMap
}

//对后台资源进行操作
func CreateDoJson(success bool, msg string) []byte {
	retMap := map[string]interface{}{"success": success, "msg": msg}
	retJson, err := json.Marshal(retMap)
	if err != nil {
		seelog.Warn(fmt.Sprintf("CreateDoJson : %v", err))
	}
	return retJson
}

//查询操作
func CreateQueryJson(rs interface{}) []byte {
	retMap := map[string]interface{}{"result": rs}
	retJson, err := json.Marshal(retMap)
	if err != nil {
		seelog.Warn(fmt.Sprintf("CreateQueryJson : %v", err))
	}
	return retJson
}

func CreateComplexJson(success bool, msg string, rs interface{}) []byte {
	retMap := map[string]interface{}{"success": success, "msg": msg, "result": rs}
	retJson, err := json.Marshal(retMap)
	if err != nil {
		seelog.Warn(fmt.Sprintf("CreateComplexJson : %v", err))
	}
	return retJson
}
