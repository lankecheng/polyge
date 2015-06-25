package dao

import (
	"github.com/cihub/seelog"
	"github.com/lankecheng/polyge/server/pgpub"
)

type PGToken struct {
	OauthToken string
	ClientId   string
	Expires    int64
	Scope      string
	Uid        int
}

func IfTokenExists(token string) (exists bool, err error) {
	err = db.Ping()
	if err != nil {
		seelog.Errorf("token %v ping mysql %v", token, err)
		return
	}

	rs, err := db.Query("select 1 from pg_token where oauth_token=?", token)
	if err != nil {
		seelog.Errorf("token %v query %v", token, err)
	}

	exists = rs.Next()
	if err = rs.Err(); err != nil {
		seelog.Errorf("token %v read rows %v", token, err)
	}

	return
}

func CreateToken(token *PGToken) (err error) {
	return DBCreateExcludeFlds(token)
}

func DeleteToken(token string) (err error) {
	err = db.Ping()
	if err != nil {
		seelog.Errorf("token %v ping mysql %v", token, err)
		return
	}

	delSql := "delete from pg_token where oauth_token=?"
	_, err = db.Exec(delSql, token)
	if err != nil {
		seelog.Errorf("token %v exec sql[%v] %v", token, delSql, err)
	}

	return
}

func QueryTokenByUidClientID(uid int, clientID string) (token PGToken, err error) {
	err = db.Ping()
	if err != nil {
		seelog.Errorf("uid %v clientID %v ping mysql %v", uid, clientID , err)
		return
	}

	qrySql := "select oauth_token,client_id,expires,scope,uid from pg_token where uid=? and client_id=?"
	rs, err := db.Query(qrySql, uid, clientID)
	if err != nil {
		seelog.Errorf("uid %v clientID %v query sql %v", uid, clientID , err)
		return
	}

	if rs.Next() {
		if err = rs.Err(); err != nil {
			seelog.Errorf("uid %v clientID %v read rows %v", uid, clientID , err)
			return
		}
		rs.Scan(&token.OauthToken, &token.ClientId, &token.Expires, &token.Scope, &token.Uid)
	} else {
		err = pgpub.ErrNotExist
	}

	return
}

func QueryToken(oauthToken string) (token PGToken, err error) {
	err = db.Ping()
	if err != nil {
		seelog.Errorf("token %v ping mysql %v", oauthToken, err)
		return
	}

	qrySql := "select oauth_token,client_id,expires,scope,uid from pg_token where oauth_token=?"
	rs, err := db.Query(qrySql, oauthToken)
	if err != nil {
		seelog.Errorf("token %v qry sql %v %v", oauthToken, qrySql, err)
	}

	if rs.Next() {
		rs.Scan(&token.OauthToken, &token.ClientId, &token.Expires, &token.Scope, &token.Uid)
	}

	if err = rs.Err(); err != nil {
		seelog.Errorf("token %v read rows %v", oauthToken, err)
	}

	return
}