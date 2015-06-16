package main

import (
	"fmt"
	"io"
	"net/http"
	"github.com/cihub/seelog"
	"os"

	"github.com/lankecheng/polyge/server/hdl"
)

func init() {
	logger, err := seelog.LoggerFromConfigAsFile("/Users/lankc/dev/projects/src/github.com/lankecheng/polyge/server/seelog.xml")
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
	http.HandleFunc("/check_uname", hdl.CheckUserName)
	http.HandleFunc("/login", hdl.Login)
	http.HandleFunc("/logout", hdl.Logout)
	http.HandleFunc("/refresh_token", hdl.RefreshToken)
	http.HandleFunc("/wsconn", hdl.WebsocketConnect)
	err := http.ListenAndServe(":5918", nil)
	if err != nil {
		fmt.Println(err)
	}
}