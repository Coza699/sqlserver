-- Variables to be used in the script
DECLARE @name VARCHAR(50) -- the name of the database
DECLARE @strSQL nvarchar(150) -- the SQL that will be executed against each database
 
USE Master
 
-- Declare a cursor that will return all user databases
DECLARE db_cursor CURSOR FOR
SELECT name
FROM master.dbo.sysdatabases
WHERE name NOT IN ( 'master','model','msdb','tempdb')
 
OPEN db_cursor
FETCH NEXT FROM db_cursor INTO @name -- Bring the first database name into the @name variable
 
WHILE @@FETCH_STATUS = 0 -- loop through each of the databases, until no records left
BEGIN
-- Create a SQL statement that will be executed
SET @strSQL = 'ALTER DATABASE [' + @name + '] SET RECOVERY SIMPLE' -- Concatenate the SQL statement with the database name variable
EXEC SP_EXECUTESQL @strSQL -- run the statement
 
FETCH NEXT FROM db_cursor INTO @name -- Return the database
END
 
CLOSE db_cursor -- Without closing & deallocating the cursor, running the same code will generate a failure
DEALLOCATE db_cursor