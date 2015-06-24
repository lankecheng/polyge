package pgpub

import (
	"encoding/json"
	"reflect"
	"github.com/cihub/seelog"
	"fmt"
)

func ConvertStruct2Map(stru *interface{}) map[string]interface{} {
	retMap := make(map[string]interface{})
	struType := reflect.TypeOf(stru)
	struVal := reflect.ValueOf(stru)
	for i := 0; i < struType.NumField(); i++ {
		fldName := struType.Field(i).Name
		retMap[fldName] = struVal.FieldByName(fldName).Interface()
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
