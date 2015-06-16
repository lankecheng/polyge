package hdl

import (
	"encoding/json"
	"fmt"
	//	"github.com/cihub/seelog"
	"github.com/lankecheng/polyge/server/dao"
	"github.com/lankecheng/polyge/server/pgpub"
	"github.com/lankecheng/polyge/server/serv"
	"io"
	"net/http"
	"strings"
	"strconv"
)

func Login(w http.ResponseWriter, req *http.Request) {
	req.ParseForm()

	uname := req.FormValue("uname")
	user, err := dao.QueryUserByUname(uname)
	if err != nil {
		http.Error(w, http.StatusText(http.StatusInternalServerError), http.StatusInternalServerError)
		return
	} else if user.Uid == 0 {
		respJson, _ := json.Marshal(pgpub.ResponseMsg{Success: false, Msg: "user not found"})
		w.Write(respJson)
		return
	}

	pwd := req.FormValue("pwd")
	if !strings.EqualFold(pwd, user.Pwd) {
		respJson, _ := json.Marshal(pgpub.ResponseMsg{Success: false, Msg: "password error"})
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

	oauthToken, err := serv.GetOauthToken(user.Uid, clientID)
	if err != nil {
		fmt.Println(err)
		http.Error(w, http.StatusText(http.StatusInternalServerError), http.StatusInternalServerError)
		return
	}

	rs := fmt.Sprintf("{token:%v,uid:%v,uname:%v,gender:%v,user_type:%v}",
		oauthToken, user.Uid, user.Uname, user.Gender, user.UserType)
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

	io.WriteString(w, fmt.Sprintf("{Success:%v}", true))
}

func RefreshToken(w http.ResponseWriter, req *http.Request) {
	req.ParseForm()

	uid, _ := strconv.ParseInt(req.FormValue("uid"), 10, 64)
	clientId, _ := strconv.ParseInt(req.FormValue("client_id"), 10, 64)
	oauthToken := req.FormValue("token")

	newToken, err := serv.RefreshOauthToken(uid, clientId, oauthToken)
	if err != nil {
		http.Error(w, http.StatusText(http.StatusInternalServerError), http.StatusInternalServerError)
	} else {
		respJson, _ := json.Marshal(pgpub.ResponseMsg{Success: true, Msg: newToken})
		w.Write(respJson)
	}
}
