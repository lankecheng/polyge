DROP TABLE IF EXISTS `pg_user`;
CREATE TABLE `pg_user` (
  `uid`         INT(10) UNSIGNED AUTO_INCREMENT,
  `uname`       VARCHAR(30)         NOT NULL DEFAULT '',
  `pwd`         VARCHAR(30)         NOT NULL,
  `phone`       VARCHAR(50)         NOT NULL DEFAULT '',
  `email`       VARCHAR(100)        NOT NULL DEFAULT '',
  `gender`      TINYINT(3) UNSIGNED NOT NULL DEFAULT '0',
  `language`    INT(10) UNSIGNED    NOT NULL DEFAULT '0',
  `occup`       VARCHAR(20)         NOT NULL DEFAULT '',
  `user_type`   TINYINT(3) UNSIGNED NOT NULL DEFAULT '0' COMMENT '1:student,2:teacher',
  `avatar`      VARCHAR(255)        NOT NULL DEFAULT '' COMMENT '头像地址',
  `audio`       VARCHAR(255)        NOT NULL DEFAULT '' COMMENT '语音地址',
  `birth`       INT(10) UNSIGNED    NOT NULL DEFAULT '0',
  `country`     INT(10) UNSIGNED    NOT NULL DEFAULT '0',
  `province`    INT(10) UNSIGNED    NOT NULL DEFAULT '0',
  `city`        INT(10) UNSIGNED    NOT NULL DEFAULT '0',
  `created_at`  INT(10) UNSIGNED    NOT NULL DEFAULT '0',
  `description` VARCHAR(200)        NOT NULL DEFAULT '',
  `interest`    VARCHAR(100)        NOT NULL DEFAULT '',
  PRIMARY KEY (`uid`)
)
  ENGINE = InnoDB
  DEFAULT CHARSET = utf8;

DROP TABLE IF EXISTS `pg_token`;
CREATE TABLE `pg_token` (
  `oauth_token` CHAR(32)         NOT NULL,
  `client_id`   VARCHAR(64)      NOT NULL,
  `expires`     INT(11)          NOT NULL,
  `scope`       VARCHAR(200)     NOT NULL DEFAULT '',
  `uid`         INT(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`oauth_token`),
  KEY `uid` (`uid`, `client_id`) USING BTREE
)
  ENGINE = InnoDB
  DEFAULT CHARSET = utf8;