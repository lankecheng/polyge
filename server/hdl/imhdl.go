package hdl

import (
	//	"github.com/cihub/seelog"
	"github.com/lankecheng/polyge/server/dao"
	"net/http"
	"github.com/lankecheng/polyge/server/serv/im"
)

func WebsocketConnect(w http.ResponseWriter, req *http.Request) {
	req.ParseForm()

	oauthToken := req.FormValue("token")
	exists, err := dao.IfTokenExists(oauthToken)
	if err != nil {
		http.Error(w, http.StatusText(http.StatusInternalServerError), http.StatusInternalServerError)
		return
	} else if !exists {
		http.Error(w, http.StatusText(http.StatusForbidden), http.StatusForbidden)
		return
	}

	err = im.EstablishConnect(w, req)
}