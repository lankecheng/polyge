package pgpub

type ResponseMsg struct {
	Success bool        `json:"success"`
	Msg     string      `json:"msg"`
	Result  interface{} `json:"rs"`
}
