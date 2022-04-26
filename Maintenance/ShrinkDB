--Shrink DB last assigned extent, done after a big deletetion process.
DBCC SHRINKDATABASE (AdventureWorks2012, TRUNCATEONLY);  

--Shrink Database
 DBCC SHRINKDATABASE ('AdventureWorks2012');


--Find the percentage completed for Shrink

SELECT percent_complete, estimated_completion_time
  FROM sys.dm_exec_requests
  WHERE session_id = <spid>;
