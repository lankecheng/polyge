package hdl

import (
	"github.com/cihub/seelog"
	"github.com/lankecheng/polyge/server/serv"
	"net/http"
	"strconv"
	"github.com/lankecheng/polyge/server/pgpub"
)

func Register(w http.ResponseWriter, req *http.Request) {
	req.ParseForm()

	uname := req.FormValue("user_name")
	phone := req.FormValue("phone")
	email := req.FormValue("email")
	pwd := req.FormValue("pwd")
	userType, _ := strconv.Atoi(req.FormValue("user_type"))

	success, err := serv.Register(uname, phone, email, pwd, userType)
	if err == pgpub.ErrUserExist {
		w.Write(pgpub.CreateDoJson(false, "user_name/phone/email has already existed!"))
		return
	} else if err != nil {
		seelog.Errorf("error register %v", err)
		http.Error(w, http.StatusText(http.StatusInternalServerError), http.StatusInternalServerError)
		return
	}

	w.Write(pgpub.CreateDoJson(success, ""))
}

func CheckUserExists(w http.ResponseWriter, req *http.Request) {
	req.ParseForm()

	uname := req.FormValue("user_name")
	phone := req.FormValue("phone")
	email := req.FormValue("email")

	exists, err := serv.CheckUserExists(uname, phone, email)
	if err != nil {
		seelog.Errorf("error register %v", err)
		http.Error(w, http.StatusText(http.StatusInternalServerError), http.StatusInternalServerError)
	} else {
		w.Write(pgpub.CreateQueryJson(exists))
	}
}