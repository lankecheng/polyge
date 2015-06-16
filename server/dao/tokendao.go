package dao

import (
	"github.com/cihub/seelog"
)

type Token struct {
	OauthToken string
	ClientID   int
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

	rs, err := db.Query("select 1 from token where oauth_token=?", token)
	if err != nil {
		seelog.Errorf("token %v query %v", token, err)
	}

	if err = rs.Err(); err != nil {
		seelog.Errorf("token %v read rows %v", token, err)
	}

	return rs.Next(), err
}

func CreateToken(token *Token) (err error) {
	err = db.Ping()
	if err != nil {
		seelog.Errorf("token %v ping mysql %v", token, err)
		return
	}

	insertSql := "insert into token values(?,?,?,?,?)"
	args := make([]interface{}, 5)
	args[0] = token.OauthToken
	args[1] = token.ClientID
	args[2] = token.Expires
	args[3] = token.Scope
	args[4] = token.Uid

	_, err = db.Exec(insertSql, args...)
	if err != nil {
		seelog.Errorf("token %v exec sql %v %v", token, insertSql, err)
	}

	return
}

func DeleteToken(token string) (err error) {
	err = db.Ping()
	if err != nil {
		seelog.Errorf("token %v ping mysql %v", token, err)
		return
	}

	delSql := "delete from token where oauth_token=?"
	_, err = db.Exec(delSql, delSql)
	if err != nil {
		seelog.Errorf("token %v exec sql %v %v", token, delSql, err)
	}

	return
}

func QueryTokenByUidClientID(uid int, clientID int) (token Token, err error) {
	err = db.Ping()
	if err != nil {
		seelog.Errorf("uid %v clientID %v ping mysql %v", uid, clientID , err)
		return
	}

	qrySql := "select oauth_token,client_id,expires,scope,uid from token where uid=? and client_id=?"
	rs, err := db.Query(qrySql, uid, clientID)
	if err != nil {
		seelog.Errorf("uid %v clientID %v query sql %v", uid, clientID , err)
	}

	if rs.Next() {
		rs.Scan(&token.OauthToken, &token.ClientID, &token.Expires, &token.Scope, &token.Uid)
	}

	if err = rs.Err(); err != nil {
		seelog.Errorf("uid %v clientID %v read rows %v", uid, clientID , err)
	}

	return
}

func QueryToken(oauthToken string) (token Token, err error) {
	err = db.Ping()
	if err != nil {
		seelog.Errorf("token %v ping mysql %v", oauthToken, err)
		return
	}

	qrySql := "select oauth_token,client_id,expires,scope,uid from token where oauth_token=?"
	rs, err := db.Query(qrySql, oauthToken)
	if err != nil {
		seelog.Errorf("token %v qry sql %v %v", oauthToken, qrySql, err)
	}

	if rs.Next() {
		rs.Scan(&token.OauthToken, &token.ClientID, &token.Expires, &token.Scope, &token.Uid)
	}

	if err = rs.Err(); err != nil {
		seelog.Errorf("token %v read rows %v", oauthToken, err)
	}

	return
}