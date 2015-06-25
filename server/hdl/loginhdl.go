package hdl

import (
	"fmt"
	//	"github.com/cihub/seelog"
	"github.com/lankecheng/polyge/server/pgpub"
	"github.com/lankecheng/polyge/server/serv"
	"io"
	"net/http"
	"strconv"
)

func Login(w http.ResponseWriter, req *http.Request) {
	req.ParseForm()

	uname := req.FormValue("user_name")
	phone := req.FormValue("phone")
	email := req.FormValue("phone")
	pwd := req.FormValue("pwd")

	pguser, err := serv.Login(uname, phone, email, pwd)
	if err == pgpub.ErrNotExist || err == pgpub.ErrPwdWrong {
		w.Write(pgpub.CreateDoJson(false, err.Error()))
		return
	} else if err != nil {
		http.Error(w, http.StatusText(http.StatusInternalServerError), http.StatusInternalServerError)
		return
	}

	oauthToken, err := serv.GetOauthToken(pguser.Uid, req.FormValue("client_id"))
	if err != nil {
		http.Error(w, http.StatusText(http.StatusInternalServerError), http.StatusInternalServerError)
		return
	}

	rs := make(map[string]interface{})
	rs["token"] = oauthToken
	rs["uid"] = pguser.Uid
	rs["uname"] = pguser.Uname
	rs["gender"] = pguser.Gender
	rs["user_type"] = pguser.UserType
	rs["avatar"] = pguser.Avatar

	w.Write(pgpub.CreateComplexJson(true, "", rs))
}

func Logout(w http.ResponseWriter, req *http.Request) {
	//TODO:暂时不用做什么,客户端把TOKEN删掉即可
	//	req.ParseForm()

	//	oauthToken := req.FormValue("token")
	//	err := dao.DeleteToken(oauthToken)
	//	if err != nil {
	//		http.Error(w, http.StatusText(500), 500)
	//		return
	//	}

	io.WriteString(w, fmt.Sprintf("{success:%v}", true))
}

func RefreshToken(w http.ResponseWriter, req *http.Request) {
	req.ParseForm()

	uid, _ := strconv.Atoi(req.FormValue("uid"))
	clientId := req.FormValue("client_id")
	oauthToken := req.FormValue("token")

	newToken, err := serv.RefreshOauthToken(uid, clientId, oauthToken)
	if err != nil {
		http.Error(w, http.StatusText(http.StatusInternalServerError), http.StatusInternalServerError)
	} else {
		w.Write(pgpub.CreateComplexJson(true, "", newToken))
	}
}
