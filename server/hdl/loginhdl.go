package hdl

import (
	"encoding/json"
	"fmt"
//	"github.com/cihub/seelog"
	"github.com/lankecheng/polyge/server/pgpub"
	"github.com/lankecheng/polyge/server/dao"
	"github.com/lankecheng/polyge/server/hdl"
	"io"
	"net/http"
	"time"
	"github.com/lankecheng/polyge/server/serv"
)

func Login(w http.ResponseWriter, req *http.Request) {
	req.ParseForm()

	uname := req.FormValue("uname")
	user, err := dao.QueryUserByUname(uname)
	if err != nil {
		http.Error(w, http.StatusText(500), 500)
		return
	} else if user == nil {
		respJson, _ := json.Marshal(pgpub.ResponseMsg{Success: false, Msg: "user not found"})
		w.Write(respJson)
	}

	token := dao.Token{
		OauthToken: serv.GenOauthToken(user.Uid),
		ClientID: req.FormValue("client_id"),
		Expires:  time.Now().AddDate(3, 0, 0).Unix(),
		Uid:      user.Uid,
	}

	err = dao.CreateToken(&token)
	if err != nil {
		http.Error(w, http.StatusText(500), 500)
		return
	}

	rs := fmt.Sprintf("{token:%v,uid:%v,uname:%v,gender:%v,user_type:%v}",
		token.OauthToken, user.Uid, user.Uname, user.Gender, user.UserType)
	respJson, _ := json.Marshal(pgpub.ResponseMsg{Success: true, Result: rs})
	w.Write(respJson)
}

func Logout(w http.ResponseWriter, req *http.Request) {
	req.ParseForm()

	oauthToken := req.FormValue("token")
	err := dao.DeleteToken(oauthToken)
	if err != nil {
		http.Error(w, http.StatusText(500), 500)
		return
	}

	io.WriteString(w, fmt.Sprintf("{Success:%v}", true))
}