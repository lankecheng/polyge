package im

import (
	"testing"
	"time"
	"fmt"
)

func TestPacket(t *testing.T) {
	msgInfo := MsgInfo{Uid:1,TargetID:2,}
	msgInfo.CreatedAt = time.Now()
	msgInfo.Data = []byte("abc")

	bytes, err := Encode(msgInfo)
	if err != nil {
		fmt.Println(err)
	}

	msgInfo2, err := Decode(bytes)
	if err != nil {
		fmt.Println(err)
	}

	fmt.Println(msgInfo2)
}
