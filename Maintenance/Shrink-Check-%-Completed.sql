SELECT Percent_complete, start_time, status, command, estimated_completion_time, 
(estimated_completion_time /1000) /3600.0 as estimated_Time, cpu_time, total_elapsed_time,
(total_elapsed_time /1000) /3600.0  as elapsed_time
FROM sys.dm_exec_requests
WHERE command = 'DbccFilesCompact'
