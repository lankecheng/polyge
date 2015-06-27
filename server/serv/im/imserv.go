package im

import (
	"fmt"
	"net/http"
	"time"

	"github.com/gorilla/websocket"
)

const (
// Time allowed to write a message to the peer.
	writeWait = 10 * time.Second

// Time allowed to read the next pong message from the peer.
	pongWait = 60 * time.Second

// Send pings to peer with this period. Must be less than pongWait.
	pingPeriod = (pongWait * 9) / 10

// Maximum message size allowed from peer.
	maxMessageSize = 512

	msgTypeText = 0
	msgTypeVoice = 1
	msgTypePic = 2
)

var upgrader = websocket.Upgrader{
	ReadBufferSize:  1024,
	WriteBufferSize: 1024,
}

var wsConnCache = make(map[int64]*websocket.Conn)

func EstablishConnect(uid int64, w http.ResponseWriter, req *http.Request) error {
	if _, exists := wsConnCache[uid]; exists {
		delete(wsConnCache, uid)
		//TODO:close ws...
	}

	wsConn, err := upgrader.Upgrade(w, req, nil)
	if err != nil {
		return err
	}

	wsConnCache[uid] = wsConn

	go imwork(wsConn)

	return nil
}

func imwork(wsConn *websocket.Conn) {
	wsConn.SetReadLimit(maxMessageSize)
	wsConn.SetReadDeadline(time.Now().Add(pongWait))
	wsConn.SetPongHandler(func(string) error { wsConn.SetReadDeadline(time.Now().Add(pongWait)); return nil })
	for {
		_, msgBytes, err := wsConn.ReadMessage()
		if err != nil {
			fmt.Println(err)
			break
		}
//		fmt.Println("receive:", msgBytes)
		go procMsg(msgBytes)
	}
}

func procMsg(msgBytes []byte) {
	msgInfo, err := Decode(msgBytes)
	if err != nil {
		fmt.Println(err)
		return
	}

	wsConn, exists := wsConnCache[msgInfo.TargetID]
	if !exists {
		//TODO:store in db
		return
	}

	wsConn.SetWriteDeadline(time.Now().Add(writeWait))
	if err := wsConn.WriteMessage(websocket.BinaryMessage, msgBytes); err != nil {
		fmt.Println(err)
	}
}