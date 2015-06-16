package im
import (
	"time"
	"bytes"
	"encoding/binary"
	"hash/crc32"
	"fmt"
)

type MsgInfo struct {
	Uid int64
	TargetID int64
	MsgID int64
	CreatedAt time.Time
	Data []byte
}

func Encode(msgInfo MsgInfo) ([]byte, error) {
	buf := bytes.NewBuffer(nil)

	uidBytes := make([]byte, 8)
	binary.BigEndian.PutUint64(uidBytes, uint64(msgInfo.Uid))
	_, err := buf.Write(uidBytes)

	tgtIDBytes := make([]byte, 8)
	binary.BigEndian.PutUint64(tgtIDBytes, uint64(msgInfo.TargetID))
	_, err = buf.Write(tgtIDBytes)

	msgIDBytes := make([]byte, 8)
	binary.BigEndian.PutUint64(msgIDBytes, uint64(msgInfo.MsgID))
	_, err = buf.Write(msgIDBytes)

	timeBytes := make([]byte, 8)
	binary.BigEndian.PutUint64(timeBytes, uint64(msgInfo.CreatedAt.Unix()))
	_, err = buf.Write(timeBytes)

	_, err = buf.Write(msgInfo.Data)

	chksum := crc32.ChecksumIEEE(buf.Bytes())
	chksumBytes := make([]byte, 4)
	binary.BigEndian.PutUint32(chksumBytes, chksum)
	_, err = buf.Write(chksumBytes)

	return buf.Bytes(), err
}

func Decode(bytes []byte) (MsgInfo, error) {
	msgInfo := MsgInfo{}

	chksum := binary.BigEndian.Uint32(bytes[len(bytes) - 4:])
	msgInfoChksum := crc32.ChecksumIEEE(bytes[0:len(bytes) - 4])
	if chksum != msgInfoChksum {
		return msgInfo, fmt.Errorf("checksum %v calc %v", chksum, msgInfoChksum)
	}

	start := 0
	fldLen := 8
	msgInfo.Uid = int64(binary.BigEndian.Uint64(bytes[start:start+fldLen]))

	start += fldLen
	fldLen = 8
	msgInfo.TargetID = int64(binary.BigEndian.Uint64(bytes[start:start+fldLen]))

	start += fldLen
	fldLen = 8
	msgInfo.MsgID = int64(binary.BigEndian.Uint64(bytes[start:start+fldLen]))

	start += fldLen
	fldLen = 8
	timemillis := int64(binary.BigEndian.Uint64(bytes[start:start+fldLen]))
	msgInfo.CreatedAt = time.Unix(timemillis, 0)

	start += fldLen
	msgInfo.Data = bytes[start:len(bytes) - 4]

	return msgInfo, nil
}
