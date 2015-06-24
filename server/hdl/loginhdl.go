package hdl

import (
	"encoding/json"
	"fmt"
	//	"github.com/cihub/seelog"
	"github.com/lankecheng/polyge/server/pgpub"
	"github.com/lankecheng/polyge/server/serv"
	"io"
	"net/http"
	"strings"
	"strconv"
)

func Login(w http.ResponseWriter, req *http.Request) {
	req.ParseForm()

	uname := req.FormValue("user_name")
	phone := req.FormValue("phone")
	email := req.FormValue("phone")

	pguser, err := serv.QueryUser(uname, phone, email)
	if err != nil {
		http.Error(w, http.StatusText(http.StatusInternalServerError), http.StatusInternalServerError)
		return
	} else if pguser.Uid == 0 {
		respJson, _ := json.Marshal(pgpub.ResponseMsg{Success: false, Msg: "user not found", Result: ""})
		w.Write(respJson)
		return
	}

	pwd := req.FormValue("pwd")
	if !strings.EqualFold(pwd, pguser.Pwd) {
		respJson, _ := json.Marshal(pgpub.ResponseMsg{Success: false, Msg: "password error", Result: ""})
		w.Write(respJson)
		return
	}

	var clientID int
	if req.FormValue("client_id") != "" {
		clientID, err = strconv.Atoi(req.FormValue("client_id"))
		if err != nil {
			http.Error(w, http.StatusText(http.StatusInternalServerError), http.StatusInternalServerError)
			return
		}
	}

	oauthToken, err := serv.GetOauthToken(pguser.Uid, clientID)
	if err != nil {
		fmt.Println(err)
		http.Error(w, http.StatusText(http.StatusInternalServerError), http.StatusInternalServerError)
		return
	}

	rs := make(map[string]interface{})
	rs["token"] = oauthToken
	rs["uid"] = pguser.Uid
	rs["uname"] = pguser.Uname
	rs["gender"] = pguser.Gender
	rs["user_type"] = pguser.UserType
	respJson, _ := json.Marshal(pgpub.ResponseMsg{Success: true, Result: rs})
	w.Write(respJson)
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
	clientId, _ := strconv.Atoi(req.FormValue("client_id"))
	oauthToken := req.FormValue("token")

	newToken, err := serv.RefreshOauthToken(uid, clientId, oauthToken)
	if err != nil {
		http.Error(w, http.StatusText(http.StatusInternalServerError), http.StatusInternalServerError)
	} else {
		respJson, _ := json.Marshal(pgpub.ResponseMsg{Success: true, Result: newToken})
		w.Write(respJson)
	}
}
