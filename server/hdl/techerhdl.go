package hdl

import (
	"github.com/lankecheng/polyge/server/serv"
	"net/http"
	"github.com/lankecheng/polyge/server/pgpub"
)

func ShowTeachers(w http.ResponseWriter, req *http.Request) {
	req.ParseForm()

	ok, err := serv.CheckToken(req.FormValue("token"))
	if err != nil {
		http.Error(w, http.StatusText(http.StatusInternalServerError), http.StatusInternalServerError)
		return
	} else if !ok {
		http.Error(w, http.StatusText(http.StatusForbidden), http.StatusForbidden)
		return
	}

	teachers, err := serv.ShowTeachers()
	if err != nil {
		http.Error(w, http.StatusText(http.StatusInternalServerError), http.StatusInternalServerError)
		return
	}

	w.Write(pgpub.CreateQueryJson(teachers))
}