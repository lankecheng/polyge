package serv

import (

	"time"
	"strconv"
	"github.com/lankecheng/polyge/server/pgpub"
	"github.com/lankecheng/polyge/server/dao"
	"math/rand"
)

//时间戳+随机数+用户ID
func GenOauthToken(uid int) (token string) {
	now := time.Now()
	token = strconv.Itoa(now.Unix())
	rand.Seed(now.UnixNano())
	token += strconv.Itoa(rand.Int())
	token += strconv.Itoa(uid)

	if len(token) < 32 {
		token += pgpub.RepeatChar("0", "", 32-len(token))
	} else if len(token) > 32 {
		token = token[0:32]
	}

	return token
}

func CheckOauthToken(oauthToken string) (ok bool, err error) {
	token, err := dao.QueryToken(oauthToken)
	if err != nil {
		return
	}

	ok = time.Now().Unix() <= token.Expires
	return
}