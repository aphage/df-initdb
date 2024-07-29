use `taiwan_cain_log`;

DROP PROCEDURE IF EXISTS delete_log_response_time_tables;

DELIMITER $$
CREATE PROCEDURE delete_log_response_time_tables()
BEGIN
    SET @save_group_concat_max_len = @@group_concat_max_len;
    SET SESSION group_concat_max_len = 10240;

	SELECT CONCAT('DROP TABLE IF EXISTS ', GROUP_CONCAT(CONCAT('`', table_name, '`')))
	INTO @sql
	FROM information_schema.TABLES
	WHERE table_schema = DATABASE()
	AND table_name LIKE 'log_response_time_%';

	IF @sql IS NOT NULL AND LENGTH(@sql) > 0 THEN
		PREPARE stmt FROM @sql;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;
	END IF;

	SET @sql = NULL;
    SET SESSION group_concat_max_len = @save_group_concat_max_len;
    SET @save_group_concat_max_len = NULL;
END$$
DELIMITER ;

CALL delete_log_response_time_tables();



DROP PROCEDURE IF EXISTS create_log_response_time_tables;

DELIMITER $$
CREATE PROCEDURE create_log_response_time_tables(IN size INT)
BEGIN
	DECLARE i INT DEFAULT 0;
    DECLARE _current_date DATE DEFAULT CURDATE();
	DECLARE table_name VARCHAR(128) DEFAULT '';

	WHILE i < size DO
        SET table_name = CONCAT('log_response_time_', DATE_FORMAT(DATE_ADD(_current_date, INTERVAL i MONTH), '%Y%m'));
        SET @sql = CONCAT('CREATE TABLE IF NOT EXISTS `', table_name, '` (
                `occ_time` datetime NOT NULL default \'0000-00-00 00:00:00\',
                `channel_no` int(11) NOT NULL default \'0\',
                `packet_id` int(10) unsigned NOT NULL default \'0\',
                `packet_count` int(10) unsigned NOT NULL default \'0\',
                `total_response_time` bigint(20) unsigned NOT NULL default \'0\',
                `avg_response_time` int(10) unsigned NOT NULL default \'0\',
                PRIMARY KEY  (`occ_time`,`channel_no`,`packet_id`)
                ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT=\'登录ID信息\'');
        PREPARE stmt FROM @sql;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
        SET i = i + 1;

		SET @sql = NULL;
    END WHILE;
END$$
DELIMITER ;

CALL create_log_response_time_tables(12 * 12);