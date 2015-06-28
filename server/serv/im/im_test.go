package im

import (
	"testing"
	"time"
	"fmt"
)

func TestPacket(t *testing.T) {
	msgInfo := MsgInfo{Uid:1, TargetID:2, }
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

func TestDecode(t *testing.T) {
	bytes := []byte{0, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 0, 9, 0, 0, 0, 0, 0, 85, 143, 149, 171, 49, 50, 51, 72, 153, 152, 206}
	msg, err := Decode(bytes)
	if err != nil {
		fmt.Println(err)
	} else {
		fmt.Println(msg)
	}

}

