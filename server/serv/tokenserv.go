package serv

import (
	"github.com/lankecheng/polyge/server/dao"
	"github.com/lankecheng/polyge/server/pgpub"
	"math/rand"
	"strconv"
	"time"
	"fmt"
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
	oauthToken = strconv.FormatInt(now.Unix(), 10)

	rand.Seed(now.UnixNano())
	oauthToken += strconv.Itoa(rand.Int())
	oauthToken += strconv.Itoa(uid)

	if len(oauthToken) < 32 {
		oauthToken += pgpub.RepeatChar("0", "", 32-len(oauthToken))
	} else if len(oauthToken) > 32 {
		oauthToken = oauthToken[0:32]
	}

	return oauthToken
}

func CheckOauthToken(oauthToken string) (ok bool, err error) {
	token, err := dao.QueryToken(oauthToken)
	if err != nil {
		return
	}

	ok = time.Now().Unix() <= token.Expires
	return
}
