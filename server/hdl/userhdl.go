package hdl

import (
	"encoding/json"
	"fmt"
	"github.com/cihub/seelog"
	"github.com/lankecheng/polyge/server/pgpub"
	"net/http"
	"strconv"
	"time"
	"github.com/lankecheng/polyge/server/dao"
)

func Register(w http.ResponseWriter, req *http.Request) {
	req.ParseForm()

	uname := req.FormValue("uname")
	exists, err := dao.IfUserNameExists(uname)
	if err != nil {
		http.Error(w, http.StatusText(500), 500)
		return
	}

	if exists {
		respJson, _ := json.Marshal(pgpub.ResponseMsg{Success: false, Msg: fmt.Sprintf("用户名[%v]已存在", uname)})
		w.Write(respJson)
		return
	}

	user := dao.PGUser{Uname: uname}
	user.Pwd = req.FormValue("pwd")
	user.Phone = req.FormValue("phone")
	user.Email = req.FormValue("email")

	gender, err := strconv.Atoi(req.FormValue("gender"))
	user.Gender = gender

	language, err := strconv.Atoi(req.FormValue("language"))
	user.Language = language

	user.Occup = req.FormValue("occup")

	userType, err := strconv.Atoi(req.FormValue("user_type"))
	user.UserType = userType

	user.Avatar = req.FormValue("avatar")
	user.Audio = req.FormValue("audio")

	birth, _ := time.Parse("2006-01-02", req.FormValue("birth"))
	user.Birth = birth

	country, err := strconv.Atoi(req.FormValue("country"))
	user.Country = country

	province, err := strconv.Atoi(req.FormValue("province"))
	user.Province = province

	city, err := strconv.Atoi(req.FormValue("city"))
	user.City = city

	user.Description = req.FormValue("desc")
	user.Interest = req.FormValue("interest")
}

func CheckUserName(w http.ResponseWriter, req *http.Request) {
	req.ParseForm()

	uname := req.FormValue("uname")
	exists, err := dao.IfUserNameExists(uname)
	if err != nil {
		http.Error(w, http.StatusText(500), 500)
		return
	}

	respJson, _ := json.Marshal(fmt.Sprintf("{Success:%v}", !exists))
	_, err = w.Write(respJson)
	if err != nil {
		seelog.Error(err)
	}
}
