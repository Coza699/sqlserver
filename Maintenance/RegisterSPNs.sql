/**************************************************************************
Create by: Richard Cahill 
Date Created: 12/03/2020
Purpose: Used to delete and reregister SPNs
Git:  
**************************************************************************/

--Check type of authentication
SELECT auth_scheme FROM sys.dm_exec_connections

--Delete SPN
SetSPN -d "MSSQLSvc/SERVER1.domain.local:SERVER1" "domain\ServiceAccount"
 SetSPN -d "MSSQLSvc/SERVER1.domain.local:1433" "domain\ServiceAccount"

   
--Add SPN
SetSPN -s "MSSQLSvc/SERVER1.domain.local:SERVER1" "domain\ServiceAccount"
SetSPN -s "MSSQLSvc/SERVER1.domain.local:1433" "domain\ServiceAccount"