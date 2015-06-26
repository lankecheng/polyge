package main

import (
	"fmt"
	"io"
	"net/http"
	"github.com/cihub/seelog"
	"os"

	"github.com/lankecheng/polyge/server/hdl"
	"github.com/lankecheng/polyge/server/pgpub"
)

func init() {
	var path string
	if exists, _:= pgpub.IsFileExist("/Users/lankc/dev/projects/src/github.com/lankecheng/polyge/server/conf/seelog.xml"); exists {
		path = "/Users/lankc/dev/projects/src/github.com/lankecheng/polyge/server/conf/seelog.xml"
	} else {
		path = "/home/lankc/projects/src/github.com/lankecheng/polyge/server/conf/seelog.xml"
	}

	logger, err := seelog.LoggerFromConfigAsFile(path)
	if err == nil {
		seelog.ReplaceLogger(logger)
		seelog.Info("start server...")
		seelog.Info("read log config")
	} else {
		fmt.Printf("Failed to read log cfg file, %v", err.Error())
		os.Exit(2)
	}
}

func HelloServer(w http.ResponseWriter, req *http.Request) {
	io.WriteString(w, "Hello Polyge!")
}

func main() {
	defer func() {
		if err := recover(); err != nil {
			fmt.Println("Recovered ", err)
		}
	}()
	http.HandleFunc("/hello", HelloServer)
	http.HandleFunc("/register", hdl.Register)
	http.HandleFunc("/check_user_exists", hdl.CheckUserExists)
	http.HandleFunc("/login", hdl.Login)
	http.HandleFunc("/logout", hdl.Logout)
	http.HandleFunc("/refresh_token", hdl.RefreshToken)
	http.HandleFunc("/show_teachers", hdl.ShowTeachers)
	http.HandleFunc("/wsconn", hdl.WebsocketConnect)
	err := http.ListenAndServe(":5918", nil)
	if err != nil {
		fmt.Println(err)
	}
}