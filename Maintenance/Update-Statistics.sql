/**************************************************************************
Create by: Richard Cahill 
Date Created: 25/02/2019
Purpose: Script to update SQL Statistics if they have not been updated in the last 24hour but have greater than 10 modified rows.
Git:  
**************************************************************************/


--Set the thresholds when to consider the statistics outdated
DECLARE @hours int
DECLARE @modified_rows int
DECLARE @update_statement nvarchar(300);

SET @hours=24
SET @modified_rows=10

--Update all the outdated statistics
DECLARE statistics_cursor CURSOR FOR
SELECT 'UPDATE STATISTICS '+OBJECT_NAME(id)+' '+name
FROM sys.sysindexes
WHERE STATS_DATE(id, indid)<=DATEADD(HOUR,-@hours,GETDATE()) 
AND rowmodctr>=@modified_rows 
AND id IN (SELECT object_id FROM sys.tables)
 
OPEN statistics_cursor;
FETCH NEXT FROM statistics_cursor INTO @update_statement;
 
 WHILE (@@FETCH_STATUS <> -1)
 BEGIN
  EXECUTE (@update_statement);
  PRINT @update_statement;
 
 FETCH NEXT FROM statistics_cursor INTO @update_statement;
 END;
 
 PRINT 'The outdated statistics have been updated.';
CLOSE statistics_cursor;
DEALLOCATE statistics_cursor;
GO