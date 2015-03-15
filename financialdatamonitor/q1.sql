INSERT INTO `forexdb`.`gbpchf` 
	(`id`, 
	`nypricetime`, 
	`bjquerytime`, 
	`rate`, 
	`ask`, 
	`bid`
	)
	VALUES
	('0', 
	'2013-09-05 21:58:00 ', 
	'2013-09-05 10:00:03 ', 
	'1.4619', 
	'1.4624', 
	'1.4615'
	);
	
	
	SELECT * FROM gbpchf ORDER BY id DESC LIMIT 2
	
	
	SHOW VARIABLES LIKE 'max_connections'
	
	SHOW PROCESSLIST
	
	SHOW STATUS LIKE '%Threads_connected%';
	
	SHOW VARIABLES LIKE ‘%timeout%’;
	
	SET GLOBAL max_connections=600 
	
	
	SELECT 1