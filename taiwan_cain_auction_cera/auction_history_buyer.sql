use `taiwan_cain_auction_cera`;

DROP PROCEDURE IF EXISTS delete_auction_history_buyer_tables;

DELIMITER $$
CREATE PROCEDURE delete_auction_history_buyer_tables()
BEGIN
    SET @save_group_concat_max_len = @@group_concat_max_len;
    SET SESSION group_concat_max_len = 10240;

	SELECT CONCAT('DROP TABLE IF EXISTS ', GROUP_CONCAT(CONCAT('`', table_name, '`')))
	INTO @sql
	FROM information_schema.TABLES
	WHERE table_schema = DATABASE()
	AND table_name LIKE 'auction_history_buyer_%';

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

CALL delete_auction_history_buyer_tables();



DROP PROCEDURE IF EXISTS create_auction_history_buyer_tables;

DELIMITER $$
CREATE PROCEDURE create_auction_history_buyer_tables(IN size INT)
BEGIN
	DECLARE i INT DEFAULT 0;
    DECLARE _current_date DATE DEFAULT CURDATE();
	DECLARE table_name VARCHAR(128) DEFAULT '';

	WHILE i < size DO
        SET table_name = CONCAT('auction_history_buyer_', DATE_FORMAT(DATE_ADD(_current_date, INTERVAL i MONTH), '%Y%m'));
        SET @sql = CONCAT('CREATE TABLE IF NOT EXISTS `', table_name, '` (
			`auction_id` bigint(20) unsigned default NULL,
            `occ_time` datetime default NULL,
            `pre_buyer_id` int(11) default NULL,
            `buyer_id` int(11) default NULL,
            `pre_price` int(11) default NULL,
            `price` int(11) default NULL,
            `pre_buyer_postal_id` int(10) unsigned default NULL,
            KEY `idx_auction_id` USING BTREE (`auction_id`),
            KEY `idx_buyer_id` USING BTREE (`buyer_id`)
			) ENGINE=InnoDB DEFAULT CHARSET=utf8');
        PREPARE stmt FROM @sql;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
        SET i = i + 1;

		SET @sql = NULL;
    END WHILE;
END$$
DELIMITER ;

CALL create_auction_history_buyer_tables(12 * 12);