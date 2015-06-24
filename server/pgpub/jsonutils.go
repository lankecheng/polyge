package pgpub
import (
	"reflect"
	"encoding/json"
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
	retMap := map[string]interface{}{"success" : success, "msg" : msg}
	retJson, _ := json.Marshal(retMap)
	return retJson
}

//查询操作
func CreateQueryJson(rs interface{}) []byte {
	retMap := map[string]interface{}{"result" : rs}
	retJson, _ := json.Marshal(retMap)
	return retJson
}