SELECT @@SERVERNAME, 
                D.[name] AS [database_name], D.[recovery_model_desc] , 
                CASE WHEN BS_DATA.[database_name] IS NULL THEN 'N' ELSE 'Y' END AS DB_BACKUP, 
                CASE WHEN BS_LOG.[database_name] IS NULL THEN 'N' ELSE 'Y' END AS TRANS_LOG_BACKUP,
                CASE WHEN L.primary_database IS NULL THEN 'N' ELSE 'Y' END AS LOG_SHIPPED,
                BS_DATA.last_data_backup_date, BS_DATA.NAME AS Last_DB_Backup, BS_LOG.last_data_backup_date AS Last_Log_Backup, BS_LOG.name as Log_Backup,
                L.backup_directory as LOG_SHIPPED_DIRECTORY, L.backup_share AS LOG_SHIPPED_SHARE, L.last_backup_date AS LOG_SHIPPED_LAST_BACKUP
                FROM 
                sys.databases D
                LEFT JOIN msdb.dbo.log_shipping_primary_databases L
                ON D.name = L.primary_database
                 LEFT JOIN  
                ( 
	                SELECT * FROM (
		                SELECT BS.[database_name],  
		                BS.[backup_finish_date] AS [last_data_backup_date] , BS.NAME, ROW_NUMBER() OVER( PARTITION BY BS.[database_name] ORDER BY BS.[backup_finish_date] DESC) AS ROW_NUM
		                FROM msdb.dbo.backupset BS  
		                WHERE BS.type = 'D') A
	                WHERE ROW_NUM = 1
                   ) BS_DATA  
                ON D.[name] = BS_DATA.[database_name] 
                LEFT JOIN  
                ( 
	                SELECT * FROM (
		                SELECT BS.[database_name],  
		                BS.[backup_finish_date] AS [last_data_backup_date] , BS.NAME, ROW_NUMBER() OVER( PARTITION BY BS.[database_name] ORDER BY BS.[backup_finish_date] DESC) AS ROW_NUM
		                FROM msdb.dbo.backupset BS  
		                WHERE BS.type = 'L') A
	                WHERE ROW_NUM = 1
                ) BS_LOG
                ON D.[name] = BS_LOG.[database_name] 
                --WHERE 
                --D.[recovery_model_desc] <> 'SIMPLE' 
                --BS1.[last_log_backup_date] IS NULL OR BS1.[last_log_backup_date] < BS2.[last_data_backup_date] 
                ORDER BY D.[name];
