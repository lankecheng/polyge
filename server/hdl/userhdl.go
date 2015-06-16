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
		http.Error(w, http.StatusText(http.StatusInternalServerError), http.StatusInternalServerError)
		return
	}

	if exists {
		respJson, _ := json.Marshal(pgpub.ResponseMsg{Success: false, Msg: fmt.Sprintf("用户名[%v]已存在", uname)})
		w.Write(respJson)
		return
	}

	pguser := dao.PGUser{Uname: uname}
	pguser.Pwd = req.FormValue("pwd")
	pguser.Phone = req.FormValue("phone")
	pguser.Email = req.FormValue("email")

	gender, err := strconv.Atoi(req.FormValue("gender"))
	pguser.Gender = gender

	language, err := strconv.Atoi(req.FormValue("language"))
	pguser.Language = language

	pguser.Occup = req.FormValue("occup")

	userType, err := strconv.Atoi(req.FormValue("user_type"))
	pguser.UserType = userType

	pguser.Avatar = req.FormValue("avatar")
	pguser.Audio = req.FormValue("audio")

	birth, _ := time.Parse("2006-01-02", req.FormValue("birth"))
	pguser.Birth = birth

	country, err := strconv.Atoi(req.FormValue("country"))
	pguser.Country = country

	province, err := strconv.Atoi(req.FormValue("province"))
	pguser.Province = province

	city, err := strconv.Atoi(req.FormValue("city"))
	pguser.City = city

	pguser.Description = req.FormValue("desc")
	pguser.Interest = req.FormValue("interest")

	if dao.CreateUser(&pguser) != nil {
		http.Error(w, http.StatusText(500), 500)
	} else {
		http.Redirect(w, req, fmt.Sprintf("/login?uname=%v&pwd=%v", pguser.Uname, pguser.Pwd), http.StatusFound)
	}
}

func CheckUserName(w http.ResponseWriter, req *http.Request) {
	req.ParseForm()

	uname := req.FormValue("uname")
	exists, err := dao.IfUserNameExists(uname)
	if err != nil {
		http.Error(w, http.StatusText(http.StatusInternalServerError), http.StatusInternalServerError)
		return
	}

	respJson, _ := json.Marshal(fmt.Sprintf("{Success:%v}", !exists))
	_, err = w.Write(respJson)
	if err != nil {
		seelog.Error(err)
	}
}
