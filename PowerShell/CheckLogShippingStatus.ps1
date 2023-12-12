function CheckLogShipping
{ [CmdletBinding()]
	Param(
        [String[]]$ServerInstances		
	)

    $query = "IF ( OBJECT_ID('tempdb..#templogshipping') ) IS NOT NULL
                    BEGIN
                        DROP TABLE #templogshipping;
                    END;
 
                CREATE TABLE #templogshipping
                (
                  Status BIT ,
                  IsPrimary BIT ,
                  Server VARCHAR(100) ,
                  DatabaseName VARCHAR(100) ,
                  TimeSinceLastBackup INT ,
                  LastBackupFile VARCHAR(255) ,
                  BackupThresshold INT ,
                  IsBackupAlertEnabled BIT ,
                  TimeSinceLastCopy INT ,
                  LastCopiedFile VARCHAR(255) ,
                  TimeSinceLastRestore INT ,
                  LastRestoredFile VARCHAR(255) ,
                  LastRestoredLatency INT ,
                  RestoreThresshold INT ,
                  IsRestoreAlertEnabled BIT
                );
 
                INSERT INTO #templogshipping
                        ( Status ,
                        IsPrimary ,
                        Server ,
                        DatabaseName ,
                        TimeSinceLastBackup ,
                        LastBackupFile ,
                        BackupThresshold ,
                        IsBackupAlertEnabled ,
                        TimeSinceLastCopy ,
                        LastCopiedFile ,
                        TimeSinceLastRestore ,
                        LastRestoredFile ,
                        LastRestoredLatency ,
                        RestoreThresshold ,
                        IsRestoreAlertEnabled
                        )
                        EXEC master.sys.sp_help_log_shipping_monitor
                        SELECT * FROM #templogshipping"


    $RtnObject =@()

    foreach($InstanceName in $ServerInstances)
    {
        $results = Invoke-Sqlcmd -Query $query -ServerInstance $InstanceName

         foreach ($result in $results)
         {
            # Setup a variable to hold the errors
            $statusDetails = @()

            # Check the status, if true then something is wrong
            if ($result.Status) 
            {
                # Check if the row is for primary instance
               if ($result.IsPrimary) 
               {  
                    # Check the backup
                    if (-not $result.TimeSinceLastBackup) 
                    {
                        $statusDetails += "The backup has never been done."
                     }
                     elseif ($result.TimeSinceLastBackup -ge $result.BackupThresshold) {
                        $statusDetails += "The backup has not been executed in the last $($result.BackupThresshold) minutes"   
                     }
               }
               elseif (-not $result.IsPrimary) 
               {
                    if($InstanceName -eq $result.Server)
                    {
                        # Check the restore on secondary
                        if ($null -eq $result.TimeSinceLastRestore) {
                            $statusDetails += "The restore has never been done."
                        }
                        elseif ($result.TimeSinceLastRestore -ge $result.RestoreThresshold) {
                                    $statusDetails += "The restore has not been executed in the last $($result.RestoreThresshold) minutes"
                        }
                    }
               }  
       
                if($statusDetails)
                {
                    #Create PS return object
                    $object = [PSCustomObject]@{
                        ServerName = $result.Server
                        DatabaseName = $result.DatabaseName
                        Status  = $statusDetails -join ","
                    } 

                    $RtnObject += $object 
                }
      
 
            }
 
         }
     }

     Return $RtnObject

}