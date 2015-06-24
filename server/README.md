# 接口说明
---
## 1. 注册

* URL http://www.polyge.com/register

* Method Get

* args:

	| ARG       |TYPE  | NULL | MEMO |
	| --------- |----  |----- | ---- |
	| user_name |string| Y    | uname/phone/email 三选一,优先级从上到下     |
	| phone     |string| Y    | uname/phone/email 三选一,优先级从上到下     |
	| email     |string| Y    | uname/phone/email 三选一,优先级从上到下     |
	| user_type |int   | N    | 1:student 2:teacher |
	| pwd       |string| N    |      |


* return:
 	
	 {"success":true}
	 
	 {"success":false, "msg":"xxxxx"}
	
---
## 2. 校验用户是否存在

* URL http://www.polyge.com/check_user_exists

* Method Get

* args:

	| ARG       |TYPE  | NULL | MEMO |
	| --------- |----  |----- | ---- |
	| user_name |string| Y    | uname/phone/email 三选一,优先级从上到下     |
	| phone     |string| Y    | uname/phone/email 三选一,优先级从上到下     |
	| email     |string| Y    | uname/phone/email 三选一,优先级从上到下     |
	
* return:
 	
	 {"result":true}
	 
     {"result":false}
	
	
---
## 3. 登录

* URL http://www.polyge.com/login

* Method Get

* args:

	| ARG       |TYPE  | NULL | MEMO |
	| --------- |----  |----- | ---- |
	| uname     |string| N    |      |
	| pwd       |string| N    |      |
	| client_id |int   | N    | 目前传123即可 |
	
* return:
 	
	 {
       	"Success": true,
  		"Msg": "",
  		"Result": {
    		"token": "14344422025049569583096408908100",
		    "uid": 1,
		    "uname": "lankc",
		    "gender": 1,
		    "user_type": 1
		}
	}
	
	
	{
  		"success": false,
  		"msg": "user not found",
		"rs": ""
	}
	
	{
  		"success": false,
  		"msg": "password error",
  		"rs": ""
	}

---
## 4. 注销登录

* URL http://www.polyge.com/logout

* Method Get

* args:

	| ARG       |TYPE  | NULL | MEMO |
	| --------- |----  |----- | ---- |
	| token     |string| N    |      |
	
* return:
 	
	 {"success":true,"msg":"","rs":""}
	
	
---
## 5. 重新获取Token

* URL http://www.polyge.com/refresh_token

* Method Get

* args:

	| ARG       |TYPE  | NULL | MEMO |
	| --------- |----  |----- | ---- |
	| uid       |string| N    |      |
	| client_id |int   | N    | 目前传123即可 |
	| token     |string| N    |旧的token      |
	
* return:
 	
	{"success": true, "msg": "","rs": "14344491154788223115033674944100"}
	
	
---
	
## 6. websocket连接

* URL ws://www.polyge.com/wsconn

* Method Get

* args:

	| ARG       |TYPE  | NULL | MEMO |
	| --------- |----  |----- | ---- |
	| uid       |string| N    |      |
	| token     |string| N    |      |
	
* return:
 	
	根据statuscode判断是否连接成功
	
	msg 格式(大端序) uid(8位)+目标uid(8位)+msgID(8位)+时间戳毫秒(8位)+数据(N位)+CRC32校验码(4位)
	
	msgID目前没用到,先设为0吧
	
---
 



