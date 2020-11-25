/**************************************************************************
Create by: Richard Cahill 
Date Created: 11/03/2020
Purpose: Script is to backup all user databases on an SQL Server Instance
Git:  
**************************************************************************/

DECLARE @name VARCHAR(50) -- database name  
DECLARE @path VARCHAR(256) -- path for backup files  
DECLARE @fileName VARCHAR(256) -- filename for backup  
DECLARE @fileDate VARCHAR(20) -- used for file name
 
-- specify database backup directory
SET @path = '\\ServerName\dir\'  
 
-- specify filename format
SELECT @fileDate = CONVERT(VARCHAR(20),GETDATE(),112) 
 
DECLARE db_cursor CURSOR READ_ONLY FOR  
SELECT name 
FROM master.sys.databases 
WHERE name NOT IN ('master','model','msdb','tempdb', 'DBAUtility')  -- exclude these databases
AND state = 0 -- database is online
AND is_in_standby = 0 -- database is not read only for log shipping
 
OPEN db_cursor   
FETCH NEXT FROM db_cursor INTO @name   
 
WHILE @@FETCH_STATUS = 0   
BEGIN   
   SET @fileName = @path + '\' + @name +'.Bak'
   PRINT  @fileName 
   BACKUP DATABASE @name TO DISK = @fileName WITH COMPRESSION
 
   FETCH NEXT FROM db_cursor INTO @name   
END   
