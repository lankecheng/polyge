package pgpub
import "errors"

var (
	ErrUserExist      = errors.New("file already exists")
)

type ResponseMsg struct {
	Success bool        `json:"success"`
	Msg     string      `json:"msg"`
	Result  interface{} `json:"rs"`
}
