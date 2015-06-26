package serv

import (
	"github.com/lankecheng/polyge/server/dao"
	"github.com/lankecheng/polyge/server/pgpub"
	"math/rand"
	"strconv"
	"time"
	"fmt"
	"strings"
	"github.com/cihub/seelog"
)

func GetOauthToken(uid int, clientID string) (oauthToken string, err error) {
	token, err := dao.QueryTokenByUidClientID(uid, clientID)
	if err != nil && err != pgpub.ErrNotExist {
		return
	}

	if err != pgpub.ErrNotExist && time.Now().Unix() > token.Expires {
		err = dao.DeleteToken(token.OauthToken)
		if err != nil {
			return
		}
	}

	oauthToken = token.OauthToken

	if err == pgpub.ErrNotExist || time.Now().Unix() > token.Expires {
		newToken := dao.PGToken{
			OauthToken: genOauthToken(uid),
			ClientId:   clientID,
			Expires:    time.Now().Add(7 * 24 * time.Hour).Unix(),
			Uid:        uid,
		}

		err = dao.CreateToken(&newToken)
		if err != nil {
			return
		}

		oauthToken = newToken.OauthToken
	}

	return
}

func RefreshOauthToken(uid int, clientID string, oldOauthToken string) (oauthToken string, err error) {
	token, err := dao.QueryToken(oldOauthToken)
	if err != nil {
		return
	}

	if token.OauthToken == "" {
		err = fmt.Errorf("%v not exists", oldOauthToken)
		return
	}

	err = dao.DeleteToken(token.OauthToken)
	if err != nil {
		return
	}

	return GetOauthToken(uid, clientID)
}

//时间戳+随机数+用户ID
func genOauthToken(uid int) (oauthToken string) {
	now := time.Now()
	rand.Seed(now.UnixNano())
	oauthToken = fmt.Sprintf("%v#%v#%v", now.Unix(), uid, rand.Int())

	if len(oauthToken) < 32 {
		oauthToken += pgpub.RepeatChar("0", "", 32-len(oauthToken))
	} else if len(oauthToken) > 32 {
		oauthToken = oauthToken[0:32]
	}

	return oauthToken
}

func GetUidFromToken(token string) (int64, error) {
	uid, err := strconv.ParseInt(strings.Split(token, "#")[1], 10, 64)
	if err != nil {
		seelog.Error(err)
	}
	return uid, err
}

func CheckToken(oauthToken string) (bool, error) {
	return dao.IfTokenExists(oauthToken)
}