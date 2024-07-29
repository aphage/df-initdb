use d_taiwan;

SET @MYSQL_IP = '127.0.0.1';
SET @MYSQL_PORT = '3306';
SET @MYSQL_USER = 'game';
SET @MYSQL_SECURITY_PASSWORD = '3eac770018a08951e8b10c1f8bc3595be8b10c1f8bc3595b';

UPDATE db_connect SET `db_ip` = @MYSQL_IP, `db_port` = @MYSQL_PORT, `db_userid` = @MYSQL_USER, `db_passwd` = @MYSQL_SECURITY_PASSWORD
