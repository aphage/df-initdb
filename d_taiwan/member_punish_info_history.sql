use `d_taiwan`;

DROP PROCEDURE IF EXISTS delete_member_punish_info_history_tables;

DELIMITER $$
CREATE PROCEDURE delete_member_punish_info_history_tables()
BEGIN
    SET @save_group_concat_max_len = @@group_concat_max_len;
    SET SESSION group_concat_max_len = 10240;

	SELECT CONCAT('DROP TABLE IF EXISTS ', GROUP_CONCAT(CONCAT('`', table_name, '`')))
	INTO @sql
	FROM information_schema.TABLES
	WHERE table_schema = DATABASE()
	AND table_name LIKE 'member_punish_info_history_%';

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

CALL delete_member_punish_info_history_tables();



DROP PROCEDURE IF EXISTS create_member_punish_info_history_tables;

DELIMITER $$
CREATE PROCEDURE create_member_punish_info_history_tables(IN size INT)
BEGIN
	DECLARE i INT DEFAULT 0;
    DECLARE current_year INT DEFAULT 0;
	DECLARE table_name VARCHAR(128) DEFAULT '';

	SET current_year = YEAR(CURDATE());
	WHILE i < size DO
        SET table_name = CONCAT('member_punish_info_history_', current_year + i);
        SET @sql = CONCAT('CREATE TABLE IF NOT EXISTS `', table_name, '` (
		    `no` int(11) NOT NULL auto_increment,
            `m_id` int(11) NOT NULL default \'0\',
            `punish_type` int(11) NOT NULL default \'0\',
            `occ_time` datetime NOT NULL default \'0000-00-00 00:00:00\',
            `punish_value` int(11) NOT NULL default \'0\',
            `apply_flag` tinyint(4) NOT NULL default \'0\',
            `start_time` datetime NOT NULL default \'0000-00-00 00:00:00\',
            `end_time` datetime NOT NULL default \'0000-00-00 00:00:00\',
            `admin_id` varchar(25) default NULL,
            `reason` varchar(100) default NULL,
            `is_kicked` tinyint(4) default NULL,
            `first_ssn` varchar(32) default NULL,
            `second_ssn` varchar(32) default NULL,
            PRIMARY KEY  (`no`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8');
        PREPARE stmt FROM @sql;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
        SET i = i + 1;

		SET @sql = NULL;
    END WHILE;
END$$
DELIMITER ;

CALL create_member_punish_info_history_tables(20);