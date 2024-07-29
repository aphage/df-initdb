use `taiwan_cain_auction_gold`;

DROP PROCEDURE IF EXISTS delete_auction_history_tables;

DELIMITER $$
CREATE PROCEDURE delete_auction_history_tables()
BEGIN
    SET @save_group_concat_max_len = @@group_concat_max_len;
    SET SESSION group_concat_max_len = 10240;

	SELECT CONCAT('DROP TABLE IF EXISTS ', GROUP_CONCAT(CONCAT('`', table_name, '`')))
	INTO @sql
	FROM information_schema.TABLES
	WHERE table_schema = DATABASE()
	AND table_name LIKE 'auction_history_%'
    AND table_name NOT LIKE 'auction_history_buyer%';

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

CALL delete_auction_history_tables();



DROP PROCEDURE IF EXISTS create_auction_history_tables;

DELIMITER $$
CREATE PROCEDURE create_auction_history_tables(IN size INT)
BEGIN
	DECLARE i INT DEFAULT 0;
    DECLARE _current_date DATE DEFAULT CURDATE();
	DECLARE table_name VARCHAR(128) DEFAULT '';

	WHILE i < size DO
        SET table_name = CONCAT('auction_history_', DATE_FORMAT(DATE_ADD(_current_date, INTERVAL i MONTH), '%Y%m'));
        SET @sql = CONCAT('CREATE TABLE IF NOT EXISTS `', table_name, '` (
			`auction_id` bigint(20) unsigned NOT NULL default \'0\',
            `start_time` datetime default NULL,
            `occ_time` datetime default NULL,
            `event_type` tinyint(4) default NULL,
            `owner_id` int(11) default NULL,
            `buyer_id` int(11) default NULL,
            `price` int(11) default NULL,
            `seal_flag` tinyint(4) default NULL,
            `item_id` int(10) unsigned default NULL,
            `add_info` int(11) default NULL,
            `upgrade` tinyint(3) unsigned default NULL,
            `amplify_option` tinyint(3) unsigned NOT NULL default \'0\',
            `amplify_value` mediumint(8) unsigned NOT NULL default \'0\',
            `seal_cnt` tinyint(3) unsigned default NULL,
            `endurance` smallint(5) unsigned default NULL,
            `extend_info` int(10) unsigned default NULL,
            `owner_postal_id` int(10) unsigned default NULL,
            `buyer_postal_id` int(10) unsigned default NULL,
            `expire_time` int(10) unsigned NOT NULL default \'0\',
            `unit_price` int(10) unsigned NOT NULL default \'0\',
            `random_option` varchar(14) NOT NULL default \'\',
            `roi_high_key` bigint(20) NOT NULL default \'0\',
            `roi_low_key` int(11) NOT NULL default \'0\',
            `seperate_upgrade` tinyint(3) unsigned NOT NULL default \'0\',
            `commission` int(11) unsigned NOT NULL default \'0\',
            `owner_type` tinyint(3) unsigned NOT NULL default \'0\',
            `item_guid` varbinary(10) NOT NULL default \'\',
            PRIMARY KEY  (`auction_id`),
            KEY `idx_owner_id` USING BTREE (`owner_id`),
            KEY `idx_buyer_id` USING BTREE (`buyer_id`),
            KEY `idx_occ_time` USING BTREE (`occ_time`)
			) ENGINE=InnoDB DEFAULT CHARSET=utf8');
        PREPARE stmt FROM @sql;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
        SET i = i + 1;

		SET @sql = NULL;
    END WHILE;
END$$
DELIMITER ;

CALL create_auction_history_tables(12 * 12);