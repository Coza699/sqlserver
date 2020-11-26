/**************************************************************************
Create by: Richard Cahill 
Date Created: 25/11/2019
Purpose: Template used for Database restore.  Need to convert this into a smart Powershell command
Git:  
**************************************************************************/


RESTORE FILELISTONLY 
   FROM DISK=''


       RESTORE DATABASE RCTESTRESTORE FROM 
              DISK = 'D:\DBATasks\DatabaseBackups\RCTEST\b1.bak', 
              DISK = 'D:\DBATasks\DatabaseBackups\RCTEST\b2.bak'
              WITH MOVE 'RCTEST' TO 'D:\DBATasks\DatabaseBackups\RCTEST\RCTESTRESTORE.mdf',
                   MOVE 'RCTest_log' TO 'D:\DBATasks\DatabaseBackups\RCTEST\RCTESTRESTORE.ldf',
--		NORECOVERY 
--		PASSWORD = ''


RESTORE DATABASE RCTEST FROM 
              DISK = 'G:\Temp\RCTEST.bak'
              WITH MOVE 'RCTEST' TO 'D:\Data\rctest.mdf',
                   MOVE 'RCTEST_Log' TO 'L:\Logs\rctest.ldf',
                   PASSWORD = '9595D6DD-700E-4846-969D-AFC5F7B64825'
--		NORECOVERY 



RESTORE LOG TestCopyDB_DR FROM DISK = 'D:\Backup\backup.trn' WITH NORECOVERY
GO
