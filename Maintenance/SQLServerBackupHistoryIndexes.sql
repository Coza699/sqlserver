/**************************************************************************
Create by: Richard Cahill 
Date Created: 15/04/2020
Purpose: Script is to apply SQL Server backup indexes
Git:  
**************************************************************************/

USE msdb
GO

-- create indexes on the backupset column

CREATE INDEX  IX_backupset_backup_set_iid ON backupset(backup_set_id)
GO
CREATE INDEX IX_backupset_backup_set_uuiid ON backupset(backup_set_uuid)
GO
CREATE INDEX IX_backupset_media_set_iid ON backupset(media_set_id)
GO
CREATE INDEX IX_backupset_backup_finish_date_i ON backupset(backup_finish_date)
GO
CREATE INDEX IX_backupset_backup_start_date_i ON backupset(backup_start_date)
GO

-- create index on the backupmediaset column 

CREATE INDEX IX_backupmediaset_media_set_iid ON backupmediaset(media_set_id)
GO

-- create index on the backupfile column 

CREATE INDEX IX_backupfile_backup_set_iid ON backupfile(backup_set_id)
GO

-- create index on the backupmediafamily column 

CREATE INDEX IX_backupmediafamily_media_set_iid ON backupmediafamily(media_set_id)
GO

-- create indexes on the restorehistory column

CREATE INDEX IX_restorehistory_restore_history_iid ON restorehistory(restore_history_id)
GO
CREATE INDEX IX_restorehistory_backup_set_iid ON restorehistory(backup_set_id)
GO

-- create index on the restorefile column

CREATE INDEX IX_restorefile_restore_history_iid ON restorefile(restore_history_id)
GO

--create index on the restorefilegroup column

CREATE INDEX IX_restorefilegroup_restore_history_iid ON restorefilegroup(restore_history_id)
GO

/*
USE msdb;
GO
EXEC sp_delete_backuphistory @oldest_date = '01/01/2020';

*/

